# ABSTRACT: App Module ad utilities for appspec tool
use strict;
use warnings;
use 5.010;
use utf8;
package App::AppSpec;
use Term::ANSIColor;

our $VERSION = '0.000'; # VERSION

use base 'App::Spec::Run';

sub read_spec {
    my ($self) = @_;
    my $parameters = $self->parameters;

    my $spec_file = $parameters->{spec_file};
    my $spec = App::Spec->read($spec_file);
    return $spec;
}

sub cmd_completion {
    my ($self) = @_;
    my $options = $self->options;
    my $parameters = $self->parameters;

    my $shell = $options->{zsh} ? "zsh" : $options->{bash} ? "bash" : '';
    die "Specify which shell" unless $shell;

    my $spec = $self->read_spec;
    my $completion = $spec->generate_completion(
        shell => $shell,
    );
    say $completion;
}

sub generate_pod {
    my ($self) = @_;
    my $parameters = $self->parameters;

    my $spec = $self->read_spec;
    my $pod = $spec->generate_pod(
    );
    say $pod;
}

sub colorize {
    my ($self) = @_;
    # TODO
    my $options = $self->options || {};
    my $color = $options->{color};
    my $env_color = $ENV{PERL5_APPSPEC_COLOR_OUTPUT} // 1;
    return unless -t STDOUT;
    return ($color || $env_color);
}

sub validate {
    my ($self) = @_;
    my $options = $self->options;
    my $parameters = $self->parameters;
    my $color = $self->colorize;

    my @errors;
    require App::AppSpec::Schema::Validator;
    my $validator = App::AppSpec::Schema::Validator->new;
    my $spec_file = $parameters->{spec_file};
    if (ref $spec_file eq 'SCALAR') {
        my $spec = YAML::XS::Load($$spec_file);
        @errors = $validator->validate_spec($spec);
    }
    else {
        @errors = $validator->validate_spec_file($spec_file);
    }
    binmode STDOUT, ":encoding(utf-8)";
    if (@errors) {
        print $validator->format_errors(\@errors);
        $color and print color 'red';
        say "Not valid!";
        $color and print color 'reset';
    }
    else {
        $color and print color 'bold green';
        say "Validated ✓";
        $color and print color 'reset';
    }
}

sub cmd_new {
    my ($self) = @_;
    my $options = $self->options;
    require File::Path;

    my $name = $options->{name};
    my $class = $options->{class};
    my $overwrite = $options->{overwrite};
    unless ($name =~ m/^\w[\w+-]*/) {
        die "Option name '$name': invalid app name";
    }
    unless ($class =~ m/^[a-zA-Z]\w*(::\w+)+$/) {
        die "Option class '$class': invalid classname";
    }
    my $dist = $class;
    $dist =~ s/::/-/g;
    if (-d $dist and not $overwrite) {
        die "Directory $dist already exists";
    }
    elsif (-d $dist) {
        say "Removing old $dist directory first";
        File::Path::remove_tree($dist);
    }
    my $spec = <<"EOM";
name: $name
appspec: { version: '0.001' }
class: $class
title: 'app title'
description: 'app description'
options:
- name: "some-option"
  type: "flag"
  summary: "option summary"
EOM
    if ($options->{"with-subcommands"}) {
            $spec .= <<"EOM";
subcommands:
    mycommand:
      summary: "Summary for mycommand"
      op: "mycommand"
      description: "Description for mycommand"
    parameters:
      - name: "myparam"
        summary: "Summary for myparam"
        required: 1
EOM
    }
    File::Path::make_path($dist);
    File::Path::make_path("$dist/share");
    my $specfile = "$dist/share/$name-spec.yaml";
    say "Writig spec to $specfile";
    open my $fh, ">", $specfile;
    print $fh $spec;
    close $fh;
}

1;

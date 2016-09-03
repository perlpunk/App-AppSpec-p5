# ABSTRACT: App Module ad utilities for appspec tool
use strict;
use warnings;
use 5.010;
use utf8;
package App::AppSpec;
use Term::ANSIColor;
use File::Basename qw/ dirname /;

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
    my $params = $self->parameters;
    my $dist_path = $params->{path};
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
    $dist = $dist_path // $dist;
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
    my $module = <<"EOM";
package $class;
use strict;
use warnings;
use feature qw/ say /;
use base 'App::Spec::Run';

sub mycommand \{
    my (\$self) = \@_;
    my \$options = \$self->options;
    my \$parameters = \$self->parameters;

    say "Hello world";
\}

1;
EOM
    my $script = <<"EOM";
#!/usr/bin/env perl
use strict;
use warnings;

use App::Spec;
use App::AppSpec;
use File::Share qw/ dist_file /;

my \$specfile = dist_file("$dist", "$name-spec.yaml");
my \$spec = App::Spec->read(\$specfile);
my \$run = \$spec->runner;
\$run->run;
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
    my $module_path = $class;
    $module_path =~ s#::#/#g;
    $module_path = "$dist/lib/$module_path.pm";
    File::Path::make_path($dist);
    File::Path::make_path("$dist/share");
    File::Path::make_path("$dist/bin");
    File::Path::make_path(dirname $module_path);
    my $specfile = "$dist/share/$name-spec.yaml";
    say "Writig spec to $specfile";
    open my $fh, ">", $specfile or die $!;
    print $fh $spec;
    close $fh;

    open $fh, ">", $module_path or die $!;
    print $fh $module;
    close $fh;

    open $fh, ">", "$dist/bin/$name" or die $!;
    print $fh $script;
    close $fh;
}

1;

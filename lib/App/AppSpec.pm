# ABSTRACT: Module for app-spec tool
use strict;
use warnings;
package App::AppSpec;
use 5.010;

our $VERSION = '0.000'; # VERSION

use base 'App::Spec::Run';

sub cmd_completion {
    my ($self) = @_;
    my $options = $self->options;
    my $parameters = $self->parameters;

    my $shell = $options->{zsh} ? "zsh" : $options->{bash} ? "bash" : '';
    die "Specify which shell" unless $shell;

    my $spec_file = $parameters->{spec_file};
    my $spec = App::Spec->read($spec_file);
    my $completion = $spec->generate_completion(
        shell => $shell,
    );
    say $completion;
}

sub generate_pod {
    my ($self) = @_;
    my $parameters = $self->parameters;

    my $spec_file = $parameters->{spec_file};
    my $spec = App::Spec->read($spec_file);
    my $pod = $spec->generate_pod(
    );
    say $pod;
}


1;

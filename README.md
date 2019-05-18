# appspec - A Tool for generating pod documentation and shell completion

`appspec` is a tool working with specifications for command line tools. These
specifications are typically written in YAML.

The specification for `appspec` itself can be found in
[`share/appspec-spec.yaml`](share/appspec-spec.yaml).

It supports commands with and without subcommands, short (`-v`) and
long options (`--version`) and nested subcommands.

For completion you can specify a static list of values, or you can call an
external command.
If your program is written in perl and using App::Spec itself, you can also
add a callback to your program. which allows quite intelligent completion.

## Usage

    appspec help

    # Generate completion
    appspec completion program.yaml --bash >program.bash
    appspec completion program.yaml --zsh >_program

    # Generate pod documentation
    appspec pod program.yaml program.pod
    # You could then use pod2man to create a manpage from it
    # pod2man program.pod ...

    # Generate a new perl App::Spec commandline tool skeleton
    appspec help new
    appspec new --name myprogram --class My::Program My-Program

## Examples

You can see a list of examples in my completion collection
[https://github.com/perlpunk/shell-completions].

In the [`jq`
file](https://github.com/perlpunk/shell-completions/blob/master/specs/jq.yaml)
you will see a simple example of a static list of values:

    - name: indent
      type: integer
      enum: [1,2,3,4,5,6,7,8]
      summary: indent output using given number of spaces

In the [`mpath`
file](https://github.com/perlpunk/shell-completions/blob/master/specs/mpath.yaml)
you can find an example of how to call an external command:

    parameters:
    - name: module
      summary: Module names
      multiple: true
      type: string
      completion:
        command_string: |
          perl -E'use ExtUtils::Installed;say for ExtUtils::Installed->new(skip_cwd=>1)->modules'

## Installation

This is a perl tool. In order to use it, you either need to install it from
CPAN, or try the standalone version.

It should work for any perl version 5.10 or higher.

### CPAN installation

You need to install the CPAN module App::AppSpec.

This can be done with the `cpan` or `cpanm` command:

    % cpanm App::AppSpec
    # or
    % cpan App::AppSpec

The `cpanm` command might be easier since it doesn't require configuration.
You need to install `cpanminus` for that (e.g. `apt-get install cpanminus`).

## Standalone version

For a standalone version of the script, checkout the `standalone` branch.
There you will find `bin/appspec`.

It currently requires perl 5.20 or higher, otherwise you will get an
error message.

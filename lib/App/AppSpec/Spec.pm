use strict;
use warnings;
package App::AppSpec::Spec;

our $VERSION = '0.000'; # VERSION

use base 'Exporter';
our @EXPORT_OK = qw/ $SPEC /;

our $SPEC;

# START INLINE
$SPEC = {
  'appspec' => {
    'version' => '0.001'
  },
  'class' => 'App::AppSpec',
  'description' => 'This script is a collection of tools for authors of [App::Spec] command line
scripts.
  # generate completion
  % appspec completion --bash path/to/spec.yaml
  # generate pod
  % appspec pod path/to/spec.yaml
  # validate your spec file
  % appspec validate path/to/spec.yaml
  # generate a new App::Spec app skeleton
  % appspec new --class App::foo --name foo --with-subcommands
',
  'markup' => 'swim',
  'name' => 'appspec',
  'options' => [],
  'subcommands' => {
    'completion' => {
      'description' => 'This command takes a spec file and outputs the corresponding
shell script for tab completion.
',
      'op' => 'cmd_completion',
      'options' => [
        {
          'spec' => 'name=s --name of the program (optional, override the value from the spec)'
        },
        {
          'spec' => 'zsh --for zsh'
        },
        {
          'spec' => 'bash --for bash'
        }
      ],
      'parameters' => [
        {
          'description' => 'spec file',
          'spec' => '+spec_file= +file --Path to the spec file (use \'-\' for standard input)'
        }
      ],
      'summary' => 'Generate completion for a specified spec file'
    },
    'new' => {
      'description' => 'This command creates a skeleton for a new app.
It will create a directory for your app and write a skeleton
spec file.
',
      'op' => 'cmd_new',
      'options' => [
        {
          'required' => 1,
          'spec' => 'name|n=s --The (file) name of the app'
        },
        {
          'required' => 1,
          'spec' => 'class|c=s --The main class name for your app implementation'
        },
        {
          'spec' => 'overwrite|o --Overwrite existing dist directory'
        },
        {
          'spec' => 'with-subcommands|s --Create an app with subcommands'
        }
      ],
      'parameters' => [
        {
          'spec' => 'path=s --Path to the distribution directory (default is \'Dist-Name\' in current directory)'
        }
      ],
      'summary' => 'Create new app'
    },
    'pod' => {
      'description' => 'This command takes a spec file and outputs the generated pod
documentation.
',
      'op' => 'generate_pod',
      'parameters' => [
        $SPEC->{'subcommands'}{'completion'}{'parameters'}[0]
      ],
      'summary' => 'Generate pod'
    },
    'validate' => {
      'description' => 'This command takes a spec file and validates it against the current
[App::Spec] schema.
',
      'op' => 'cmd_validate',
      'options' => [
        {
          'spec' => 'color|C --output colorized'
        }
      ],
      'parameters' => [
        $SPEC->{'subcommands'}{'completion'}{'parameters'}[0]
      ],
      'summary' => 'Validate spec file'
    }
  },
  'title' => 'Utilities for spec files for App::Spec cli apps'
};
# END INLINE

1;

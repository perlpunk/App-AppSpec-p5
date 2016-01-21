use strict;
use warnings;
use Test::More tests => 4;
use FindBin '$Bin';
use File::Share qw/ dist_file /;
use App::AppSpec;
use App::AppSpec::Schema::Validator;
my $validator = App::AppSpec::Schema::Validator->new;
my @files = map {
  "$Bin/../../App-Spec-p5/examples/$_"
} qw/ myapp-spec.yaml subrepo-spec.yaml pcorelist-spec.yaml /;
my $specfile = dist_file("App-AppSpec", "appspec-spec.yaml");

for my $file (@files, $specfile) {
    # TODO
    my @errors = $validator->validate_spec_file($file);
    is(scalar @errors, 0, "spec $file is valid");
    if (@errors) {
        diag $validator->format_errors(\@errors);
    }
}


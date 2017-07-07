package App::Sybil::Command::clean;

use strict;
use warnings;
use v5.12;

use base 'App::Sybil::base';

use File::Glob 'bsd_glob';

sub abstract { "Clean up any builds in the current directory." }

sub execute {
  my ($self, $opt, $args) = @_;

  my @files = bsd_glob($self->project . '-*.{zip,tgz}');
  say STDERR "Found " . scalar @files . " release files to clean up.";
  say STDERR "Deleting $_" for @files;
  unlink @files;
}

1;

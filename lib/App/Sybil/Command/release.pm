package App::Sybil::Command::release;

use strict;
use warnings;
use v5.12;

use App::Sybil -command;

sub abstract { 'Release your software' }

sub description { 'Publishes your current version as a github release' }

sub execute {
  my ($self, $opt, $args) = @_;

  my $project = $self->app->project;
  my $version = $self->app->version;

  unless ($self->app->has_build($version)) {
    say STDERR "Incomplete bulid, aborting release";
    return;
  }

  # TODO additional checks

  say STDERR "Publishing $project $version to github.";
  say STDERR 'Github publishing not yet implemented.';

  # TODO implement
}

1;

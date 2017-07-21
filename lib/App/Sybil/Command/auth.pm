package App::Sybil::Command::auth;

use strict;
use warnings;
use v5.12;

use App::Sybil -command;

use IO::Prompt::Simple 'prompt';

sub abstract { 'Authenticate with github' }

sub execute {
  my ($self, $opt, $args) = @_;

  if ($self->app->_read_token) {
    say STDERR "You already have an authentication token.";
    return;
  }

  say STDERR "Interactive auth not yet implemented.  Please go to";
  say STDERR "http://github.com/settings/tokens and create a personal access";
  say STDERR "token for sybil and enter it below.";

  my $token = prompt('Personal Access Token');

  $self->app->_write_token($token);
}

1;

package App::Sybil;

use strict;
use warnings;
use v5.12;

our $VERSION = '0.01';

use App::Cmd::Setup -app;

use Capture::Tiny ':all';
use File::Spec;

sub _get_project_from_path {
  my ($self) = @_;

  my @dirs = File::Spec->splitdir(File::Spec->rel2abs(File::Spec->curdir));
  return $dirs[-1];
}

sub project {
  my ($self) = @_;

  $self->{project} ||= $self->_get_project_from_path();
  return $self->{project};
}

sub _get_version_from_git {
  my ($self) = @_;

  my $version = capture_stdout {
    system 'git', 'describe', '--dirty', '--tags';
  };
  chomp $version;

  return $version;
}

sub version {
  my ($self) = @_;

  $self->{version} ||= $self->_get_version_from_git();
  return $self->{version};
}

1;

__END__

=encoding utf-8

=head1 NAME

App::Sybil - Multi platform build and release manager

=head1 SYNOPSIS

    $ sybil release
    Building linux version v1.3
    Building windows version v1.3
    $ sybil publish
    Publishing version v1.3 to github

=head1 DESCRIPTION

App::Sybil is a tool for managing and publishing release builds of your
software.  It is opinionated but somewhat configurable.

=head1 AUTHOR

Alan Berndt <alan@eatabrick.org>

=head1 COPYRIGHT

Copyright 2017 Alan Berndt

=head1 LICENSE


=head1 SEE ALSO

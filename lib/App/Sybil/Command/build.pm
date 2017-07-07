package App::Sybil::Command::build;

use strict;
use warnings;
use v5.12;

use base 'App::Sybil::base';

use Capture::Tiny ':all';
use File::Copy;

sub abstract { "Build your software" };

sub description { "Does a release build of your software package." };

sub _build {
  my ($self, $target, @opts) = @_;

  my ($stdout, $stderr, $exit) = tee {
    system('bazel', 'build', '-c', 'opt', $target, @opts);
  };

  return $exit == 0;
}

sub _linux_build {
  my ($self) = @_;

  my $project = $self->project;
  my $version = $self->version;

  $self->_build(":$project-linux") or exit 1;
  my $file = "$project-$version-linux.tgz";
  copy("bazel-bin/$project-linux.tgz", $file) or say STDERR "copy failed: $!";
}

sub _windows_build {
  my ($self, $cpu) = @_;

  my $project = $self->project;
  my $version = $self->version;

  my @options = (
    '--crosstool_top', '@mxebzl//tools/windows:toolchain',
    '--cpu', $cpu,
  );
  $self->_build(":$project-windows", @options) or exit 1;
  my $file = "$project-$version-$cpu.zip";
  copy("bazel-bin/$project-windows.zip", $file) or say STDERR "copy failed: $!";
}

sub _osx_build {
  my ($self) = @_;

  say STDERR "OSX builds not yet supported";
}

sub execute {
  my ($self, $opt, $args) = @_;

  $self->_linux_build();
  $self->_windows_build('win32');
  $self->_windows_build('win64');
  $self->_osx_build();
}

1;

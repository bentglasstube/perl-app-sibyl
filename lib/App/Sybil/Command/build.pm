package App::Sybil::Command::build;

use strict;
use warnings;
use v5.12;

use App::Sybil -command;

use Capture::Tiny ':all';
use File::Copy;

sub abstract { 'Build your software' }

sub description { 'Does a release build of your software package.' }

sub _build {
  my ($self, $target, $file, @opts) = @_;

  system 'bazel', 'build', '-c', 'opt', ":$target", @opts;

  if ($? == -1) {
    say STDERR 'Build failed';
    return;
  }

  # TODO improve result name detection
  my $extension = substr $file, -3;
  unless (copy("bazel-bin/$target.$extension", $file)) {
    say STDERR "Copy $target.$extension failed: $!";
    return;
  }

  say STDERR 'Build complete';
}

sub _linux_build {
  my ($self) = @_;

  my $project = $self->app->project;
  my $version = $self->app->version;

  # TODO autodetect build rule
  my $target = "$project-linux";
  my $file   = "$project-$version-linux.tgz";
  $self->_build($target, $file);
}

sub _windows_build {
  my ($self, $cpu) = @_;

  my $project = $self->app->project;
  my $version = $self->app->version;

  my @options =
    ('--crosstool_top', '@mxebzl//tools/windows:toolchain', '--cpu', $cpu,);

  # TODO autodetect build rule
  my $target = "$project-windows";
  my $file   = "$project-$version-$cpu.zip";
  $self->_build($target, $file, @options);
}

sub _osx_build {
  my ($self) = @_;

  say STDERR 'OSX builds not yet supported';
}

sub execute {
  my ($self, $opt, $args) = @_;

  $self->_linux_build();
  $self->_windows_build('win32');
  $self->_windows_build('win64');
  $self->_osx_build();
}

1;

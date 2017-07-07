package App::Sybil::base;

use App::Sybil -command;
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

  # TODO allow options
  my $version = capture_stdout {
    system('git', 'describe', '--dirty', '--tags');
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

package Catalyst::Lite::DispatchType::Role::HTTPMethod;
use Moose::Role;

has method => (isa => 'Str', is => 'rw');

around match => sub {
  my $orig = shift;
  my $self = shift;
  my($c, $path) = @_;

  return unless uc($c->req->method) eq uc($self->method);
  $self->$orig(@_);
};

1;

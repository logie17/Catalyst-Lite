package Catalyst::Lite::Action;
use Moose;

extends 'Catalyst::Action';

override dispatch => sub {
  my($self, $c) = @_;
  $c->execute($c, $self);
};

1;

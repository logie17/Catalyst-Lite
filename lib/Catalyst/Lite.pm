package Catalyst::Lite;
require Catalyst;

sub import {
  my($class) = @_;
  my $caller = caller();
}

1;

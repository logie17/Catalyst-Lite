package MyApp;
use Catalyst;
use Catalyst::Action;

BEGIN {
  $ENV{CATALYST_SCRIPT_GEN} = 40;
}

use Catalyst::Script::Server;
use Data::Dump;

MyApp->setup;

my $d = MyApp->dispatcher;
$d->register(
  App => Catalyst::Action->new(
    name       => 'hello',
    reverse    => '/hello',
    namespace  => '',
    class      => 'MyApp',
    code       => sub { $_[1]->res->body('hello world!') },
    attributes => { Path => ['/'] }
  )
);

#Catalyst::Script::Server->new( application_name => 'MyApp' )
#  ->run( MyApp => 'Server' );

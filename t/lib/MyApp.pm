package MyApp;
use Catalyst;
use Catalyst::Lite::Action;
use Catalyst::Script::Server;

MyApp->setup;

my $d = MyApp->dispatcher;
$d->register(
  App => Catalyst::Lite::Action->new(
    name       => 'hello',
    reverse    => '/hello',
    namespace  => '',
    class      => 'MyApp',
    code       => sub { shift->res->body('hello world!') },
    attributes => { Path => ['/'] }
  )
);

#Catalyst::Script::Server->new( application_name => 'MyApp' )
#  ->run( MyApp => 'Server' );

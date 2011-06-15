package MyApp;
use Catalyst::Lite;

get '/' => sub { pop->res->body('hello world!') };
get
  Chained     => '/',
  PathPart    => 'hello',
  CaptureArgs => 0 => sub { pop->stash->{chained} = 'from chained' };

get
  Chained  => '/hello',
  PathPart => '',
  Args     => 0 => sub {
    my ( $app, $c ) = @_;
    $c->res->body( 'hello ' . $c->stash->{chained} );
};

MyApp->setup;

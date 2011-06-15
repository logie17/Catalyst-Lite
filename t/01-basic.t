use Test::More;
use lib 't/lib';
use HTTP::Request::Common;
use Catalyst::Test 'MyApp';

{
  my ( $res, $ctx ) = ctx_request('/');

  is( $res->content, q{hello world!} );
}

{
  my ( $res, $ctx ) = ctx_request('/hello');

  is( $res->content, q{hello from chained} );
}

{
  my ( $res, $ctx ) = ctx_request( POST '/' );

  cmp_ok( $res->content, 'ne', q{hello world!} );
  ok(scalar @{$ctx->error});
}

done_testing();

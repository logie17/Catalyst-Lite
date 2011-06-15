use Test::More;
use lib 't/lib';
use Catalyst::Test 'MyApp';

my($res, $ctx) = ctx_request('/');

is($res->content, q{hello world!});

done_testing();

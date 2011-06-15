package Catalyst::Lite;

=head1 NAME

Catalyst::Lite - The elegant MVC Web Application Framework, on a veggie diet

=head1 SYNOPSIS

package MyApp;
use Catalyst::Lite;

get '/' => sub { pop->res->body('hello world!') };

MyApp->setup

# perl lib/MyApp.pm server

=cut

require Catalyst;
use Moose;
use Moose::Exporter;

my ( $import, $unimport, $init_meta ) = Moose::Exporter->build_import_methods(
  also  => [qw(Moose)],
  as_is => [qw(get)]
);

sub unimport { goto &$unimport }

sub import {
  my $caller = caller();

  # UGH, does anyone know a better way to do this?
  eval qq{package $caller; Catalyst->import};
  my $app_meta = $caller->meta;
  $app_meta->add_after_method_modifier(
    setup_dispatcher => sub {
      my ($class) = @_;
      register_lite_actions($class);
    }
  );

  $app_meta->add_after_method_modifier(
    setup_finalize => sub {
      my ($class) = @_;
      if ( $ARGV[0] eq 'server' ) {
        shift @ARGV;
        Class::MOP::load_class('Catalyst::Script::Server');
        $class->setup_engine('Catalyst::Engine::HTTP');
        Catalyst::Script::Server->new_with_options( application_name => $class )
          ->run;
      }
    }
  );

  goto &$import;
}

my @lite_registrations;

my $registered_get = 1;

sub get {
  my $code  = pop;
  my @attrs = @_;
  my %attrs = @attrs == 1 ? ( Path => shift @attrs ) : @attrs;

  my $name = $attrs{Path} || $attrs{PathPart} || 'get' . $registered_get++;

  for my $key ( keys %attrs ) {
    $attrs{$key} = [ $attrs{$key} ];
  }

  push @lite_registrations,
    [
    role       => { name => 'HTTPMethod', args => { method => 'get' } },
    name       => $name,
    reverse    => $name,
    namespace  => '',
    attributes => \%attrs,
    code       => $code
    ];
  return $name;
}

sub register_lite_actions {
  my ($class) = @_;
  my $dispatcher = $class->dispatcher;

  foreach my $action (@lite_registrations) {
    my %attrs      = @$action;
    my $role       = delete $attrs{role};
    my $role_args  = $role->{args};
    my $role_class = 'Catalyst::Lite::DispatchType::Role::' . $role->{name};
    Class::MOP::load_class($role_class);
    my $action = $class->create_action( %attrs, class => $class );
    Moose::Util::apply_all_roles( $action, $role_class );
    $action->$_( $role_args->{$_} ) for keys %$role_args;
    $dispatcher->register( $class, $action );
  }
}

1;

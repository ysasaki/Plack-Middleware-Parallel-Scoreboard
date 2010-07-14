package Plack::Middleware::Parallel::Scoreboard;
use strict;
use warnings;
use parent qw(Plack::Middleware);
use Plack::Util::Accessor qw(board base_dir path);
use Parallel::Scoreboard;
our $VERSION = '0.01';

sub prepare_app {
    my $self = shift;

    if ( $self->base_dir ) {
        $self->board(
            Parallel::Scoreboard->new( base_dir => $self->base_dir ) );
    }
    else {
        die "Parallel::Scoreboard require base_dir option";
    }
}

sub call {
    my ( $self, $env ) = @_;

    $self->set_state( $env->{HTTP_KEEP_ALIVE} ? 'K' : 'A', $env );

    my $res;
    if ( $self->path && $env->{PATH_INFO} eq $self->path ) {
        $res = $self->_handle_server_status($env);
    }
    else {
        $res = $self->app->($env);
    }

    $self->set_state("_");

    return $res;
}

sub set_state {
    my $self   = shift;
    my $status = shift || '_';
    my $env    = shift;
    my $prev   = '';
    if ($env) {
        $prev = join( " ",
            $env->{REMOTE_ADDR},    $env->{HTTP_HOST},
            $env->{REQUEST_METHOD}, $env->{REQUEST_URI},
            $env->{SERVER_PROTOCOL} );
    }
    $self->board->update( sprintf( "[%s] %s %s", getppid, $status, $prev ) );
}

sub _handle_server_status {
    my ( $self, $env ) = @_;

    my @body;
    my $stats = $self->board->read_all();
    for my $pid ( sort { $a <=> $b } keys %$stats ) {
        push @body, "$stats->{$pid}\n";
    }

    return [ 200, [ 'Cotnent-Type' => 'text/plain; charset=utf-8' ], \@body ];
}

1;
__END__

=head1 NAME

Plack::Middleware::Parallel::Scoreboard - how server status like Apache's mod_status

=head1 SYNOPSIS

  use Plack::Builder;

  builder {
      enable "Plack::Middleware::Parallel::Scoreboard",
          path => '/server-status',
          base_dir => '/tmp/my-server';
      $app;
  };

=head1 DESCRIPTION

Copy lot's of code from Plack::Middleware::ServerStatus::Lite.

=head1 AUTHOR

Yoshihiro Sasaki E<lt>aloelight {at} gmail.comE<gt>

=head1 SEE ALSO

L<Plack::Middleware::ServerStatus::Lite>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

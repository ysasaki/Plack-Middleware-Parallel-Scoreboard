# NAME

Plack::Middleware::Parallel::Scoreboard - how server status like Apache's mod\_status

# SYNOPSIS

    use Plack::Builder;

    builder {
        enable "Plack::Middleware::Parallel::Scoreboard",
            path => '/server-status',
            base_dir => '/tmp/my-server';
        $app;
    };

# DESCRIPTION

Copy lot's of code from Plack::Middleware::ServerStatus::Lite.

# AUTHOR

Yoshihiro Sasaki <aloelight {at} gmail.com>

# SEE ALSO

[Plack::Middleware::ServerStatus::Lite](http://search.cpan.org/perldoc?Plack::Middleware::ServerStatus::Lite)

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

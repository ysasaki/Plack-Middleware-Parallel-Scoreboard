requires 'Parallel::Scoreboard', '0.02';
requires 'Plack';
requires 'parent';

on configure => sub {
    requires 'Module::Build', '0.38';
};

on build => sub {
    requires 'Test::More';
};

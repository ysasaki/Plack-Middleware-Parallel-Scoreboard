use inc::Module::Install;
name 'Plack-Middleware-Parallel-Scoreboard';
all_from 'lib/Plack/Middleware/Parallel/Scoreboard.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;

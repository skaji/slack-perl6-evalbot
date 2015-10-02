#!/usr/bin/env perl
use 5.22.0;
use warnings;
use File::RotateLogs;
use Proclet;

my $logger = File::RotateLogs->new(
    logfile => "evalbot.log.%Y%m%d",
    linkname => "evalbot.log",
    rotationtime => 24*60*60,
    maxage => 7*24*60*60,
    offset => 9*60*60,
);

my $evalbot = sub {
    $ENV{PATH} = "$ENV{HOME}/.rakudobrew/moar-nom/install/bin:$ENV{PATH}";
    exec $^X, "slack-perl6-evalbot.pl";
};
my $proclet = Proclet->new(
    logger => sub { $logger->print(@_) }
);

$proclet->service(
    code => $evalbot,
    tag  => "evalbot",
);
$proclet->run;

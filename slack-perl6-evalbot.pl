#!/usr/bin/env perl
use 5.22.0;
use warnings;
use utf8;
use FindBin '$Bin';
use lib "$Bin/lib";
use IO::Socket::SSL;
use AnySan::Provider::Slack;
use AnySan;
use Util qw(slack_unescape perl6_eval perl6_version);

my $token = $ENV{SLACK_TOKEN} or die "miss SLACK_TOKEN";
delete $ENV{$_} for grep {/^SLACK/} keys %ENV;

my $slack = slack
    token => $token,
    as_user => 1,
    channels => {},
    subtypes => ['message_changed'],
;

AnySan->register_listener(perl6_eval => {
    event => "message",
    cb => sub {
        my $receive = shift;
        my $message = $receive->{message} || "";
        return unless $message =~ m{\A(?:m|moar|perl6|perl6-m):\s*(\S.*)}sm;
        my $program = $1;
        $program =~ s/\s+\z//sm;
        $program = $1 if $program =~ /\A```(.+)```\z/sm;
        $program = $1 if $program =~ /\A`(.+)`\z/sm;
        $program = slack_unescape $program;
        my $out = perl6_eval $program;
        my $channel_id = $receive->{attribute}{channel};
        $slack->send_message($out, channel => $channel_id);
    },
});

AnySan->register_listener(perl6_version => {
    event => "message",
    cb => sub {
        my $receive = shift;
        my $message = $receive->{message} || "";
        return unless $message =~ m{\A(?:m|moar|perl6|perl6-m)-(?:v|version):};
        my $out = perl6_version;
        my $channel_id = $receive->{attribute}{channel};
        $slack->send_message($out, channel => $channel_id);
    },
});

AnySan->run;

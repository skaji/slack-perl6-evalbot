#!/usr/bin/env perl
use 5.22.0;
use warnings;
use utf8;
use FindBin '$Bin';
use lib "$Bin/lib";
use IO::Socket::SSL;
use AnySan::Provider::Slack;
use AnySan;
use Util qw(get_channel_id slack_unescape perl6_eval perl6_version);

my $token = $ENV{SLACK_TOKEN} or die "miss SLACK_TOKEN";
my $channel_name = $ENV{SLACK_CHANNEL} or die "miss SLACK_CHANNEL";
my $channel_id = get_channel_id token => $token, channel => $channel_name;
delete $ENV{$_} for grep {/^SLACK/} keys %ENV;

my $slack = slack
    token => $token,
    as_user => 1,
    channels => { $channel_name => {} },
;

AnySan->register_listener(perl6_eval => {
    event => "message",
    cb => sub {
        my $receive = shift;
        my $message = $receive->{message} || "";
        return unless $message =~ m{\A(?:m|moar|perl6|perl6-m):\s*(\S.*)}sm;
        my $program = $1;
        $program = $1 if $program =~ /\A`(.+)`\z/;
        $program = slack_unescape $program;
        my $out = perl6_eval $program;
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
        $slack->send_message($out, channel => $channel_id);
    },
});

AnySan->run;

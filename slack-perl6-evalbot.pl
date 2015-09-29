#!/usr/bin/env perl
use 5.22.0;
use warnings;
use utf8;
use AnySan::Provider::Slack;
use AnySan;
use Encode;
use EvalbotExecuter;
use JSON::PP;

sub slack_escape {
    my $decoded = shift;
    state $escape = sub {
        my $seq = shift;
        if    ($seq =~ s/^#C//)  { $seq =~ s/.*\|//; "#C$seq"  }
        elsif ($seq =~ s/^\@U//) { $seq =~ s/.*\|//; "\@$seq" }
        elsif ($seq =~ s/!//)    { $seq =~ s/.*\|//; "\@$seq"  }
        else                     { $seq =~ s/.*\|//; $seq     }
    };

    $decoded =~ s/<(.*?)>/ $escape->($1) /eg;
    $decoded =~ s/&amp;/&/g;
    $decoded =~ s/&lt;/</g;
    $decoded =~ s/&gt;/>/g;
    $decoded;
}

sub format_output {
    my ($prefix, $response) = @_;
    return "( no output )\n" unless length $response;

    my $newline = '␤';
    my $null    = "\N{SYMBOL FOR NULL}";
    $response =~ s/\n/$newline/g;
    $response =~ s/\x00/$null/g;
    if ( length($response) > 300 ) {
        $response = substr($response, 0, 290) . "...";
    }

    return "$response\n";
}

sub perl6_eval {
    my $str = shift;
    my $perl6 = {
        chdir    => "/",
        cmd_line => q{RAKUDO_ERROR_COLOR= perl6 --setting=RESTRICTED %program},
    };

    # NOTE: reuslt is decoded
    my $result = EvalbotExecuter::run($str, $perl6, "perl6");
    $result =~ s{/var/folders/[a-z0-9_/-]+}{/var/tempfile}gi;
    $result =~ s{/tmp/\S{10}}{/tmp/tempfile}g;
    format_output('camelia', $result);
}

my $config_json = shift or die "Usage: $0 config.json";
my $config = do { local (@ARGV, $/) = $config_json; decode_json <> };

my $slack = slack
    token => $ENV{ $config->{token_env} },
    as_user => 1,
    channels => { $config->{channel}{name} => {} },
;

AnySan->register_listener(perl6_eval => {
    event => "message",
    cb => sub {
        my $receive = shift;
        my $message = eval { decode_utf8 $receive->{message} } || "";
        return unless $message =~ m{^(?:m|moar|perl6|perl6-m):\s*(\S.*)};
        my $program = $1;
        $program = $1 if $program =~ /^`(.+)`$/;
        $program = slack_escape($program);
        my $out = perl6_eval($program);
        $slack->send_message($out, channel => $config->{channel}{id});
    },
});

AnySan->register_listener(perl6_version => {
    event => "message",
    cb => sub {
        my $receive = shift;
        my $message = eval { decode_utf8 $receive->{message} } || "";
        return unless $message =~ m{^(?:m|moar|perl6|perl6-m)-(?:v|version):};
        my $out = `perl6 -v`;
        chomp $out;
        $slack->send_message($out, channel => $config->{channel}{id});
    },
});

AnySan->run;

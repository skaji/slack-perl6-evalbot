# slack perl6 evalbot

![](misc/screenshot.png)

WIP

This is a perl6 evalbot for slack. It uses:

* https://github.com/perl6/evalbot
* https://github.com/shogo82148/p5-AnySan-Provider-Slack

# usage

1. `git clone --recursive git://github.com/shoichikaji/slack-perl6-evalbot.git`
2. Build docker by: `docker build -t slack-perl6-evalbot .`
3. Get API TOKEN from https://my.slack.com/services/new/bot
4. Choose channel and determine channel id from https://slack.com/api/channels.list?token=XXXXX&pretty=1
5. Then:

        docker run -e SLACK_TOKEN=XXX -e SLACK_CHANNEL_NAME=general -e SLACK_CHANNEL_ID=C06TR4JF9 -d slack-perl6-evalbot

## author

Shoichi Kaji

## license

This library is free software; you can redistribute it and/or modify it under the same terms as Perl5 itself.

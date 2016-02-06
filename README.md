# slack perl6 evalbot

![](misc/screenshot.png)

This is a perl6 evalbot for slack. It uses:

* https://github.com/perl6/evalbot
* https://github.com/zostay/AnyEvent-SlackRTM
* https://github.com/shogo82148/p5-AnySan-Provider-Slack

# usage

1. `git clone --recursive git://github.com/skaji/slack-perl6-evalbot.git`
2. Build base docker: `docker build -t evalbot-base -f Dockerfile.base .`
3. Build main docker: `docker build -t evalbot -f Dockerfile .`
4. Create a bot and get API TOKEN from https://my.slack.com/services/new/bot
5. Start docker:

        docker run -e SLACK_TOKEN=XXX -d evalbot

6. Finally invite the bot to your favorite channels!

# how to update perl6

1. Rebuild main docker: `docker build -t evalbot --no-cache=true .`
2. Stop existing container: `docker stop EXISTING_ID`
3. Re-run docker: `docker run -e SLACK_TOKEN=XXX -d evalbot`

## author

Shoichi Kaji

## license

This library is free software; you can redistribute it and/or modify it under the same terms as Perl5 itself.

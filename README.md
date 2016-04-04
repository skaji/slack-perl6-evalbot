# slack perl6 evalbot

![](misc/screenshot.png)

This is a perl6 evalbot for slack. It uses:

* https://github.com/perl6/evalbot
* https://github.com/skaji/Mojo-SlackRTM

# Usage

Make sure you have a slack API token.
If not, get it from https://my.slack.com/services/new/bot

## Development

1. `git clone --recursive git://github.com/skaji/slack-perl6-evalbot.git`
2. `cpanm -nq --installdeps .`
3. `SLACK_TOKEN=XXX perl slack-perl6-evalbot.pl`
4. Invite the bot to your favorite channels.

## Deployment (with docker)

1. `git clone --recursive git://github.com/skaji/slack-perl6-evalbot.git`
2. Build base docker: `docker build -t evalbot-base -f Dockerfile.base .`
3. Build main docker: `docker build -t evalbot -f Dockerfile .`
4. Start docker:

        docker run -e SLACK_TOKEN=XXX -d evalbot

5. Finally invite the bot to your favorite channels!

### How to update perl6 in docker

1. Rebuild main docker: `docker build -t evalbot --no-cache=true .`
2. Stop existing container: `docker stop EXISTING_ID`
3. Re-run docker: `docker run -e SLACK_TOKEN=XXX -d evalbot`

## Author

Shoichi Kaji

## License

This library is free software; you can redistribute it and/or modify it under the same terms as Perl5 itself.

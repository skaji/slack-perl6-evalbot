FROM evalbot-base
MAINTAINER Shoichi Kaji <skaji@cpan.org>

USER app
WORKDIR /home/app
ENV PATH=/home/app/.rakudobrew/moar-nom/install/bin:$PATH
ENV HOME=/home/app
ENV USER=app
RUN perl ~/.rakudobrew/bin/rakudobrew build moar
COPY evalbot/ /home/app/evalbot/
COPY lib/ /home/app/lib/
COPY slack-perl6-evalbot.pl runner /home/app/

CMD ["/bin/bash", "runner"]

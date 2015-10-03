FROM evalbot-base
MAINTAINER Shoichi Kaji <skaji@cpan.org>

USER app
WORKDIR /home/app
ENV PATH=/home/app/perl/bin:$PATH
ENV HOME=/home/app
ENV USER=app
RUN perl ~/.rakudobrew/bin/rakudobrew build moar

CMD ["perl", "proclet.pl"]

FROM ubuntu:14.04
MAINTAINER Shoichi Kaji <skaji@cpan.org>

RUN locale-gen en_US en_US.UTF-8
RUN dpkg-reconfigure locales
RUN ln -sf /usr/share/zoneinfo/Japan /etc/localtime

RUN rm /etc/apt/sources.list
RUN echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse' >> /etc/apt/sources.list

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential wget tar git bzip2 curl libssl-dev
RUN apt-get clean -y

RUN useradd --shell /bin/bash app
RUN mkdir /home/app
RUN chown app:app /home/app

USER app
WORKDIR /home/app
ENV PATH=/home/app/perl/bin:$PATH
ENV HOME=/home/app
ENV USER=app

RUN curl -sSkL https://git.io/perl-install | bash -s ~/perl

COPY cpanfile proclet.pl slack-perl6-evalbot.pl rakudo.sh /home/app/
COPY evalbot/ /home/app/evalbot/
COPY lib/ /home/app/lib/
RUN cpanm -nq --installdeps .
RUN bash rakudo.sh

CMD ["perl", "proclet.pl"]
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
  build-essential perl man wget tar git bzip2 vim lsof sudo zsh curl libssl-dev
RUN apt-get clean -y

RUN useradd --shell /bin/bash app
RUN mkdir /home/app
RUN chown app:app /home/app

ADD rakudo.sh /tmp/rakudo.sh
RUN su -l -c "curl -sSkL https://git.io/perl-install | bash -s ~/perl" app
RUN su -l -c "~/perl/bin/cpanm -nq Capture::Tiny" app
RUN su -l -c 'env PATH=~/perl/bin:$PATH bash /tmp/rakudo.sh' app

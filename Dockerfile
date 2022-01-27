FROM ubuntu:20.04

## Use bash instead of sh
SHELL ["/bin/bash", "-c"]

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt-get update && \
    apt-get install -y --fix-missing --no-install-recommends \
    build-essential ca-certificates \
    apt-utils locales make cmake libtool automake autoconf pkg-config \
    unzip git curl wget less \
    libffi-dev zlib1g-dev libminizip-dev libexpat1-dev libssl-dev \
    libgeos-dev librttopo-dev \
    libsqlite3-dev sqlite3 \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

## Assign variables with perl path
ENV PERLBREW_PATH=/root/perl5/perlbrew/bin:/root/perl5/perlbrew/perls/perl-5.30.0/bin
ENV PERLBREW_MANPATH=/root/perl5/perlbrew/perls/perl-5.30.0/man

## Install perlbrew & Perl & cpanm
RUN curl -L https://install.perlbrew.pl | bash
RUN echo "source /root/perl5/perlbrew/etc/bashrc" >> /root/.bashrc
RUN /root/perl5/perlbrew/bin/perlbrew install -j 1 --notest perl-5.30.0
RUN /root/perl5/perlbrew/bin/perlbrew switch perl-5.30.0
RUN /root/perl5/perlbrew/bin/perlbrew install-cpanm

## Set the PATH to get setup working properly
ENV PATH=/root/perl5/perlbrew/bin:/root/perl5/perlbrew/perls/perl-5.30.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV ALIEN_GDAL_CONFIG_ARGS='--with-curl=no'

## Install modules
RUN /root/perl5/perlbrew/bin/cpanm --notest --notest --installdeps --no-man-pages \
  Catalyst::Devel@1.42 \
  Alien::freexl@1.03 \
  Alien::gdal@1.26 \
  Alien::geos::af@1.008 \
  Alien::libtiff@1.01 \
  Alien::proj@1.16 \
  Alien::spatialite@1.04 \
  Alien::sqlite@1.06 \
  Module::Compile@0.38 \
  PDL@2.068 \
  Geo::GDAL::FFI@0.09

## Install Biodiverse (pull only the latest commit from GitHub)
## Better to use a tagged snashot and download it as a tarball??
RUN git clone --depth 1 -b master https://github.com/shawnlaffan/biodiverse.git
WORKDIR "biodiverse"

RUN /root/perl5/perlbrew/bin/cpanm --skip-installed --notest --no-man-pages --installdeps . 

## Install remaining modules
RUN /root/perl5/perlbrew/bin/cpanm --notest --no-man-pages \
  Data::Recursive@1.1.0 \
  FFI::Platypus::Declare@1.34 \
  Getopt::Long::Descriptive@0.110 \
  Text::CSV@2.01 \
  Text::CSV_XS@1.47 \
  List::BinarySearch@0.25 \
  LWP::Protocol::https@6.10 \
  Inline::Module@0.34

# Couldn't find module or a distribution for these ones:
#    CPP::catch::test
#    Blort::Bork \
#    Panda::Lib \

RUN /root/perl5/perlbrew/bin/cpanm \
  Task::Biodiverse::NoGUI
  
RUN /root/perl5/perlbrew/bin/cpanm -l local \
  https://github.com/shawnlaffan/biodiverse-utils/tarball/master

# RUN /root/perl5/perlbrew/bin/cpanm \
#   http://www.biodiverse.unsw.edu.au/downloads/Biodiverse-Utils-1.06.tar.gz

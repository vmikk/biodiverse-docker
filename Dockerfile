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
    libarmadillo-dev libpoppler-dev libepsilon-dev liblzma-dev \
    libkml-dev libfreexl-dev libogdi-dev \
    libgeos-dev librttopo-dev \
    libsqlite3-dev sqlite3 \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*


## Assign variables with perl path
ENV PERLBREW_PATH=/root/perl5/perlbrew/bin:/root/perl5/perlbrew/perls/perl-5.34.0/bin
ENV PERLBREW_MANPATH=/root/perl5/perlbrew/perls/perl-5.34.0/man

## Install perlbrew & Perl & cpanm
RUN curl -L https://install.perlbrew.pl | bash
RUN echo "source /root/perl5/perlbrew/etc/bashrc" >> /root/.bashrc
RUN /root/perl5/perlbrew/bin/perlbrew install -j 1 --notest perl-5.34.0
RUN /root/perl5/perlbrew/bin/perlbrew use perl-5.34.0
RUN /root/perl5/perlbrew/bin/perlbrew install-cpanm

## Set the PATH to get setup working properly
ENV PATH=/root/perl5/perlbrew/bin:/root/perl5/perlbrew/perls/perl-5.34.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

## Install modules
RUN /root/perl5/perlbrew/bin/cpanm --notest --no-man-pages \
  ExtUtils::Embed@1.35 \
  Catalyst::Devel@1.42 \
  Module::Compile@0.38 \
  FFI::Build::MM@1.56 \
  FFI::Platypus@1.56 \
  List::MoreUtils@0.430 \
  PDL@2.068 \
  Test2::Harness@1.000042 \
  Text::CSV@2.01 \
  Text::CSV_XS@1.47 \
  Alien::Build@2.25 \
  Alien::freexl@1.03 \
  Alien::libtiff@1.01 \
  Alien::cmake3@0.08 \
  Alien::sqlite@1.06 \
  Alien::patch@0.15

RUN /root/perl5/perlbrew/bin/cpanm --notest --skip-satisfied --no-man-pages \
  FFI::Platypus::Declare@1.34 \
  Alien::geos::af@1.008 \
  Alien::proj@1.16

RUN /root/perl5/perlbrew/bin/cpanm --notest --skip-satisfied --no-man-pages \
  Alien::spatialite@1.04

# export LD_LIBRARY_PATH=`perl -MAlien::geos::af -E'print Alien::geos::af->dist_dir . q{/lib}'`
ENV LD_LIBRARY_PATH=`perl -MAlien::geos::af -E'print Alien::geos::af->dist_dir . q{/lib}'`

RUN /root/perl5/perlbrew/bin/cpanm --notest --skip-satisfied --no-man-pages \
  Alien::gdal@1.27

# RUN /root/perl5/perlbrew/bin/cpanm --notest --skip-satisfied --no-man-pages -l local \
#   git://github.com/shawnlaffan/perl-alien-gdal.git@r1.27

RUN /root/perl5/perlbrew/bin/cpanm --notest --skip-satisfied --no-man-pages \
  Geo::GDAL::FFI@0.09

## Download Biodiverse repo (pull only the latest commit from GitHub)
RUN git clone --depth 1 -b r3.1 https://github.com/shawnlaffan/biodiverse.git
WORKDIR "biodiverse"

## Get the updated `cpanfile` with fixed module versions
RUN wget https://raw.githubusercontent.com/vmikk/biodiverse-docker/main/cpanfile -O cpanfile

## Install Biodiverse
RUN /root/perl5/perlbrew/bin/cpanm --skip-satisfied --notest --no-man-pages --installdeps . 

## Install remaining modules
RUN /root/perl5/perlbrew/bin/cpanm --notest --no-man-pages \
  Data::Recursive@1.1.0 \
  Getopt::Long::Descriptive@0.110 \
  List::BinarySearch@0.25 \
  LWP::Protocol::https@6.10 \
  Inline::Module@0.34

# Couldn't find module or a distribution for these ones:
#    CPP::catch::test
#    Blort::Bork \
#    Panda::Lib \

RUN /root/perl5/perlbrew/bin/cpanm --skip-satisfied \
  Task::Biodiverse::NoGUI@3.001

RUN /root/perl5/perlbrew/bin/cpanm --skip-satisfied -l local \
  git://github.com/shawnlaffan/biodiverse-utils.git@v1.07

# RUN /root/perl5/perlbrew/bin/cpanm \
#   http://www.biodiverse.unsw.edu.au/downloads/Biodiverse-Utils-1.06.tar.gz

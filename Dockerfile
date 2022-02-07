FROM ubuntu:20.04

## Use bash instead of sh
SHELL ["/bin/bash", "-c"]

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

## Set the variable (empty or --notest) that can be defined when building the image.
## We might want to set it individually for some dependencies, e.g. for the Biodiverse specific libraries.
## Use: docker build -t biodiverse-image --build-arg CPANMARGS="--notest"
# ARG CPANMARGS=""   # do not skip the testing of modules
ARG DO_TEST="--notest"
ARG CPANMARGS="--no-man-pages --skip-satisfied"

RUN echo "Running build with" "$DO_TEST"

RUN yes | unminimize

## Install the required dependencies
RUN apt update -y \
  && apt install -y software-properties-common \
  && add-apt-repository universe \
  && apt update -y \
  && apt upgrade -y \
  && apt install -y \
    software-properties-common \
    python3 python3-pip \
    zip unzip \
    curl git wget less \
    build-essential ca-certificates \
    make cmake libtool automake autoconf pkg-config \
    libffi-dev zlib1g-dev libminizip-dev libexpat1-dev libssl-dev \
    libarmadillo-dev libpoppler-dev libepsilon-dev liblzma-dev \
    libkml-dev libfreexl-dev libogdi-dev \
    libgdal-dev gdal-bin \
    libgeos-dev librttopo-dev \
    libsqlite3-dev sqlite3 \
  && apt-get autoremove -y \
  && apt-get autoclean -y \
  && rm -rf /var/lib/apt/lists/*

## Assign variables with perl path
ENV PERLBREW_PATH=/root/perl5/perlbrew/bin:/root/perl5/perlbrew/perls/perl-5.34.0/bin

## Install perlbrew & Perl & cpanm
RUN curl -L https://install.perlbrew.pl | bash \
  && source ~/perl5/perlbrew/etc/bashrc \
  && echo "source ~/perl5/perlbrew/etc/bashrc" >> /root/.bashrc \
  && export PATH=$PATH:PERLBREW_PATH \
  && perlbrew install "$DO_TEST" perl-5.34.0 \
  && perlbrew use perl-5.34.0 \
  && perlbrew install-cpanm

## Set the PATH to get setup working properly
ENV PATH=/root/perl5/perlbrew/bin:/root/perl5/perlbrew/perls/perl-5.34.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

## Check if GDAL is installed
# gdalinfo --version              # GDAL 3.0.4, released 2020/01/28
# ogrinfo --version
# /sbin/ldconfig -p | grep gdal

## Install modules
RUN cpanm "$DO_TEST" "$CPANMARGS" \
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
  Alien::patch@0.10 \
  FFI::Platypus::Declare@1.34 \
  Alien::geos::af@1.008 \
  Alien::proj@1.16 \
  Alien::spatialite@1.04 \
  Alien::gdal@1.27

# RUN cpanm "$DO_TEST" "$CPANMARGS" Test2::Harness@1.000042

## Export LD_LIBRARY_PATH and install Geo::GDAL::FFI
RUN export LD_LIBRARY_PATH=`perl -MAlien::geos::af -E'print Alien::geos::af->dist_dir . q{/lib}'` \
  && cpanm "$DO_TEST" "$CPANMARGS" Geo::GDAL::FFI@0.09


## Download Biodiverse repo (pull only the latest commit from GitHub)
RUN git clone --depth 1 -b r3.1 https://github.com/shawnlaffan/biodiverse.git
WORKDIR "biodiverse"

## Get the updated `cpanfile` with fixed module versions
RUN wget https://raw.githubusercontent.com/vmikk/biodiverse-docker/main/cpanfile -O cpanfile

## Install Biodiverse
RUN cpanm --skip-satisfied --installdeps .

## Install remaining modules
RUN cpanm "$DO_TEST" "$CPANMARGS" \
  Data::Recursive@1.1.0 \
  Getopt::Long::Descriptive@0.110 \
  List::BinarySearch@0.25 \
  LWP::Protocol::https@6.10 \
  Inline::Module@0.34

# RUN cpanm Panda::Lib CPP::catch::test

RUN cpanm --skip-satisfied \
  Task::Biodiverse::NoGUI@3.001

RUN cpanm --skip-satisfied -l local \
  git://github.com/shawnlaffan/biodiverse-utils.git@v1.07

# RUN /root/perl5/perlbrew/bin/cpanm \
#   http://www.biodiverse.unsw.edu.au/downloads/Biodiverse-Utils-1.06.tar.gz

## Test Biodiverse
# ENV export BD_NO_TEST_GUI=1  #  no need to test the GUI libs load
# RUN prove -l

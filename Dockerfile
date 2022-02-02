FROM ubuntu:20.04

## Use bash instead of sh
SHELL ["/bin/bash", "-c"]

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

## set variable (empty or --notest) that can be defined when building the image.
## We might want to set it individually for some dependencies, e.g. for the Biodiverse specific libraries.
## Use: docker build -t biodiverse-image --build-arg DO_TEST="--notest" .
ARG DO_TEST=""

RUN echo "Running build with" $DO_TEST

RUN yes | unminimize

RUN apt update -y \
  && apt install -y software-properties-common \
  && add-apt-repository universe \
  && apt update -y \
  && apt upgrade -y

RUN apt install -y \
  python3 python3-pip \
  zip unzip \
  curl git wget

## Assign variables with perl path
ENV PERLBREW_PATH=/root/perl5/perlbrew/bin:/root/perl5/perlbrew/perls/perl-5.34.0/bin

## Install perlbrew & Perl & cpanm
RUN curl -L https://install.perlbrew.pl | bash \
  && source ~/perl5/perlbrew/etc/bashrc \
  && echo "source ~/perl5/perlbrew/etc/bashrc" >> /root/.bashrc \
  && export PATH=$PATH:PERLBREW_PATH \
  && perlbrew install $DO_TEST perl-5.34.0 \
  && perlbrew use perl-5.34.0 \
  && perlbrew install-cpanm

## Set the PATH to get setup working properly
ENV PATH=/root/perl5/perlbrew/bin:/root/perl5/perlbrew/perls/perl-5.34.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

## Install modules
RUN cpanm $DO_TEST \
  Alien::sqlite@1.06 \
  Alien::proj@1.16 \
  Alien::geos::af@1.008 \
  Alien::gdal@1.27 \
  FFI::Platypus::Declare@1.34

RUN cpanm $DO_TEST Test2::Harness@1.000042

# export LD_LIBRARY_PATH and install Geo::GDAL::FFI
RUN export LD_LIBRARY_PATH=`perl -MAlien::geos::af -E'print Alien::geos::af->dist_dir . q{/lib}'` \
  && cpanm $DO_TEST Geo::GDAL::FFI@0.09

## Download Biodiverse repo (pull only the latest commit from GitHub)
RUN git clone --depth 1 -b r3.1 https://github.com/shawnlaffan/biodiverse.git
WORKDIR "biodiverse"

# ## Get the updated `cpanfile` with fixed module versions
# RUN wget https://raw.githubusercontent.com/vmikk/biodiverse-docker/main/cpanfile -O cpanfile

## Install Biodiverse
RUN cpanm --installdeps .

## Install remaining modules
# RUN cpanm Panda::Lib
RUN cpanm $DO_TEST \
  Data::Recursive@1.1.0 \
  Inline::Module@0.34

RUN cpanm $DO_TEST \
  Task::Biodiverse::NoGUI@3.001

RUN cpanm -l local \
  git://github.com/shawnlaffan/biodiverse-utils.git@v1.07

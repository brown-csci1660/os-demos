#!/bin/bash

set -x

export DEBIAN_FRONTEND=noninteractive

apt-get update &&\
  yes | unminimize

# install GCC-related packages
apt-get update && apt-get -y install\
			  build-essential\
			  gdb \
			  make \
			  locales \
			  nano \
			  sudo

apt-get -y --no-install-recommends install \
	emacs-nox \
	vim

# set up default locale
locale-gen en_US.UTF-8
export LANG=en_US.UTF-8

useradd -u 1000 -s /bin/bash alice
mkdir /home/alice
chown -R alice:alice /home/alice

useradd -s /bin/bash registrar


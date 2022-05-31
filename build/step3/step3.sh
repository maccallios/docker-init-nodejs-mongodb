#!/usr/bin/env bash

set -eux

apt install -y openssh-server tree rsync tmux vim net-tools unzip iproute2 man

# https://manpages.debian.org/stretch/psmisc/index.html
apt install -y software-properties-common apt-transport-https ca-certificates zsh git \
  make wget screen python3 python3-pip python3-venv tmux autojump gnupg net-tools htop rsync netcat-traditional unzip \
  psmisc zstd
apt install -y pigz

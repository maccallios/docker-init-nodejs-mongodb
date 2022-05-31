#!/usr/bin/env bash

set -eux

cd $HOME/build

REPO=ogham/exa
PATTERN="exa-linux-x86_64-musl-v0.10.1.zip"
dl_gh_release $REPO $PATTERN

unzip $PATTERN

cp bin/exa /usr/bin/
cp man/exa.1 /usr/share/man/man1
cp man/exa_colors.5 /usr/share/man/man5/exa_colors.5
cp completions/exa.zsh ${ZSH_CUSTOM_COMPLETIONS_DIR}/_exa


REPO=tsl0922/ttyd
PATTERN="ttyd.x86_64"
dl_gh_release $REPO $PATTERN
chmod +x ./ttyd.x86_64
cp ./ttyd.x86_64 ${PATH_USR_LOCAL_BIN}/ttyd

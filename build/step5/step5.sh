#!/usr/bin/env bash

set -eux

cd $HOME/build

# ZSH_CUSTOM_COMPLETIONS_DIR=/usr/local/share/zsh/completions
# ZSH_CUSTOM_COMPLETIONS_DIR=/usr/share/zsh/functions/Completion/Linux

mkdir -p $ZSH_CUSTOM_COMPLETIONS_DIR

cat<<EOF >> $HOME/.zshrc
unsetopt hist_save_by_copy

# Why does rm -f ask me for confirmation on zsh?
# https://stackoverflow.com/a/27995504
setopt rmstarsilent

# https://superuser.com/a/445491
setopt no_complete_aliases

# https://www.reddit.com/r/zsh/comments/c160o2/command_line_pasted_text/erbg6hy/
# zle_bracketed_paste=()
zle_highlight=('paste:none')

# https://www.soberkoder.com/better-zsh-history/
export HISTTIMEFORMAT="[%F %T] "

fpath=(\$fpath $ZSH_CUSTOM_COMPLETIONS_DIR)

PATH=$HOME/.local/bin:\$PATH

EOF


# dl_gh_release() {
#   REPO=$1
#   PATTERN=$2
#   release_url=$(curl -s https://api.github.com/repos/${REPO}/releases/latest | awk -F\" "/browser_download_url.*${PATTERN}/{print \$(NF-1)}")
#   echo "REPO: $REPO, PATTERN: $PATTERN, release_url: $release_url"
#   curl -OLs $release_url
# }

# REPO=ogham/exa
# PATTERN="exa-linux-x86_64-musl-v0.10.1.zip"
# dl_gh_release $REPO $PATTERN

# unzip $PATTERN

# cp bin/exa /usr/bin/
# cp man/exa.1 /usr/share/man/man1
# cp man/exa_colors.5 /usr/share/man/man5/exa_colors.5
# cp completions/exa.zsh ${ZSH_CUSTOM_COMPLETIONS_DIR}/_exa

# https://github.com/sharkdp/bat
BAT_VERSION=0.21.0
# https://github.com/sharkdp/bat
wget https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb
dpkg -i bat_${BAT_VERSION}_amd64.deb
rm bat_${BAT_VERSION}_amd64.deb

cd ..
rm -rf ./build

mandb

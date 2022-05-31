#!/usr/bin/env bash

# shellcheck disable=2016
# shellcheck disable=2164

export DEBIAN_FRONTEND=noninteractive

BUILD_DIR=/root/.build
mkdir -p $BUILD_DIR
cd $BUILD_DIR


# PATH_USR_LOCAL_BIN=/usr/local/bin

apt update

pip3 install requests psutil
echo "set-option -g mouse on" >> /root/.tmux.conf

function dl() {
  local target=$1
  local dest=${2:-"$(basename $target)"}
  curl -L -# $target -o "$dest"
}

LFS_VERSION=0.7.6
dl https://github.com/Canop/lfs/releases/download/v${LFS_VERSION}/lfs_${LFS_VERSION}.zip
unzip lfs_${LFS_VERSION}.zip
chmod +x ./build/x86_64-linux/lfs
mv ./build/x86_64-linux/lfs /usr/local/bin
rm -rf ./build

dl https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch
chmod +x ./neofetch
mv ./neofetch $PATH_USR_LOCAL_BIN

BTOP_VERSION=1.0.5
dl https://github.com/aristocratos/btop/releases/download/v${BTOP_VERSION}/btop-${BTOP_VERSION}-linux-x86-64.tbz
tar xjf btop-${BTOP_VERSION}-linux-x86-64.tbz
cp bin/btop /usr/local/bin
rm -rf bin btop-${BTOP_VERSION}-linux-x86-64.tbz

(
  cd /usr/share || exit
  git clone --depth=1 https://github.com/azlux/gnos-sockets
  # sed -i 's/\\\[/[/' ./gnos-sockets/sss
  cp "$(pwd)/gnos-sockets/sss" ${PATH_USR_LOCAL_BIN}
)

pip3 install pipx
pipx install speedtest-cli

HOME=/root
touch $HOME/.hushlogin

if [ ! -e "/root/.oh-my-zsh" ]; then
  # sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  
  git clone http://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh \
    && cp $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc \
    && perl -0777pi -e 's/plugins=\([^)]+\)/\plugins=(git autojump docker history dirhistory zsh-autosuggestions\)/smg' /root/.zshrc \
    && echo $'PROMPT=\'%{$fg_bold[white]%}%M %{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}\'' >> /root/.zshrc \
    && echo -e "DISABLE_UPDATE_PROMPT=true\nDISABLE_AUTO_UPDATE=true" >> $HOME/.zshrc \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && echo "alias d-c=docker-compose" >> $HOME/.zshrc
    # && echo 'autoload $ZSH/functions/*' >> /root/.zshrc
  # echo "PROMPT_POSTFIX=$PROMPT_POSTFIX" >> ${HOME}/.zshrc
  echo 'PATH=$PATH:$HOME/.local/bin:/opt/go/gopath/bin:/opt/go/go/bin:/opt/rust/.cargo/bin:/opt/bin/rust' >> /root/.zshrc
  chsh -s "$(which zsh)"
  mkdir -p $HOME/.oh-my-zsh/functions
fi

CTOP_VERSION=0.7.6
dl https://github.com/bcicen/ctop/releases/download/${CTOP_VERSION}/ctop-${CTOP_VERSION}-linux-amd64 /usr/local/bin/ctop
chmod +x /usr/local/bin/ctop

git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all --no-fish

# https://github.com/BurntSushi/ripgrep
RIPGREP_VERSION=13.0.0
# https://github.com/sharkdp/fd
FD_VERSION=8.2.1
# https://github.com/sharkdp/hyperfine
HYPERFINE_VERSION=1.11.0

# https://github.com/sharkdp/fd
wget https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd_${FD_VERSION}_amd64.deb
dpkg -i fd_${FD_VERSION}_amd64.deb
rm fd_${FD_VERSION}_amd64.deb

wget https://github.com/sharkdp/hyperfine/releases/download/v${HYPERFINE_VERSION}/hyperfine_${HYPERFINE_VERSION}_amd64.deb
dpkg -i hyperfine_${HYPERFINE_VERSION}_amd64.deb
rm hyperfine_${HYPERFINE_VERSION}_amd64.deb

# https://github.com/BurntSushi/ripgrep
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/$RIPGREP_VERSION/ripgrep_${RIPGREP_VERSION}_amd64.deb
dpkg -i ripgrep_${RIPGREP_VERSION}_amd64.deb
rm ripgrep_${RIPGREP_VERSION}_amd64.deb

cat <<'EOF' >>$HOME/.zshrc
alias t="exa --tree -lh --long -I node_modules --level=2"
alias tt='exa --tree -lh -I node_modules --level=3'

# redefine ls aliases
alias l='exa --header --long --git --group-directories-first --all'
alias la='exa --header --long --git --group-directories-first --extended --group --accessed --modified --created --all'
alias lp=$'exa --header --long --git --group-directories-first --extended --group --all --octal-permissions'
alias l.='exa --header --long --git --group-directories-first --list-dirs .*'

# https://github.com/ogham/exa
alias e="exa -lah"

alias grep='grep --color'
alias cb="bat -P"

alias scs='systemctl status'
alias rm='rm -v'

export MANPAGER="sh -c 'col -bx | bat --style=plain -l man -P'"

function c() {
  printf '\33c\e[3J'
}

EOF

cat <<- EOF >> /etc/sysctl.conf

fs.inotify.max_user_watches = 524288

fs.file-max = 65535
net.core.somaxconn=65535
vm.overcommit_memory = 1

# disable ipv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

EOF

	sysctl -p

cd $HOME
rm -rf $BUILD_DIR

command -v zsh && chsh -s /bin/zsh

apt update
apt upgrade -y

echo "neofetch"
neofetch
# lfs -a


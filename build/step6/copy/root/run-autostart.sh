#!/bin/bash

# DIR_="$( cd "$( dirname "${BASH_SOURCE:-$0}" )" >/dev/null 2>&1 && pwd )"

set -x

export HOME=${HOME:-/root}

cd $HOME

mkdir -p $HOME/.ssh
chmod 0700 .ssh
cat $HOME/.config/id_rsa.pub > $HOME/.ssh/authorized_keys
chmod 0600 $HOME/.ssh/authorized_keys

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

TTYD_CREDENTIALS=$(cat $HOME/.config/ttyd_pass)
sed -i "s/__credential__/${TTYD_CREDENTIALS}/" /etc/systemd/system/ttyd.service

systemctl daemon-reload

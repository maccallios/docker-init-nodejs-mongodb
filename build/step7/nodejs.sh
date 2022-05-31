#!/usr/bin/env bash

set -eux

cd $HOME/build

NODE_VERSION=v17

export PNPM_HOME="/root/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

cat<<'EOF'>>$HOME/.zshrc
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
EOF

curl -fsSL https://get.pnpm.io/install.sh | sh -
pnpm env use --global ${NODE_VERSION}

which pnpm
which node

pnpm --global i \
  typescript ts-node \
  @nestjs/cli \
  nx

#!/usr/bin/env bash

# set -eua
set -a
shopt -s expand_aliases

# export BUILDKIT_PROGRESS=tty
export BUILDKIT_PROGRESS=plain

export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

DOCKER_NETWORK_NET_W1_BASE=${DOCKER_NETWORK_NET_W1_BASE:-172.16.231}
DOCKER_NETWORK_NET_W1_SUBNET=${DOCKER_NETWORK_NET_W1_BASE}.0/24
DOCKER_NETWORK_NET_W1_IP_RANGE=${DOCKER_NETWORK_NET_W1_BASE}.0/24

CONTAINER_MAIN_IP=${DOCKER_NETWORK_NET_W1_BASE}.101
DOCKER_SERVICE=node

CONTAINER_DATA_FOLDER=./container

alias d-c='docker-compose'
alias d-c-b='d-c build'

create_docker_network_if_not_exist() {
  local DOCKER_NETWORK_NAME=$1
  local SUBNET=$2
  local IP_RANGE=$3
  docker network inspect ${DOCKER_NETWORK_NAME} > /dev/null || \
    docker network create \
    --driver=bridge \
    --subnet=${SUBNET} \
    --ip-range=${IP_RANGE} \
    ${DOCKER_NETWORK_NAME}
}

# create_docker_network_if_not_exist network1 172.28.5.0/24 172.28.5.0/24
(
  set +e
  create_docker_network_if_not_exist net-w1 ${DOCKER_NETWORK_NET_W1_SUBNET} ${DOCKER_NETWORK_NET_W1_IP_RANGE}
  true
)

mkdir -p ${CONTAINER_DATA_FOLDER}

gen_ssh_keys() {
	id_rsa_path="${CONTAINER_DATA_FOLDER}/id_rsa"
  ttyd_pass_path="${CONTAINER_DATA_FOLDER}/ttyd_pass"

  echo "id_rsa_path:    $id_rsa_path"
  echo "ttyd_pass_path: $ttyd_pass_path"

  [ ! -e $ttyd_pass_path ] && echo "a:$(openssl rand -base64 8)" > $ttyd_pass_path
  [ ! -e "$id_rsa_path"  ] && echo -e 'y\n' | ssh-keygen -b 2048 -t rsa -q -N "" -C "" -f "${id_rsa_path}"
}
gen_ssh_keys

cat<<EOF | tee ./.env
CONTAINER_MAIN_IP=${DOCKER_NETWORK_NET_W1_BASE}.101
EOF

(
  cd ${CONTAINER_DATA_FOLDER}
  touch .zsh_history
)

d-c-b $DOCKER_SERVICE

d-c stop -t 0 $DOCKER_SERVICE
d-c up   -d $DOCKER_SERVICE
d-c logs -f $DOCKER_SERVICE

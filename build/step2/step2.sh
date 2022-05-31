#!/usr/bin/env bash

set -eux

# ls -lah /var/lib/apt/lists/
# rm -rf /var/lib/apt/lists/*

MONGODB_VERSION=5.0

apt install -y gnupg2 wget

# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/
wget -qO - https://www.mongodb.org/static/pgp/server-${MONGODB_VERSION}.asc | apt-key add -
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/debian buster/mongodb-org/${MONGODB_VERSION} main" | tee /etc/apt/sources.list.d/mongodb-org-${MONGODB_VERSION}.list
apt update -y

# The following additional packages will be installed:
#   mongodb-database-tools mongodb-mongosh mongodb-org-database mongodb-org-database-tools-extra mongodb-org-mongos mongodb-org-server mongodb-org-shell
#   mongodb-org-tools
# The following NEW packages will be installed:
#   mongodb-database-tools mongodb-mongosh mongodb-org mongodb-org-database mongodb-org-database-tools-extra mongodb-org-mongos mongodb-org-server
#   mongodb-org-shell mongodb-org-tools

# MONGODB_VERSION=${MONGODB_VERSION}.2
apt install -y mongodb-org \
  mongodb-org-database \
  mongodb-org-server \
  mongodb-org-shell \
  mongodb-org-mongos \
  mongodb-org-tools

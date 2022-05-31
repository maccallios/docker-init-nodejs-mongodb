apt update

apt upgrade -y
apt autoremove -y

# build-essential

apt install -y \
  apt-utils git \
  curl ca-certificates

apt-get install -y --no-install-recommends \
  systemd  \
  systemd-sysv \
  cron   \
  anacron

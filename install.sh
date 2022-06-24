#!/usr/bin/env bash

# Enable i2c and spi via raspi-config

# run as root
# curl -sSL https://raw.githubusercontent.com/herobrauni/raspberry/main/install.sh | bash

apt update && sudo apt upgrade -y && sudo apt autoremove -y
apt install apparmor python3 python-is-python3 python3-pip fish git jq wget curl udisks2 libglib2.0-bin network-manager dbus -y
python3 -m pip install --upgrade scd30_i2c ST7735 numpy Pillow fonts font-roboto

chown -R brauni:brauni /opt

mkdir /opt/co2ampel
curl -sSL https://raw.githubusercontent.com/herobrauni/raspberry/main/co2ampel.py -o /opt/co2ampel/co2ampel.py
curl -sSL https://raw.githubusercontent.com/herobrauni/raspberry/main/co2ampel.service -o /lib/systemd/system/co2ampel.service

systemctl start co2ampel.service
systemctl enable co2ampel.service

### https://community.home-assistant.io/t/installing-home-assistant-supervised-on-a-raspberry-pi-with-debian-11/247116
apt --fix-broken install
curl -fsSL get.docker.com | sh

wget https://github.com/home-assistant/os-agent/releases/download/1.2.2/os-agent_1.2.2_linux_aarch64.deb
dpkg -i os-agent_1.2.2_linux_aarch64.deb

wget https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb
dpkg -i homeassistant-supervised.deb


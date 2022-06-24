#!/usr/bin/env bash

# Enable i2c and spi via raspi-config

# run as root
# curl -sSL https://raw.githubusercontent.com/herobrauni/raspberry/main/install.sh | bash

apt update && apt upgrade
apt install apparmor python3 python-is-python3 python3-pip fish git
python3 -m pip install --upgrade scd30_i2c ST7735 numpy Pillow fonts font-roboto

chown -R brauni:brauni /opt

mkdir /opt/co2ampel
curl -sSL https://raw.githubusercontent.com/herobrauni/raspberry/main/co2ampel.py -o /opt/co2ampel/co2ampel.py
curl -sSL https://raw.githubusercontent.com/herobrauni/raspberry/main/co2ampel.service -o /lib/systemd/system/co2ampel.service

systemctl start co2ampel.service
systemctl enable co2ampel.service
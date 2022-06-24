#!/usr/bin/env bash

# Enable i2c and spi via raspi-config

sudo apt update && sudo apt upgrade
sudo apt install apparmor python3 python-is-python3 python3-pip   
sudo python3 -m pip install --upgrade scd30_i2c ST7735 numpy Pillow fonts font-roboto

sudo chown -R brauni:brauni /opt

mkdir /opt/co2ampel
curl -sSL 
#!/bin/sh
wget -P /tmp https://downloads.hypriot.com/docker-hypriot_1.10.3-1_armhf.deb
dpkg -i /tmp/docker-hypriot_1.10.3-1_armhf.deb
rm -rf /tmp/docker-hypriot_1.10.3-1_armhf.deb
systemctl enable docker && systemctl start docker

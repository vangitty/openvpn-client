#!/bin/bash

# Verzeichnisse für Tinyproxy erstellen
mkdir -p /var/run/tinyproxy /var/log/tinyproxy
chown -R nobody:nogroup /var/run/tinyproxy /var/log/tinyproxy

# Tinyproxy im Hintergrund starten
tinyproxy -c /etc/tinyproxy/tinyproxy.conf

# OpenVPN starten (im Vordergrund)
exec openvpn --config /vpn/config.ovpn

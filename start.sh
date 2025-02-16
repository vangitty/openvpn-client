#!/bin/bash

# Verzeichnisse für Tinyproxy erstellen
mkdir -p /var/run/tinyproxy /var/log/tinyproxy
chown -R nobody:nogroup /var/run/tinyproxy /var/log/tinyproxy

# Tinyproxy im Hintergrund starten
tinyproxy -c /etc/tinyproxy/tinyproxy.conf

# Auth-Datei aus Umgebungsvariablen erstellen
echo "$OVPN_USERNAME" > /vpn/auth.txt
echo "$OVPN_PASSWORD" >> /vpn/auth.txt
chmod 600 /vpn/auth.txt

# OpenVPN mit auth-file starten
exec openvpn --config /vpn/config.ovpn --auth-user-pass /vpn/auth.txt --auth-nocache

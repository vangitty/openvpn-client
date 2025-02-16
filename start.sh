#!/bin/sh
# Starte OpenVPN mit der vorhandenen Konfiguration im Hintergrund
/usr/bin/openvpn.sh &

# Starte Tinyproxy im Vordergrund, damit der Container aktiv bleibt
exec tinyproxy -d

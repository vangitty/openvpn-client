#!/bin/sh
# Starte OpenVPN über das vorhandene Skript im Hintergrund
/usr/bin/openvpn.sh &

# Starte Tinyproxy im Vordergrund, damit der Container aktiv bleibt
exec tinyproxy -d

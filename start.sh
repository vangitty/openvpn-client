#!/bin/bash
# Create auth file
echo "$OVPN_USERNAME" > /vpn/auth.txt
echo "$OVPN_PASSWORD" >> /vpn/auth.txt
chmod 600 /vpn/auth.txt

# Start OpenVPN with auth file
exec openvpn --config /vpn/config.ovpn --auth-user-pass /vpn/auth.txt --auth-nocache

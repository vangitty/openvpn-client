#!/bin/bash
# Ensure VPN config directory exists and has proper permissions
mkdir -p /vpn
chown -R nobody:vpn /vpn
chmod 750 /vpn

# Start OpenVPN with proper permissions
exec openvpn --config /vpn/config.ovpn --script-security 2

FROM alpine
MAINTAINER David Personette <dperson@gmail.com>

# Update und Installation von OpenVPN, Tinyproxy und benötigten Paketen
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl ip6tables iptables openvpn tinyproxy \
                shadow tini tzdata && \
    addgroup -S vpn && \
    rm -rf /tmp/*

# Erstelle das Verzeichnis für Tinyproxy PID-Datei
RUN mkdir -p /var/run/tinyproxy && \
    chown nobody:nogroup /var/run/tinyproxy

# Kopiere das originale OpenVPN-Skript
COPY openvpn.sh /usr/bin/

# Kopiere die angepasste Tinyproxy-Konfiguration
COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf

# Persistent Storage: /vpn wird von Coolify als Volume gemountet
VOLUME ["/vpn"]

# Kopiere das Startskript, das beide Dienste startet
COPY start.sh /usr/bin/
RUN chmod +x /usr/bin/start.sh

HEALTHCHECK --interval=60s --timeout=15s --start-period=120s \
             CMD curl -LSs 'https://api.ipify.org'

# Verwende tini als Init-Prozess und starte das Startskript
ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/start.sh"]


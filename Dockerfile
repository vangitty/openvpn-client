FROM alpine
MAINTAINER David Personette <dperson@gmail.com>

# Update und Installation der benötigten Pakete:
# - openvpn, tinyproxy, util-linux (liefert u.a. das sg-Kommando),
# - bash, curl, iptables, ip6tables, shadow, tini, tzdata
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl ip6tables iptables openvpn tinyproxy util-linux \
                shadow tini tzdata && \
    addgroup -S vpn && \
    # Erstelle das Verzeichnis für die Tinyproxy PID-Datei und Logs
    mkdir -p /var/run/tinyproxy /var/log/tinyproxy && \
    chown nobody:nogroup /var/run/tinyproxy /var/log/tinyproxy && \
    rm -rf /tmp/*

# Kopiere das originale openvpn-Skript (wird später im Startskript genutzt)
COPY openvpn.sh /usr/bin/

# Kopiere deine angepasste Tinyproxy-Konfiguration ins Image
COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf

# Kopiere das neue Startskript, das beide Dienste startet
COPY start.sh /usr/bin/
RUN chmod +x /usr/bin/start.sh

# HEALTHCHECK bleibt unverändert
HEALTHCHECK --interval=60s --timeout=15s --start-period=10s \
             CMD curl -LSs 'https://api.ipify.org'

# /vpn wird als persistent Volume gemountet (Coolify mountet hier deine config.ovpn etc.)
VOLUME ["/vpn"]

# Nutze tini als Init-Prozess und starte das Startskript
ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/start.sh"]


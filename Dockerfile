FROM alpine
MAINTAINER David Personette <dperson@gmail.com>

# Update und Installation von OpenVPN und benötigten Paketen inklusive Tinyproxy
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl ip6tables iptables openvpn tinyproxy \
                shadow tini tzdata && \
    addgroup -S vpn && \
    rm -rf /tmp/*

# Kopiere das originale OpenVPN-Skript (sofern benötigt)
COPY openvpn.sh /usr/bin/

# Kopiere deine angepasste Tinyproxy-Konfiguration ins richtige Verzeichnis
COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf

# Optional: Port für Tinyproxy freigeben (Standard ist meist 3128)
EXPOSE 3128

# Kopiere ein neues Startskript, das beide Dienste startet
COPY start.sh /usr/bin/
RUN chmod +x /usr/bin/start.sh

# Healthcheck bleibt unverändert
HEALTHCHECK --interval=60s --timeout=15s --start-period=120s \
             CMD curl -LSs 'https://api.ipify.org'

VOLUME ["/vpn"]

# Verwende tini als Init und starte das Startskript
ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/start.sh"]

FROM alpine
MAINTAINER David Personette <dperson@gmail.com>

# Setze PATH explizit (falls nicht schon gesetzt)
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Update und Installation von OpenVPN, Tinyproxy, util-linux (liefert sg) und anderen benötigten Paketen
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl ip6tables iptables openvpn tinyproxy util-linux shadow tini tzdata && \
    addgroup -S vpn && \
    # Erstelle das Verzeichnis für Tinyproxy PID-Datei und Logs und setze die Berechtigungen
    mkdir -p /var/run/tinyproxy /var/log/tinyproxy && \
    chown nobody:nogroup /var/run/tinyproxy /var/log/tinyproxy && \
    rm -rf /tmp/* && \
    # Erstelle symbolischen Link, falls openvpn.sh /bin/sg erwartet
    ln -s /usr/bin/sg /bin/sg

# Kopiere das originale openvpn-Skript (wird später im Startskript genutzt)
COPY openvpn.sh /usr/bin/

# Kopiere deine angepasste Tinyproxy-Konfiguration
COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf

# Kopiere das neue Startskript, das beide Dienste startet
COPY start.sh /usr/bin/
RUN chmod +x /usr/bin/start.sh

# HEALTHCHECK bleibt unverändert (kannst du bei Bedarf anpassen)
HEALTHCHECK --interval=60s --timeout=15s --start-period=10s \
             CMD curl -LSs 'https://api.ipify.org'

# /vpn wird als persistent Volume gemountet (Coolify mountet hier deine config.ovpn und ggf. weitere Dateien)
VOLUME ["/vpn"]

# Nutze tini als Init-Prozess und starte das Startskript
ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/start.sh"]

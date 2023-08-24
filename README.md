# Homelab Zusammenfassung
![GitHub last commit](https://img.shields.io/github/last-commit/erikslevin/docker) 

* [cturra](https://github.com/ErikSlevin/docker/tree/main/cturra): NTP-Zeitserver für das Heimnetzwerk. 
* [gotify](https://github.com/ErikSlevin/docker/tree/main/gotify): Self-Hosted Benachrichtigungsdienst
* [grafana](https://github.com/ErikSlevin/docker/tree/main/grafana): Monitoring & Visualisierung
* [heimdall](https://github.com/ErikSlevin/docker/tree/main/heimdall): Self-Hosted Dashboard
* [mariadb](https://github.com/ErikSlevin/docker/tree/main/mariadb): Relationales Open-Source-Datenbankmanagementsystem
* [phpmyadmin](https://github.com/ErikSlevin/docker/tree/main/phpmyadmin): Frontend für die Administration von MySQL-Datenbanken 
* [pi-hole](https://github.com/ErikSlevin/docker/tree/main/pi-hole): Seldhosted Werbeblocker für das Heimnetzwerk.
* [snowflake](https://github.com/ErikSlevin/docker/tree/main/snowflake): Tor-Proxy: ermöglicht Menschen, trotz Netzsperren auf das Internet zuzugreifen
* [tandoor](https://github.com/ErikSlevin/docker/tree/main/tandoor): Selbstverwaltete Online-Rezeptdatenbank, die Wochenpläne erzeugt, Einkaufslisten generiert.
* [tasmoadmin](https://github.com/ErikSlevin/docker/tree/main/tasmoadmin): Geräte mit Tasmota Firmware über ein zentrales Webinterface verwalten.
* [traefik](https://github.com/ErikSlevin/docker/tree/main/traefik): Reverse-Proxy und Load-Balancer
* [uptime-kuma](https://github.com/ErikSlevin/docker/tree/main/uptime-kuma): Self-Hosted Monitoring Tool
* [valtwarden](https://github.com/ErikSlevin/docker/tree/main/valtwarden): Selfhosted Passwort-Tresor mit Zugriff von Unterwegs!
* [watchtower](https://github.com/ErikSlevin/docker/tree/main/watchtower): Automatische aktualisierung von Docker Containern

## Backup and Restore

1. docker run --rm --volumes-from heimdall -v $(pwd):/backup busybox tar cvfz /backup/2023-08-24-heimdall-backup.tar /config
2. docker run --rm --volumes-from heimdall -v $(pwd):/home/erik busybox sh -c "cd /config && tar xvf /home/erik/2023-08-24-heimdall-backup.tar --strip 1"

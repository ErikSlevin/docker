# Traefik

<p align="center">
<a href="https://github.com/traefik/traefik"><img src="https://github.com/traefik/traefik/raw/master/docs/content/assets/img/traefik.logo.png" width="350" alt="traefik"></a><br/>
</p>

| Datum | Beschreibung |
|:----------:|--------------|
| 02.01.2023 | Anleitung erstellt |
| 09.09.2023 | Komplette Überarbeitung der Anleitung |


## Anleitung
```console
# Docker Netzwerke erstellen
docker network create --subnet=10.0.10.0/24 --gateway=10.0.10.1 intern
docker network create --subnet=10.0.20.0/24 --gateway=10.0.20.1 extern

# Verzeichnis für Traefik anlegen
mkdir -pv ~/docker_files/traefik

# Benötigte Dateien anlegen
touch ~/docker_files/traefik/{dynamic_conf.yml,acme.json,traefik.yml,users.file}

# Berechtigung für die acme.json setzen
sudo chmod 600 /opt/containers/traefik/data/acme.json

# Apache2-Utils installieren für generierung von Passwort-Hashes
sudo apt install apache2-utils -y

# Neue Benutzer anlegene
# Usage: htpasswd -b path/to/your/users.file User 'Password'
htpasswd -b ~/docker_files/traefik/users.file TestUser1 'SuperSecurePa$$w0rd'
htpasswd -b ~/docker_files/traefik/users.file TestUser2 'SuperSecurePa$$w0rd'
htpasswd -b ~/docker_files/traefik/users.file TestUser3 'SuperSecurePa$$w0rd'
```
> [`dynamic_conf.yml`](dynamic_conf.yml) [`traefik.yml`](traefik.yml)

## Quellen
* [*Traefik v2 – Reverse-Proxy mit CrowdSec einrichten*](https://goneuland.de/traefik-v2-reverse-proxy-mit-crowdsec-einrichten/#more-13529)
* [*Traefik v2 – Reverse Proxy für Docker unter Debian 10 / 11 / 12 einrichten*](https://goneuland.de/traefik-v2-reverse-proxy-fuer-docker-unter-debian-10-einrichten/)
* [*Traefik auf Server/Raspberry Pi installieren und einrichten: Reverse Proxy für Docker mit Let’s Encrypt HTTPS-Zertifikaten*](https://u-labs.de/portal/traefik-auf-server-raspberry-pi-installieren-und-einrichten-reverse-proxy-fuer-docker-mit-lets-encrypt-https-zertifikaten/)


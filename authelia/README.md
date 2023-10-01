# Authelia – Zweifaktor Authentifizierung

Authelia ermöglicht 2FA für Docker mit Traefik, um die Webanwendungssicherheit zu steigern.

| Datum | Beschreibung |
|:----------:|--------------|
| 13.10.2023 | Anleitung erstellt |

## Beschreibung

Authelia ist eine leistungsstarke Open-Source-Softwarelösung, die speziell für die Implementierung von Zwei-Faktor-Authentifizierung (2FA) in Docker-Umgebungen in Verbindung mit dem Reverse-Proxy Traefik entwickelt wurde. Mit Authelia können Docker-basierte Webanwendungen und Dienste eine zusätzliche Sicherheitsebene hinzufügen, indem sie Benutzer zur Eingabe eines zweiten Authentifizierungsfaktors auffordern, nachdem sie ihr Passwort eingegeben haben.

Diese Kombination aus Authelia und Traefik ermöglicht es, den Zugriff auf Ihre Webanwendungen zu schützen und sicherzustellen, dass nur autorisierte Benutzer auf vertrauliche Informationen zugreifen können. Authelia unterstützt verschiedene 2FA-Methoden, darunter Time-based One-Time Passwords (TOTP) und YubiKey-Integration, und kann einfach in bestehende Docker-Container und Traefik-Reverse-Proxy-Setups integriert werden.

Mit Authelia und Traefik können Sie die Sicherheit Ihrer Docker-Anwendungen erhöhen und gleichzeitig eine benutzerfreundliche und flexible Methode zur Implementierung von 2FA in Ihren Projekten nutzen.

## Grundkonfiguration
```
.
├── config
│   ├── configuration.yml
│   ├── db.sqlite3
│   └── users_database.yml
└── docker-compose.yml
```

``` shell
# Ordner-Struktur anlegen
mkdir -p ~/docker_files/authelia/config

# docker-compose erstellen
# Domain bei Traefik anpassen („authelia.yourdomain.de“)
nano  ~/docker_files/authelia/docker-compose.yml

# configuration.yml erstellen
# Bei access_control ggf. Domains anpassen
# jwt_secret: https://jwt.io - einfach random Daten eingeben auf der rechten Seite
# encryption_key: https://jwt.io - einfach random Daten eingeben auf der rechten Seite
nano  ~/docker_files/authelia/config/configuration.yml

# dynamic_conf.yml von Traefik öffnen und den part "middlewares-authelia" hinzufühgen
nano ~/docker_files/traefik-crowdsec-stack/traefik/dynamic_conf.yml

# Traefik neu starten
docker compose -f ~/docker_files/traefik-crowdsec-stack/docker-compose.yml down
docker compose -f ~/docker_files/traefik-crowdsec-stack/docker-compose.yml up -d

# Authelia User anlegen
docker run authelia/authelia:latest authelia hash-password <Wunschpasswort>

# Hash-Wert in die users_database.yml einfügen
# 2x Anmeldename anpassen & Hashwert
nano  ~/docker_files/authelia/config/users_database.yml

# Authelia starten
docker compose -f ~/docker_files/authelia/docker-compose.yml up -d

```
> [`docker-compose.yml`](docker-compose.yml)
> [`configuration.yml`](config/configuration.yml)
> [`dynamic_conf.yml`](traefik/dynamic_conf.yml)
> [`users_database.yml`](config/users_database.yml)

## Weitere Dienste absichern

Beispiel: Portainer

``` shell
    labels:
      com.centurylinklabs.watchtower.enable: true
      traefik.docker.network: extern
      traefik.enable: "true"
      traefik.http.routers.portainer-secure.entrypoints: websecure
      traefik.http.routers.portainer-secure.middlewares: default@file,middlewares-authelia@file
      traefik.http.routers.portainer-secure.rule: Host(`portainer.yourdomain.de`)
      traefik.http.routers.portainer-secure.service: portainer
      traefik.http.routers.portainer-secure.tls: "true"
      traefik.http.routers.portainer-secure.tls.certresolver: http_resolver
      traefik.http.routers.portainer.entrypoints: web
      traefik.http.routers.portainer.rule: Host(`portainer.erikslevin.de`)
      traefik.http.services.portainer.loadbalancer.server.port: "9000"
```

Beispiel: Traefik
``` shell
    labels:
      traefik.docker.network: extern
      traefik.enable: "true"
      traefik.http.routers.traefik.entrypoints: websecure
      traefik.http.routers.traefik.middlewares: default@file,middlewares-authelia@file
      traefik.http.routers.traefik.rule: Host(${SERVICES_TRAEFIK_LABELS_TRAEFIK_HOST})
      traefik.http.routers.traefik.service: api@internal
      traefik.http.routers.traefik.tls: "true"
      traefik.http.routers.traefik.tls.certresolver: http_resolver
      traefik.http.services.traefik.loadbalancer.sticky.cookie.httpOnly: "true"
      traefik.http.services.traefik.loadbalancer.sticky.cookie.secure: "true"
      traefik.http.routers.pingweb.rule: PathPrefix(`/ping`)
      traefik.http.routers.pingweb.service: ping@internal
      traefik.http.routers.pingweb.entrypoints: websecure
```

Beispiel: Externe Dienste
Synology Frontend - muss in der dynamic_conf.yml angepasst werden
``` shell
http:
    dsm-frontend:
      entryPoints:
        - "websecure"
      rule: Host(`dsm.yourdomain.de`)
      middlewares:
        - default
        - traefik-crowdsec-bouncer
        - middlewares-authelia
      tls:
        certResolver: http_resolver
      service: dsm-frontend
  services:
    dsm-frontend:
      loadBalancer:
        servers:
          - url: "https://x.x.x.x:30000"
```
> [`dynamic_conf.yml`](_traefik/dynamic_conf.yml)

## Quellen
- [*Authelia – Zweifaktor Authentifizierung mittels Docker Compose und Traefik installieren*](https://goneuland.de/authelia-zweifaktor-authentifizierung-mittels-docker-compose-und-traefik-installieren/)
- [*Traefik v2 – Reverse-Proxy mit CrowdSec einrichten*](https://goneuland.de/traefik-v2-reverse-proxy-mit-crowdsec-einrichten/)



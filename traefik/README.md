<p align="center">
<a href="https://github.com/traefik/traefik"><img src="https://github.com/traefik/traefik/raw/master/docs/content/assets/img/traefik.logo.png" width="350" alt="traefik"></a><br/>
</p>

# Traefik
Reverse-Proxy und Load-Balancer

## Anleitung

Konfigurationsdaten:
* [traefik.yml](traefik.yml)
* [dynamic_conf.yml](dynamic_conf.yml)
* *acme.json (leere Datei)*
``` shell
mkdir -p /opt/containers/traefik/data
touch /opt/containers/traefik/data/dynamic_conf.yml
touch /opt/containers/traefik/data/acme.json
touch /opt/containers/traefik/data/traefik.yml
chmod 600 /opt/containers/traefik/data/acme.json
```

Benutzer anlegen und in der [docker-compose.yml](docker-compose.yml) unter ```traefik.http.middlewares.traefik-auth.basicauth.users=``` ändern.
``` shell
echo $(htpasswd -nb <user> <password>) | sed -e s/\\$/\\$\\$/g

Zum Beispiel:
echo $(htpasswd -nb benutzer strengespasswort) | sed -e s/\\$/\\$\\$/g
Ausgabe: benutzer:$$apr1$$uNheRNLT$$apG7iqwertzfV0ob6pJFs0
```

## Quellen
* [https://goneuland.de/traefik-v2-reverse-proxy-mit-crowdsec-einrichten/#more-13529](https://goneuland.de/traefik-v2-reverse-proxy-mit-crowdsec-einrichten/#more-13529)
* [https://goneuland.de/traefik-v2-reverse-proxy-fuer-docker-unter-debian-10-einrichten/](https://goneuland.de/traefik-v2-reverse-proxy-fuer-docker-unter-debian-10-einrichten/)
* [https://u-labs.de/portal/traefik-auf-server-raspberry-pi-installieren-und-einrichten-reverse-proxy-fuer-docker-mit-lets-encrypt-https-zertifikaten/](https://u-labs.de/portal/traefik-auf-server-raspberry-pi-installieren-und-einrichten-reverse-proxy-fuer-docker-mit-lets-encrypt-https-zertifikaten/)
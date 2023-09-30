<p align="center">
<a href="https://grafana.com/"><img src="https://github.com/louislam/uptime-kuma/raw/master/public/icon.svg" width="150" alt="Uptime-Kuma"></a><br/>
</p>

# Uptime-Kuma
Self-Hosted Monitoring Tool

## Docker Host einrichten

Um Docker-Container überwachen zu können, folgende Einstellungen in `Einstellungen > Docker Host` übernehmen:

* Anzeigename: `Pi-Docker-1 (Beispiel=` 
* Verbindungstyp: `Socket`
* Docker Daemon: `/var/run/docker.sock`

> **Hinweis**
> Dies ist nur möglich, wenn das Volume `docker.sock` gemountet wird in der Docker-Compose File.

## Quellen
* [https://github.com/louislam/uptime-kuma](https://github.com/louislam/uptime-kuma)
* [https://github.com/louislam/uptime-kuma/wiki/How-to-Monitor-Docker-Containers](https://github.com/louislam/uptime-kuma/wiki/How-to-Monitor-Docker-Containers)
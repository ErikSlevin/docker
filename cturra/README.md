# Authelia – Zweifaktor Authentifizierung

NTP-Zeitserver mit chrony auf Alpine Linux.

| Datum | Beschreibung |
|:----------:|--------------|
| 13.10.2023 | Anleitung erstellt |

## Beschreibung

Der Container "cturra" läuft auf Alpine Linux und dient als NTP-Zeitserver, der das Network Time Protocol (NTP) mithilfe von chrony implementiert. chrony ermöglicht die Synchronisierung der Systemuhr mit NTP-Servern, Referenzuhren wie GPS-Empfängern und manuellen Eingaben über Armbanduhr und Tastatur. Darüber hinaus kann dieser Container auch als NTPv4 (RFC 5905) Server und Peer fungieren, um Zeitdienste für andere Computer im Netzwerk bereitzustellen.

## Grundkonfiguration
```
.
└── docker_files
    └── cturra
        └── docker-compose.yml
```

``` shell
# Ordner-Struktur anlegen
mkdir -p ~/docker_files/cturra

# docker-compose erstellen
nano  ~/docker_files/cturra/docker-compose.yml

```
> [`docker-compose.yml`](docker-compose.yml)

## Zeitabfage

``` shell
ntpdate -q <ip-adresse>

# server 10.0.0.20, stratum 2, offset -0.411748, delay 0.02588
# 1 Oct 16:18:04 ntpdate[515560]: adjust time server 10.0.0.20 offset -0.411748 sec
```

## Quellen
- [*cturra/ntp*](https://hub.docker.com/r/cturra/ntp)
- [*The list of public primary (Stratum 1) time servers.*](https://www.advtimesync.com/docs/manual/stratum1.html)



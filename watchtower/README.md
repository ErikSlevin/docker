# Watchtower

Watchtower automatisiert die Aktualisierung von Docker-Containern, um sicherzustellen, dass sie stets aktuell sind.

| Datum | Beschreibung |
|:----------:|--------------|
| 01.10.2023 | Anleitung erstellt |

## Beschreibung

Watchtower ist ein Open-Source-Tool zur Automatisierung der Aktualisierung von Docker-Containern. Mit Watchtower können Docker-Container überwacht werden, um festzustellen, ob neue Versionen ihrer Images verfügbar sind, und sie automatisch aktualisieren. Dies ermöglicht es Systemadministratoren und Entwicklern, Container-Anwendungen einfach und sicher auf dem neuesten Stand zu halten, ohne manuelle Eingriffe. Watchtower bietet eine bequeme Möglichkeit, die Sicherheit und die Leistung von Docker-Containern aufrechtzuerhalten, indem es sicherstellt, dass sie immer mit den neuesten Patches und Updates laufen.

## Grundkonfiguration
```
.
└── docker_files
    └── watchtower
        └── docker-compose.yml
```

```yaml
    labels:
      # Watchtower - Container automatisch aktualisieren
      - "com.centurylinklabs.watchtower.enable=true"

    labels:
      # Watchtower - melden wenn neue version Verfügbar
      - "com.centurylinklabs.watchtower.monitor-only=true"
```

## Quellen
- [*https://containrrr.dev/watchtower/*](https://containrrr.dev/watchtower/)
- [*https://schroederdennis.de/allgemein/watchtower-automatische-docker-container-updates/*](https://schroederdennis.de/allgemein/watchtower-automatische-docker-container-updates/)
- [*https://goneuland.de/docker-images-automatisiert-aktualisieren-mit-watchtower/*](https://goneuland.de/docker-images-automatisiert-aktualisieren-mit-watchtower/)
- [*https://crontab.cronhub.io/*](https://crontab.cronhub.io/)
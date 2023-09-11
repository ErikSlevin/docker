# Wireguard

<p align="center">
<a href="https://github.com/wg-easy/wg-easy"><img src="https://forum.gardion.de/uploads/default/optimized/1X/49942fec34bcebbf7aa92efd325b28b708e4d2cd_2_1035x543.png" width="350" alt="traefik"></a><br/>
</p>

| Datum | Beschreibung |
|:----------:|--------------|
| 09.10.2023 | Anleitung erstellt |
| 10.10.2023 | Backup & Restore hinzugefügt |

Wenn keine basicauth via File gewünscht ist, folgenes Label entfernen:
``` yaml
# .htaccess Authentifizierung
- "traefik.http.routers.wireguard-secure.middlewares=my-auth"
```

## Backup

``` console
docker stop wireguard

# Backup wird im aktuellen Verzeichniss gespeichert
docker run --rm --volumes-from wireguard -v $(pwd):/backup busybox tar cvfz /backup/$(date +'%Y%m%d')-wireguard-backup.tar /etc/wireguard

docker start wireguard

```

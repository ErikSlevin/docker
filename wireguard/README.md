# Wireguard

<p align="center">
<a href="https://github.com/wg-easy/wg-easy"><img src="https://forum.gardion.de/uploads/default/optimized/1X/49942fec34bcebbf7aa92efd325b28b708e4d2cd_2_1035x543.png" width="350" alt="traefik"></a><br/>
</p>

| Datum | Beschreibung |
|:----------:|--------------|
| 02.01.2023 | Anleitung erstellt |

Wenn keine basicauth via File gewünscht ist, folgenes Label entfernen:
``` yaml
# .htaccess Authentifizierung
- "traefik.http.routers.wireguard-secure.middlewares=my-auth"
```
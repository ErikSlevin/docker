<p align="center">
<a href="https://pi-hole.net"><img src="https://pi-hole.github.io/graphics/Vortex/Vortex_with_text.png" width="100" alt="Pi-hole"></a><br/>
</p>

# Pi-hole
Seldhosted Werbeblocker für das Heimnetzwerk.

## Pihole Blockisten & Whitelisten

Meine [Pi-hole Konfiguration](blocklists/) erweitere ich ständig, so dass diese perfekt für mich *persönlich* abgestimmt ist und es nicht zu einem Overblocking kommt.

* Zusammenfassung
  + über 18 Millionen Domains blockiert
  + 1 x Monatliches Update
  + Regex für:
    * weitere Blacklists
    * Whitelisten von einzelnen Diensten (Spotify, Office 365 etc.)
    * Whitelisten von einzelnen Seiten

Meine zusammenstellung: [Blocklisten / Whitelisten](blocklists/)

## Aktivieren / Deaktivieren via Shortcut

PiHole kann man ganz einfach aktivieren/deaktivieren mithilfe zweier Shortcuts in der Favoritenleiste.
Dazu einfach den API-Token kopieren und zwei Einträge (On / Off) in der Favoritenleiste des Browsers ablegen.

API Token kopieren: `PiHole Settings -> API / Web interface -> Show API token`

```shell
# Aktivieren
http://[Pi-Hole-IP]:[Port]/admin/api.php?enable&auth=[API-KEY]

# 15min Deaktivieren (15min = 900sek)
http://[Pi-Hole-IP]:[Port]/admin/api.php?disable=[SEKUNDEN]&auth=[API-KEY]

#Deaktivieren
http://[Pi-Hole-IP]:[Port]/admin/api.php?disable&auth=[API-KEY]
```

## Pi-hole Backup

Automatisches Backup der Pihole Konfiguration und Adlisten vie Cronjob.

1. [pihole-backup.sh](pihole-backup.sh) erstellen (Bsp.: /home/pi/pihole-backup.sh)
2. Skript ausführbar machen: ```sudo chmod +x pihole-backup.sh ```
3. Skript Eigentümer ändern: ```sudo chown root:root pihole-backup.sh```
4. Cronjob einstellen: ```sudo crontab -e```
5. Zeile einfügen: ```0 0 1 * * /home/pi/pihole-backup.sh >> /home/pi/pihole-backup.logfile 2>&1```

Skript wird am 01. jeden Monats um 0 Uhr ausgeführt. Intervall ändern: [https://crontab.cronhub.io/](https://crontab.cronhub.io/)

## Quellen:
* [https://pi-hole.net/](https://pi-hole.net/)
* [https://strobelstefan.org/2021/02/26/pi-hole-mit-unbound-werbeblocker](https://strobelstefan.org/2021/02/26/pi-hole-mit-unbound-werbeblocker-und-kontrolle-ueber-die-dns-anfragen-erhalten/)
* [https://hoerli.net/hoerlis-pi-holes-fuers-internet/](https://hoerli.net/hoerlis-pi-holes-fuers-internet/?unapproved=1315&moderation-hash=3a20abae663964b02d05708e5f89f7ea)
* [https://ubiquiti-networks-forum.de/wiki/entry/48-pihole-mit-dot-dnssec-oder-doh/](https://ubiquiti-networks-forum.de/wiki/entry/48-pihole-mit-dot-dnssec-oder-doh/)
* [https://github.com/RPiList/specials/tree/master/Blocklisten](https://github.com/RPiList/specials/tree/master/Blocklisten)
* [https://forums.unraid.net/topic/113080-anleitung-user-script-f%C3%BCr-pihole-teleporter-config-backup-per-ssh/](https://forums.unraid.net/topic/113080-anleitung-user-script-f%C3%BCr-pihole-teleporter-config-backup-per-ssh/)
* [https://unix.stackexchange.com/questions/565637/how-can-i-count-the-number-of-files-in-a-directory-and-delete-the-oldest-if-the](https://unix.stackexchange.com/questions/565637/how-can-i-count-the-number-of-files-in-a-directory-and-delete-the-oldest-if-the)
* [https://www.reddit.com/r/pihole/comments/k03omw/automate_backup_solution/](https://www.reddit.com/r/pihole/comments/k03omw/automate_backup_solution/)

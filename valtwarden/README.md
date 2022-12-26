<p align="center">
<a href="https://github.com/dani-garcia/vaultwarden"><img src="https://raw.githubusercontent.com/bitwarden/brand/master/icons/256x256.png" width="150px"></a><br/>
</p>

# Valtwarden
Selfhosted Passwort-Tresor mit Zugriff von Unterwegs!

## Anleitung

Valtwarden mit folgender Docker-Compose Konfiguration deployen:

``` yaml
environment:
      - SIGNUPS_ALLOWED=true            # Registration öffen für anmeldung

      - SHOW_PASSWORD_HINT=false        # Hinweise für die Passwortzurücksetzung anzeigen
      - ORG_CREATION_USERS=none         # Es können keine Organisationen erstellt werden
      - INVITATIONS_ALLOWED=false       # Es können keine neuen Benutzer eingeladen werden
      - DOMAIN=https://bitwarden.$TLD   # Zugang zu der Weboberfläche
      - TZ=$TIMEZONE                    # Zeitzone via .env-File
      - EMERGENCY_ACCESS_ALLOWED=false  # Notzugang deaktivieren
      - TRASH_AUTO_DELETE_DAYS=90       # Gelöschte Passwörter nach 90 Tagen löschen

```
Im Anschluss einen Benutzer erstellen und einloggen! Danach den Container stoppen und Docker-Compose ändern:

``` yaml
environment:
      - SIGNUPS_ALLOWED=false           # Keine neue Benutzer zulassen <<<-- Flag wird auf False gesetzt.

      - SHOW_PASSWORD_HINT=false        # Hinweise für die Passwortzurücksetzung anzeigen
      - ORG_CREATION_USERS=none         # Es können keine Organisationen erstellt werden
      - INVITATIONS_ALLOWED=false       # Es können keine neuen Benutzer eingeladen werden
      - DOMAIN=https://bitwarden.$TLD   # Zugang zu der Weboberfläche
      - TZ=$TIMEZONE                    # Zeitzone via .env-File
      - EMERGENCY_ACCESS_ALLOWED=false  # Notzugang deaktivieren
      - TRASH_AUTO_DELETE_DAYS=90       # Gelöschte Passwörter nach 90 Tagen löschen

```
> **Anmerkung**
> Es ändert sich nur die erste Zeile in der Docker-Compose File

Damit wird die Registration deaktiviert und nur der zuvor erstellte Benutzer kann sich einloggen. Die Registration kann man 
auch im Admin-Panel deaktivieren,dieses ist jedoch aus Sicherheitsgründen Standardmäßig deaktiviert.

## Valtwarden Tresor: Anlagen / Attachments

Um Anlagen im Tresor speichern zu können, muss folgendes durchgeführt werden:

1. Ordner im Volume `/data` erstellen mit dem Namen `attachments`
2. Valtwarden Container stoppen und im Anschluss wieder Starten


## Quellen

* [https://hub.docker.com/r/vaultwarden/server](https://hub.docker.com/r/vaultwarden/server)
* [https://schroederdennis.de/tutorial-howto/vaultwarden-raspberry-pi-docker-installieren-bitwarden-nginx-proxy-manager-https/](https://schroederdennis.de/tutorial-howto/vaultwarden-raspberry-pi-docker-installieren-bitwarden-nginx-proxy-manager-https/)
* [https://www.howtoforge.de/anleitung/so-installierst-du-vaultwarden-mit-docker-unter-ubuntu-22-04/](https://www.howtoforge.de/anleitung/so-installierst-du-vaultwarden-mit-docker-unter-ubuntu-22-04/)
* [https://vaultwarden.discourse.group/t/no-attachment-option-available/814/2](https://vaultwarden.discourse.group/t/no-attachment-option-available/814/2)
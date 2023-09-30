<p align="center">
<a href="https://gotify.net/"><img src="https://raw.githubusercontent.com/gotify/logo/master/gotify-logo.png" width="250" alt="Gotify"></a><br/>
</p>

# Gotify
Self-Hosted Benachrichtigungsdienst


## Gotify Konfiguration: Home Assistant

Zunächst in Gotify eine App mit dem Namen `Home Assistant` erstellen und den Token kopieren.
In Home Assistant in der Datei `/config/configuration.yaml` folgenden Abschnitt hinzufügen und den Token bei ` X-Gotify-Key: XXXX` einfügen.

```yaml
# Gotify Benachrichtigungen in Home Assistant
# /config/configuration.yaml

notify:
- name: gotify
  platform: rest
  resource: https://gotify.meinedomain.de/message
  method: POST_JSON
  headers: 
    X-Gotify-Key: !secret gotify_key
  message_param_name: message
  title_param_name: title
  data:
    priority: 6
    extras:
      client::display:
        contentType: "text/markdown"
```
Nach einem Neustart ist der konfigurierte Push-Dienst in Home Assistant unter `Entwickleroptionen > Dienste > notify.gotify` aufrufbar. 
Bei Automationen kann man den Push-Benachrichtigungsdienst unter `Aktionen > Dienst ausführen > notify.gotify` einbinden.

## Gotify Konfiguration: Synology Diskstation

Zunächst in Gotify eine App mit dem Namen `Home Assistant` erstellen und den Token kopieren.
In eurer Diskstation in der Datei `/usr/syno/etc/synowebhook.conf` folgenden Abschnitt hinzufügen und den Token bei ` X-Gotify-Key: XXXX` einfügen.

1. SSH Verbindung zu der Diskstation herstellen
2. Datei anlegen/ändern: `sudo vi /usr/syno/etc/synowebhook.conf`, vi-Editor Einfügen:
`EINFG-Taste`. Dabei folgendes anpassen:
Gotify-Port: `"port":1234`
Gotify-Key: `X-Gotify-Key:XXXXXX`
Gotifiy-URL: `"template":"http://192.168.0.XXX:XXXX/message"` und`"url":"http://192.168.0.XXX:XXXX/message"`

```json
{
  "Gotify":{
    "needssl":false,
        "port":1234,
        "prefix":"System event on  %HOSTNAME% on %DATE% at %TIME%.",
        "req_header":"Content-Type:application/json\rX-Gotify-Key:XXXXXX\r",
        "req_method":"post",
        "req_param":"{\"message\": \"@@TEXT@@\", \"title\": \"@@PREFIX@@\"}",
        "sepchar":" ",
        "template":"http://192.168.0.XXX:XXXX/message",
        "type":"custom",
        "url":"http://192.168.0.XXX:XXXX/message"
  }
}
```
3. Datei abspeichern (`ESC` danach `:wq` und mit `Enter` bestätigen)
4. Diskstation neustarten
5. DSM Weboberfläche: `Einstellungen > Benachrichtigungen > Push-Dienst > Anwender-Webhooks > Webhooks verwalten`
6. Es sollte nun wie folgt aussehn: [Bild-1](media/1.png), [Bild-2](media/2.png), [Bild-3](media/3.png), [Bild-4](media/4.png)


## Quellen
* [https://webworxshop.com/self-hosted-push-notifications-with-gotify-and-home-assistant/](https://webworxshop.com/self-hosted-push-notifications-with-gotify-and-home-assistant/)
* [https://www.home-assistant.io/integrations/notify.rest](https://www.home-assistant.io/integrations/notify.rest)
* [https://community.home-assistant.io/t/self-hosted-push-notifications-with-gotify/120307/22](https://community.home-assistant.io/t/self-hosted-push-notifications-with-gotify/120307/22)
* [https://www.reddit.com/r/synology/comments/z2kgfg/dsm_notifications_via_gotify_and_webhooks/](https://www.reddit.com/r/synology/comments/z2kgfg/dsm_notifications_via_gotify_and_webhooks/)
* [https://peekread.info/tech/20190716-ssh-login-notifications-with-gotify/](https://peekread.info/tech/20190716-ssh-login-notifications-with-gotify/)
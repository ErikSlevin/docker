<p align="center">
<a href="https://hub.docker.com/_/httpd"><img src="media/apache.png" width="200"><img style="margin-left:4em" src="media/php.png" width="100"></a><br/>
</p>

# Apache + PHP
mysql installieren

```shell
sudo docker exec -it apache-php /bin/bash
docker-php-ext-install mysqli
```


`mysqli.sh` im Container unter /home/ ablegen. Datei wird nach jeder aktualisierung durch Watchtower durchgeführt. Diese bewirkt, dass die php-mysqli Abhängigkeit installiert wird. Diese wird benötigt, um eine MariaDB Verbindung herzustellen und die eigegebenden Werte zu speichern.
```shell
#!/bin/bash

# mysqli-Abhaengigkeiten installieren fuer MariaDB-Connect
docker-php-ext-install mysqli
```


## Quellen
* [https://stackoverflow.com/a/54115590](https://stackoverflow.com/a/54115590)
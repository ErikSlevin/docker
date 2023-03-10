<p align="center">
<a href="https://hub.docker.com/_/httpd"><img src="media/apache.png" width="200"><img style="margin-left:4em" src="media/php.png" width="100"></a><br/>
</p>

# Apache + PHP
mysql installieren

```shell
sudo docker exec -it apache-php /bin/bash
docker-php-ext-install mysqli
```

Damit nach einer Container aktualisierung das Moduk `mysqli` vorhanden ist, folgenden crontab setzen:
```15 1 */1 * * /home/erik/skripts/mysqli.sh >> /home/erik/logs/mysqli.sh.log 2>&1```

`mysqli.sh` auf dem Host unter `/home/<USERNAME>/skripts/` ablegen. 
```shell
#!/bin/bash

# Das aktuelle Datum und die Uhrzeit
datetime=$(date +"%Y-%m-%d %H:%M:%S")

# Überprüfen, ob das mysqli-Erweiterungsmodul bereits aktiviert ist
if docker exec -it apache bash -c 'php -m | grep -q mysqli'; then
    echo "${datetime}: Das mysqli-Erweiterungsmodul ist bereits aktiviert."
else
    # Installieren des mysqli-Erweiterungsmoduls
    docker exec -it apache bash -c 'docker-php-ext-install mysqli'
    docker exec -it apache bash -c 'docker-php-ext-enable mysqli'

    # Neustart von Apache
    docker exec -it apache bash -c 'service apache2 restart'
    echo "${datetime}: Das mysqli-Erweiterungsmodul wurde erfolgreich installiert und aktiviert."
fi

```


## Quellen
* [https://stackoverflow.com/a/54115590](https://stackoverflow.com/a/54115590)
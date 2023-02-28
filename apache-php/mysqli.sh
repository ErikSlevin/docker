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
    echo "${datetime}: Das mysqli-Erweiterungsmodul wurde erfolgreich installiert und aktiviert."
fi
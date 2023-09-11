#!/bin/bash

# Standardwerte für die vordefinierten Pfade pro Container
declare -A container_paths
container_paths=(
  ["mariadb"]="/config /var/lib/mysql"
  ["valtwarden"]="/data"
  ["pihole"]="/etc/dnsmasq.d /etc/pihole"
  ["heimdal"]="/config"
  ["portainer"]="/var/run/docker.sock /data"
  ["influxdb"]="/var/lib/influxdb"
  ["tasmo-admin"]="/data /home/pi/Docker/TasmoAdmin/data"
  ["grafana"]="/var/lib/grafana /etc/grafana/provisioning/datasources"
  ["gotify"]="/app/data"
  ["traefik"]="/acme.json /dynamic_conf.yml /traefik.yml"
  ["phpmyadmin"]="/www/themes/theme /etc/phpmyadmin/config.user.inc.php /sessions"
  ["wireguard"]="/etc/wireguard"
)

# Funktion zur Anzeige der Hilfe
show_help() {
    echo "Verwendung: $0 [Optionen]"
    echo "Optionen:"
    echo "  --container NAME     Einen Container-Namen auswählen"
    echo "  --path PFAD1 PFAD2   Benutzerdefinierte Pfade für das Backup (mindestens ein Pfad erforderlich)"
    echo "  --help               Diese Hilfe anzeigen"
    echo
    echo "Verfügbare Container:"
    for container_name in "${!container_paths[@]}"; do
        echo "  $container_name"
    done
    echo
    echo "Beispiel 1: Backup eines Containers mit vordefinierten Pfaden"
    echo "  $0 --container valtwarden"
    echo
    echo "Beispiel 2: Backup eines Containers mit benutzerdefinierten Pfaden"
    echo "  $0 --container custom_container --path /custom/path1 /custom/path2"
    exit 0
}

# Überprüfen, ob das Skript ohne Argumente aufgerufen wurde
if [ $# -eq 0 ]; then
    show_help
fi

# Standardcontainer und Pfade
container_name=""
backup_paths=()

# Verarbeiten der Skriptparameter
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --container)
    container_name="$2"
    shift
    shift
    ;;
    --path)
    shift
    while [ $# -gt 0 ] && [[ $1 != --* ]]; do
        backup_paths+=("$1")
        shift
    done
    ;;
    --help)
    show_help
    ;;
    *)
    # Unbekannte Optionen werden ignoriert
    shift
    ;;
esac
done

# Überprüfen, ob der Container-Name angegeben wurde
if [ -z "$container_name" ]; then
    echo "Fehler: Bitte geben Sie einen Container-Namen mit --container an."
    exit 1
fi

# Wenn keine benutzerdefinierten Pfade angegeben wurden, verwenden Sie die vordefinierten Pfade
if [ ${#backup_paths[@]} -eq 0 ]; then
    if [ -n "${container_paths[$container_name]}" ]; then
        backup_paths=(${container_paths[$container_name]})
    else
        echo "Fehler: Der angegebene Container '$container_name' ist nicht in den vordefinierten Pfaden enthalten."
        exit 1
    fi
fi

# Legen Sie das Zielverzeichnis fest, in dem die Backups gespeichert werden sollen
backup_directory=$(pwd) # Hier verwenden wir das aktuelle Arbeitsverzeichnis als Standard

# Aktuelles Datum und Uhrzeit im gewünschten Format (Jahr-Monat-Tag-Stunde-Minute-Sekunde) abrufen
current_datetime=$(date +"%Y%m%d")

# Den Dateinamen erstellen, der den Namen des Containers und das Datum enthält
backup_filename="$current_datetime-$container_name-backup.tar"

# Den Befehl ausführen, um das Backup zu erstellen
docker run --rm --volumes-from "$container_name" -v "$backup_directory":/backup busybox tar cvfz "/backup/$backup_filename" "${backup_paths[@]}"

# Ausgabe zur Bestätigung
echo "Backup der angegebenen Pfade für den Container '$container_name' wurde erstellt und in $backup_directory/$backup_filename gespeichert."
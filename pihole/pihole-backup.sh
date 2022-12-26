#!/bin/bash
NAME=$(date +%F)-pihole-backup.tar.gz

# Speicherort vom Backup
BACKUPDIR=/home/erik/backup/

# Prüfe ob Directory exestiert - falls nicht wird dieses erstellt.
[ ! -d "$BACKUPDIR" ] && mkdir -p "$BACKUPDIR"

# Lösche ältere Backups
rm -r /home/erik/backup/*

# Backup erstellen
docker exec pihole /bin/bash pihole -a teleporter $NAME $$ exit

# Backup auf den Host kopieren
docker cp pihole:$NAME $BACKUPDIR$NAME

# Backup im Container löschen
docker exec pihole sh -c 'rm -f /'"$NAME"''
exit

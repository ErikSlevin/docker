#!/usr/bin/python
import subprocess
import mariadb
import json
from datetime import datetime


# Funktion zum Loggen der Einträge in die Datenbank
def log_entry(log_message):
    try:
        cursor = conn.cursor()
        log_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        cursor.execute("INSERT INTO pihole (timestamp, message) VALUES (?, ?)", (log_time, log_message))
        conn.commit()
        cursor.close()
    except mariadb.Error as e:
        print(f"Fehler beim Schreiben des Logeintrags: {e}")


# Funktion zum Erstellen des Backups
def create_backup():
    name = datetime.now().strftime("%F") + "-pihole-backup.tar.gz"
    backup_dir = "/home/erik/backup/"

    try:
        subprocess.run(["rm", "-r", backup_dir])  # Lösche ältere Backups
        subprocess.run(["mkdir", "-p", backup_dir])  # Prüfe und erstelle Backup-Verzeichnis falls nicht vorhanden

        # Backup erstellen
        subprocess.run(["docker", "exec", "pihole", "/bin/bash", "pihole", "-a", "teleporter", name, "$$", "exit"])

        # Backup auf den Host kopieren
        subprocess.run(["docker", "cp", f"pihole:{name}", backup_dir + name])

        # Backup im Container löschen
        subprocess.run(["docker", "exec", "pihole", "sh", "-c", f"rm -f /{name}"])

        log_entry("PiHole: Backup wurde erstellt.")
    except subprocess.CalledProcessError as e:
        log_entry(f"PiHole: Fehler beim Erstellen des Backups: {e}")


# Hauptskript
try:
    conn = mariadb.connect(
        user="root",
        password="xxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        host="127.0.0.1",
        database="logs"
    )
    cursor = conn.cursor()
    cursor.execute("CREATE TABLE IF NOT EXISTS pihole (id INT AUTO_INCREMENT PRIMARY KEY, timestamp DATETIME, message TEXT)")
    cursor.close()
except mariadb.Error as e:
    print(f"Fehler während der Verbindung zu der MariaDB Plattform: {e}")
else:
    current_time = datetime.now().strftime("%H:%M")

    # Überprüfen, ob es zwischen 13:20 und 13:25 Uhr ist und Backup erstellen
    create_backup()
    docker_command = "docker exec -it pihole /bin/bash -c 'pihole -c -j'"
    result = subprocess.check_output(docker_command, shell=True, text=True)

    with open("/home/erik/backup/uniqueDomains.json", "w") as file:
        file.write(result)

    conn.close()
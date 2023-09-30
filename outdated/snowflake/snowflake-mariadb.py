#!/usr/bin/python
import mariadb
import re
from datetime import datetime
import subprocess
import pytz # Zeitzone
import tzlocal


# Versuche DB-Verbindung herzustellen
try:
    conn = mariadb.connect(
        user="snowflake",
        password="XXXXXXXXXXXXXXXXX",
        host="127.0.0.1",
        database="snowflake"
    )

# DB-Verbindung konnte nicht hergestellt werden
except mariadb.Error as e:
    print(f"Fehler während der Verbindung zu der MariaDB Plattform: {e}")
    sys.exit(1)

# DB-Verbindung hergestellt
else:

    # Prüfe, ob Tabelle vorhanden ist
    try:
        mycursor = conn.cursor()
        mycursor.execute("SELECT * FROM snowflake")

    # Tabelle wird erstellt da nicht vorhanden
    except mariadb.Error as e:
        mycursor.execute("CREATE TABLE snowflake (date_time DATETIME, connections FLOAT, download FLOAT, upload FLOAT, sum_download FLOAT, sum_upload FLOAT, sum_connections INT)")

    # Tabelle ist vorhanden, fahre fort
    else:

        # Snowflage Log-File Speicherort
        logfile = subprocess.check_output("docker container inspect snowflake-proxy | grep 'LogPath' | awk -F: '{ print $2; }' | sed 's/\",//g' | sed 's/\"//g' | sed 's/\\n//g'", shell=True)
        logfile = str(logfile.strip()).replace("b'","").replace("'","")

        # Letzte Zeile vom Logfile einlesen
        with open(logfile, 'r') as f:
            last_line = f.readlines()[-1]

        # Prüfen, ob letzte Zeile fehler frei ist. Connections & Traffic muss vorhanden sein.
        connections = re.search("(([0-9]{0,4})( connections))", last_line) # Suchmuster: "11 connections"
        traffic = re.search("(↑ ([0-9]|\d{2,})\s(GB|MB|KB), ↓ ([0-9]|\d{2,})\s(GB|MB|KB))", last_line) # Suchmuster "↑ 6 MB, ↓ 360 KB"

        if (connections != None) and (traffic != None) and (int(connections.group(2)) > 0):

            # Datetime in Variable speichern und als Datetime-Objekt speichern
            datum = datetime.strptime(re.search("(\d{4}/\d{2}/\d{2} \d{2}:\d{2}:\d{2})",last_line).group(), "%Y/%m/%d %H:%M:%S")

            # Verbindungen in Variabel speichern
            db_verbindungen = int(connections.group(2))

            # Optional: Download umrechnen in MB
            if traffic.group(5) == "GB":
                db_dl_mb = float(traffic.group(4))*1024
            elif traffic.group(5) == "MB":
                db_dl_mb = float(traffic.group(4))
            elif traffic.group(5) == "KB":
                db_dl_mb = float(traffic.group(4))/1024

            # Optional: Upload umrechnen in MB
            if traffic.group(3) == "GB":
                db_ul_mb = float(traffic.group(2))*1024
            elif traffic.group(3) == "MB":
                db_ul_mb = float(traffic.group(2))
            elif traffic.group(3) == "KB":
                db_ul_mb = float(traffic.group(2))/1024

            # First run
            mycursor = conn.cursor()

            # Gesamtsumme von Downloads
            mycursor.execute("SELECT SUM(download) as SUM_DL, SUM(upload) as SUM_UL, SUM(connections) AS SUM_CON FROM `snowflake`;")
            query = mycursor.fetchone()

            # Prüfe, ob bereits Einträge vorhanden sind.
            # Keine Einträge vorhanen (weil erster Durchlauf) - setze Variablen auf Null
            if (query[0] == None):
                sum_dl = 0

            if (query[1] == None):
                sum_ul = 0

            if (query[2] == None):
                sum_con = 0

            # Wenn ja, summiere Download, Upload und Connections und speichere in Variable
            elif (query[0] > 0) and (query[1] > 0) and (query[2] > 0):
                sum_dl = float(query[0]) + db_dl_mb
                sum_ul = float(query[1]) + db_ul_mb
                sum_con = float(query[2]) + db_verbindungen

            if (db_dl_mb > 0) or (db_ul_mb > 0):
                sql = "INSERT INTO snowflake (date_time, connections, download, upload, sum_download, sum_upload, sum_connections) VALUES (%s, %s, %s, %s, %s, %s, %s)"
                val = (datum, db_verbindungen, round(db_dl_mb,4), round(db_ul_mb,4), round(sum_dl,4), round(sum_ul,4), sum_con)
                mycursor.execute(sql, val)
                conn.commit()
                print(datum,"- erfolgreich")

            else:
                print(datum,"- nicht erfolgreich. kein Traffic:",db_verbindungen,"(Verbindungen)",db_dl_mb,"(DL)",db_ul_mb,"(UL)")
    finally:
        conn.close()

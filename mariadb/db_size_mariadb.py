#!/usr/bin/python

# ##
# Mit diesem Skipt werden die Größen der Datenbanken "snowflake" und "homeassistant" ermittelt
# und an die Datenbank "db_size" (stündlich gemäß cronjob) geschrieben
# ##

import mariadb
from datetime import datetime


# Versuche DB-Verbindung herzustellen
try:
    conn = mariadb.connect(
        user="xxxxxxxxxx",
        password="xxxxxxxxxx",
        host="127.0.0.1",
        database="db_size"
    )

# DB-Verbindung konnte nicht hergestellt werden
except mariadb.Error as e:
    print(f"Fehler während der Verbindung zu der MariaDB Plattform: {e}")

# DB-Verbindung hergestellt
else:

    # Prüfe, ob Tabelle vorhanden ist
    try:
        mycursor = conn.cursor()
        mycursor.execute("SELECT * FROM db_size")

    # Tabelle wird erstellt da nicht vorhanden
    except mariadb.Error as e:
        mycursor.execute("CREATE TABLE db_size(date_time DATETIME, size_all FLOAT, homeassistant_size FLOAT, snowflake_size FLOAT)")

    # Tabelle ist vorhanden, fahre fort
    else:

        # Datetime in Variable speichern und als Datetime-Objekt speichern
        datum = datetime.now()

        # First run
        mycursor = conn.cursor()

        # Homeassistant Abfrage
        mycursor.execute("SELECT table_schema,ROUND(SUM(data_length + index_length), 2) 'Size' FROM information_schema.tables WHERE table_schema = 'homeassistant';")
        query = mycursor.fetchone()
        homeassistant = float(query[1])

        # Snowflake Abfrage
        mycursor.execute("SELECT table_schema,ROUND(SUM(data_length + index_length), 2) 'Size' FROM information_schema.tables WHERE table_schema = 'snowflake';")
        query = mycursor.fetchone()
        snowflake = float(query[1])

        # Daten übertragen
        sql = "INSERT INTO db_size (date_time, size_all, homeassistant_size, snowflake_size) VALUES (%s, %s, %s, %s)"
        val = (datum, round(homeassistant+snowflake,2), round(homeassistant,2), round(snowflake,2))
        mycursor.execute(sql, val)
        conn.commit()

    finally:
        conn.close()
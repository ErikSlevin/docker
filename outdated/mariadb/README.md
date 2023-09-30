<p align="center">
<a href="https://docs.linuxserver.io/images/docker-mariadb"><img src="https://mariadb.com/wp-content/uploads/2019/11/mariadb-logo-vert_blue-transparent-300x245.png" width="300" alt="MariaDB"></a><br/>
</p>

# MariaDB
Relationales Open-Source-Datenbankmanagementsystem

## User und Datenbank erstellen

``` sql
sudo docker exec -it mariadb /bin/bash                                              /* Verbindung zum MariaDB Docker */

mysql -u root -p[Passwort]                                                          /* MariaDB Root Passwort */
create database datenbankname;                                                      /* Datenbankname */
show databases;
create user 'Benutzer'@'%' identified by 'Password';                                /* Benutzername und Passwort */   
select user, host, plugin from mysql.user;
grant all privileges on datenbankname.* to 'Benutzer'@'%' identified by 'Passwort'; /* Datenbankname, Benutzername und Passwort */
flush privileges;
show grants for 'Benutzer'@'%';                                                     
```

## Quellen
* [https://docs.linuxserver.io/images/docker-mariadb](https://docs.linuxserver.io/images/docker-mariadb)
* [http://java.xrheingauerx.de/mariadb_datenbank_anlegen_benutzer_berechtigen.html](http://java.xrheingauerx.de/mariadb_datenbank_anlegen_benutzer_berechtigen.html)

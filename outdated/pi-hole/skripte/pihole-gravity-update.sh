#!/bin/bash

# Pihole Ad-Listen aktualisieren
docker exec pihole /bin/bash pihole updateGravity >/var/log/pihole_updateGravity.log $$ exit

exit
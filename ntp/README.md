# NTP-Zeitserver

NTP-Zeitserver für das Heimnetzwerk. 

## Testen

``` shell
ntpdate -q [IP vom Docker]

server 10.13.1.109, stratum 4, offset 0.000642, delay 0.02805
14 Mar 19:21:29 ntpdate[26834]: adjust time server 10.13.13.109 offset 0.000642 sec
```
# Quellen:
* [https://hub.docker.com/r/cturra/ntp](https://hub.docker.com/r/cturra/ntp)
* [https://github.com/cturra/docker-ntp](https://github.com/cturra/docker-ntp)
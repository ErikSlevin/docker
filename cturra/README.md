<p align="center">
<a href="https://hub.docker.com/r/cturra/ntp"><img src="https://camo.githubusercontent.com/f0913a317907e5ac420c62efbd1ea3bbc1cff4d18b47d29d9e8ff6e8ccfaac64/68747470733a2f2f692e696d6775722e636f6d2f7544794e6c566c2e706e67" width="150" alt="cturra"></a><br/>
</p>

# cturra
NTP-Zeitserver für das Heimnetzwerk. 

## Testen

``` shell
ntpdate -q [IP vom Docker-Container]

server 10.13.1.109, stratum 4, offset 0.000642, delay 0.02805
14 Mar 19:21:29 ntpdate[26834]: adjust time server 10.13.13.109 offset 0.000642 sec
```
# Quellen:
* [https://hub.docker.com/r/cturra/ntp](https://hub.docker.com/r/cturra/ntp)
* [https://github.com/cturra/docker-ntp](https://github.com/cturra/docker-ntp)
# tor-docker
## Overview
Tor to provide socks5 tor proxy.
Privoxy to provide forward from http proxy to tor socks5 proxy.
[TODO] Lite Http server to provide acces to you proxy PAC file. 

## Build
```
docker build --no-cache -t sego/tor-docker . 
```

## Push
```
docker push sego/tor-docker 
```

## Run
```
docker run -p 8051:8051 -p 9051:9051 -v /home/pi/design/rpi/torrc.d:/etc/torrc.d sego/tor-docker
```

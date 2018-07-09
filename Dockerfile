FROM multiarch/alpine:armhf-v3.8

RUN \
   apk update && \
   apk upgrade && \
   apk add tor && \
   sed "1s/^/SocksPort 0.0.0.0:9050\n/" /etc/tor/torrc.sample > /etc/tor/torrc

EXPOSE 9050

USER tor

ENTRYPOINT ["/usr/bin/tor"]

#ARG architecture=arm
#FROM multiarch/alpine:${architecture}-v3.9
FROM alpine

RUN \
   apk update && \
   apk upgrade && \
   apk add tor && \
#   apk add obfs4proxy && \ edge testing
   apk add privoxy && \
#   apk add s6-overlay && \  edge comunity
   sed '$aSocksPort 0.0.0.0:9051\nClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy\n%include /etc/torrc.d/*.conf\n' /etc/tor/torrc.sample > /etc/tor/torrc

# Install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v3.1.0.1/s6-overlay-noarch.tar.xz \
    https://github.com/just-containers/s6-overlay/releases/download/v3.1.0.1/s6-overlay-armhf.tar.xz \
    /tmp/
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && tar -C / -Jxpf /tmp/s6-overlay-armhf.tar.xz

COPY fs/ /

VOLUME ["/etc/torrc.d"]

EXPOSE 9051
EXPOSE 8051

ENTRYPOINT ["/init"]

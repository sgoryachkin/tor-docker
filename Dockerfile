#ARG architecture=arm
#FROM multiarch/alpine:${architecture}-v3.9
FROM alpine

# Install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v3.1.0.1/s6-overlay-noarch.tar.xz \
    https://github.com/just-containers/s6-overlay/releases/download/v3.1.0.1/s6-overlay-armhf.tar.xz \
    /tmp/
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && tar -C / -Jxpf /tmp/s6-overlay-armhf.tar.xz

RUN \
   apk update && \
   apk upgrade && \
   apk add tor && \
#   apk add obfs4proxy && \ edge testing
   apk add privoxy && \
#   apk add s6-overlay && \  edge comunity
   \
   sed '$aSocksPort 0.0.0.0:9051\nClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy\n%include /etc/torrc.d/*.conf\n' /etc/tor/torrc.sample > /etc/tor/torrc && \
   echo "----- Result /etc/tor/torrc ------" && cat /etc/tor/torrc | egrep -v "(^#.*|^$)" && \
   \
   sed '$apermit-access 127.0.0.0/8\npermit-access 192.168.0.0/16\nforward-socks5t / 127.0.0.1:9051 .\nforward 192.168.*.*/ .\n' /etc/privoxy/config.new \
   | sed '/listen-address / s/127.0.0.1:8118/:8051/' \
   | sed '/actionsfile/d' \
   | sed '/filterfile/d' \
   > /etc/privoxy/config && \
   echo "--- Result /etc/privoxy/config ---" && cat /etc/privoxy/config | egrep -v "(^#.*|^$)"

COPY fs/ /

VOLUME ["/etc/torrc.d"]

EXPOSE 9051
EXPOSE 8051

ENTRYPOINT ["/init"]

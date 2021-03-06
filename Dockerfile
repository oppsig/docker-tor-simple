FROM alpine:edge

ARG BUILD_DATE
ARG VCS_REF
ARG TORHASH="#HashedControlPassword <insert password here>"

LABEL maintainer="oc@co.ru" \
    com.microscaling.license="MIT" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="Tor network client" \
    org.label-schema.url="https://www.torproject.org" \
    org.label-schema.vcs-url="https://github.com/oppsig/tor.git" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.docker.cmd="docker run -d --rm --publish 127.0.0.1:9050:9050 --name tor oppsig/tor" \
    org.label-schema.schema-version="1.0"

RUN apk add --no-cache tor && \
    sed "1s/^/SocksPort 0.0.0.0:9050\n/" /etc/tor/torrc.sample > /etc/tor/torrc
RUN sed -i -e "\$aControlPort 9051" /etc/tor/torrc && \
    sed -i -e "\$aExitNodes {NO},{SE},{DK},{FI},{NL}" /etc/tor/torrc && \
    sed -i -e "\$a$TORHASH" /etc/tor/torrc

EXPOSE 9050

VOLUME ["/var/lib/tor"]

USER tor

CMD ["/usr/bin/tor"]

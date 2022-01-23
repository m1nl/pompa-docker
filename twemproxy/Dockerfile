FROM alpine:latest as builder

ARG TWEMPROXY_VERSION=0.4.1
ENV TWEMPROXY_URL https://github.com/twitter/twemproxy/archive/v${TWEMPROXY_VERSION}.tar.gz

RUN apk --update --no-cache add \
  alpine-sdk \
  autoconf \
  automake \
  curl \
  libtool

RUN set -eux; \
  curl -L "$TWEMPROXY_URL" | tar xzf - ; \
  TWEMPROXY_DIR=$(find / -maxdepth 1 -iname "twemproxy*" | sort | tail -1) ; \
  cd $TWEMPROXY_DIR ; \
  autoreconf -fvi ; \
  CFLAGS="-O3 -fno-strict-aliasing" ./configure ; \
  make ; \
  make install

FROM alpine:latest

ENV LISTEN_ADDR="0.0.0.0" \
    LISTEN_PORT="6380" \
    HASH="fnv1a_64" \
    DISTRIBUTION="ketama" \
    TIMEOUT="2000" \
    PRECONNECT="true" \
    REDIS="true" \
    REDIS_DB="0" \
    SERVER_CONNECTIONS="10" \
    SERVER_RETRY_TIMEOUT="5000" \
    SERVER_FAILURE_LIMIT="1" \
    SERVERS="127.0.0.1:6378:1,127.0.0.1:6379:1" \
    AUTO_EJECT_HOSTS="true" \
    VERBOSE="5"

RUN apk --no-cache --update add \
  dumb-init

COPY --from=builder /usr/local/sbin/nutcracker /usr/local/sbin/nutcracker
COPY docker-entrypoint.sh /usr/local/sbin/

ENTRYPOINT [ "dumb-init", "--rewrite", "15:2", "--", "docker-entrypoint.sh" ]

EXPOSE $LISTEN_PORT
CMD [ "sh", "-c", "nutcracker -c /etc/nutcracker.conf -v $VERBOSE" ]

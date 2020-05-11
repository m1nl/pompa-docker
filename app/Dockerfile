FROM ruby:2.7-alpine

ENV POMPA_USER pompa
ENV POMPA_GROUP pompa
ENV POMPA_HOME /app

RUN set -eux; \
  apk add --update --no-cache \
    libxml2 \
    libxslt \
    libsodium \
    postgresql-libs \
    supervisor \
    su-exec \
    tzdata; \
  rm -rf /usr/share/info/*; \
  rm -rf /usr/share/man/*; \
  rm -rf /usr/share/doc/*

RUN set -eux; \
  addgroup -S -g 500 $POMPA_GROUP; \
  adduser -S -h $POMPA_HOME -H -D -G $POMPA_GROUP -u 500 $POMPA_USER; \
  mkdir -p $POMPA_HOME

WORKDIR $POMPA_HOME

COPY pompa-api/Gemfile ./
COPY pompa-api/Gemfile.lock ./

ENV BUNDLE_JOBS=4
ENV BUNDLE_RETRY=3

ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true

RUN set -eux; \
  gem update --system; \
  gem install bundler rake; \
  bundle config --global frozen 1; \
  bundle config --global set without 'development test'

RUN set -eux; \
  apk add --update --no-cache \
    build-base \
    libxml2-dev \
    libxslt-dev \
    libsodium-dev \
    postgresql-dev; \
  bundle install; \
  apk del --no-cache \
    build-base \
    libxml2-dev \
    libxslt-dev \
    libsodium-dev \
    postgresql-dev; \
  rm -rf /usr/share/info/*; \
  rm -rf /usr/share/man/*; \
  rm -rf /usr/share/doc/*; \
  rm -rf /var/tmp/*; \
  rm -rf /tmp/*; \
  find /var/log -type f -regex '.*\.\([0-9]\|gz\)$' -print0 | xargs -0 rm -f; \
  find /var/log -type f -exec truncate -s 0 {} \;

COPY pompa-api/ ./
COPY config/ ./config/

RUN ./genrevision.sh

RUN set -eux; \
  mkdir -p $POMPA_HOME/tmp/shared; \
  chown $POMPA_USER:$POMPA_GROUP -R $POMPA_HOME

ENV SHARED_TMPDIR=$POMPA_HOME/tmp/shared

VOLUME /app/storage
VOLUME /app/tmp/shared

RUN mkdir -p /usr/local/wrappers
COPY wrapper.sh /usr/local/wrappers/.wrapper.sh

RUN set -eux; \
  for i in /usr/local/bundle/bin/*; \
    do ln -s /usr/local/wrappers/.wrapper.sh /usr/local/wrappers/`basename $i`; \
  done
ENV PATH="/usr/local/wrappers:$PATH"

COPY supervisord.conf /etc/supervisord.conf
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY docker-readiness.sh /usr/local/bin/docker-readiness.sh
COPY docker-liveness.sh /usr/local/bin/docker-liveness.sh

ENTRYPOINT ["docker-entrypoint.sh"]

ARG RUBY_VERSION=3.2

FROM ruby:${RUBY_VERSION}-alpine3.18

ENV POMPA_USER pompa
ENV POMPA_GROUP pompa
ENV POMPA_HOME /app

ARG RUBY_VERSION
ENV RUBY_VERSION $RUBY_VERSION

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

ENV BUNDLE_DISABLE_SHARED_GEMS=1
ENV BUNDLE_WITHOUT="development test"
ENV BUNDLE_PATH="/app/vendor/bundle"

ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true

RUN set -eux; \
  echo "gem: --no-document" > .gemrc; \
  gem update --system; \
  gem install bundler

RUN set -eux; \
  apk add --update --no-cache \
    build-base \
    libxml2-dev \
    libxslt-dev \
    libsodium-dev \
    postgresql-dev; \
  bundle config set deployment true; \
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
  mkdir -p $POMPA_HOME/tmp/shared $POMPA_HOME/storage; \
  chown $POMPA_USER:$POMPA_GROUP -R $POMPA_HOME/tmp $POMPA_HOME/storage $POMPA_HOME/log

ENV SHARED_TMPDIR=$POMPA_HOME/tmp/shared

VOLUME $POMPA_HOME/storage
VOLUME $POMPA_HOME/tmp/shared

RUN mkdir -p /usr/local/wrappers
COPY wrapper.sh /usr/local/wrappers/.wrapper.sh

RUN set -eux; \
  for i in rake puma pumactl rails sidekiq sidekiqmon; \
    do ln -s /usr/local/wrappers/.wrapper.sh /usr/local/wrappers/`basename $i`; \
  done

COPY supervisord.conf /etc/supervisord.conf
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY docker-readiness.sh /usr/local/bin/docker-readiness.sh
COPY docker-liveness.sh /usr/local/bin/docker-liveness.sh

ENTRYPOINT ["docker-entrypoint.sh"]

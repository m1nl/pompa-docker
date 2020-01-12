FROM ruby:2.6-alpine

ENV POMPA_USER pompa
ENV POMPA_GROUP pompa
ENV POMPA_HOME /usr/src/app

RUN apk add --update --no-cache build-base libxml2-dev libxslt-dev libsodium-dev postgresql-dev supervisor su-exec tzdata
RUN addgroup $POMPA_GROUP && adduser -h $POMPA_HOME -H -D -S -G $POMPA_GROUP $POMPA_USER

RUN mkdir -p $POMPA_HOME

WORKDIR $POMPA_HOME

COPY pompa-api/Gemfile ./
COPY pompa-api/Gemfile.lock ./

ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true

RUN gem update --system
RUN gem install bundler

RUN bundle config --global frozen 1
RUN bundle config --global set without 'development test'
RUN bundle install

RUN apk del --no-cache build-base && \
  rm -rf /usr/share/info/* && \
  rm -rf /usr/share/man/* && \
  rm -rf /usr/share/doc/* && \
  rm -rf /var/tmp/* && \
  rm -rf /tmp/* && \
  find /var/log -type f -regex '.*\.\([0-9]\|gz\)$' -print0 | xargs -0 rm -f && \
  find /var/log -type f -exec truncate -s 0 {} \;

COPY pompa-api/ ./
COPY config/ ./config/

RUN ./genrevision.sh

RUN for i in public private log tmp ; do chown $POMPA_USER:$POMPA_GROUP -R $POMPA_HOME/$i ; done

COPY supervisord.conf /etc/supervisord.conf
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

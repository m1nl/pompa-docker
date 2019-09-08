FROM ruby:2-alpine

RUN apk add --update --no-cache build-base libxml2-dev libxslt-dev libsodium-dev postgresql-dev supervisor su-exec tzdata
RUN addgroup pompa && adduser -h /usr/src/app -H -D -S -G pompa pompa

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY pompa-api/Gemfile ./
COPY pompa-api/Gemfile.lock ./

ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true

RUN echo "gem: --no-document" >> ~/.gemrc
RUN gem update --system
RUN gem install bundler
RUN bundle config --global frozen 1
RUN bundle install --without development test

COPY pompa-api/ ./
COPY config/ ./config/

RUN ./genrevision.sh

COPY supervisord.conf /etc/supervisord.conf
COPY run-container.sh /etc/run-container.sh

RUN chmod o=rwx,g=rx,u=rx /etc/run-container.sh
RUN chown pompa:pompa -R /usr/src/app

CMD ["/etc/run-container.sh"]

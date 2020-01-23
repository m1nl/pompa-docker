FROM node:dubnium AS pompa-build

WORKDIR /usr/src/app
ENV PATH=/usr/src/app/bin:$PATH

RUN npm install -g npm@latest
RUN npm install -g ember-cli

COPY pompa/package*.json ./
RUN npm ci

COPY pompa/ ./
COPY config/ ./config/

RUN ember build --environment=production

FROM nginx:mainline-alpine

RUN apk add --update --no-cache \
  gomplate

COPY --from=pompa-build /usr/src/app/dist/ /var/www/pompa/

RUN rm -rf /var/www/default/*
COPY public_root/ /var/www/default/

COPY nginx/ /etc/nginx/

RUN mkdir -p /etc/nginx/private
RUN chmod u=rwx,g=,o= /etc/nginx/private && chown nginx:nginx /etc/nginx/private

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

CMD ["/usr/local/bin/docker-entrypoint.sh"]

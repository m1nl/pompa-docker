# 2048 SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8 github.com (RSA)
ARG GITHUB_KNOWN_HOSTS="github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="

FROM node:erbium AS pompa-build

ARG GITHUB_KNOWN_HOSTS

RUN npm install -g ember-cli

USER builder

RUN set -eux ; \
  mkdir -p /builder/.ssh ; \
  echo "${GITHUB_KNOWN_HOSTS}" > /root/.ssh/known_hosts

ENV PATH=/builder/bin:$PATH

COPY --chown=builder pompa/package*.json ./
COPY --chown=builder pompa/patches ./patches
RUN npm ci --no-audit

COPY --chown=builder pompa/ ./
COPY --chown=builder config/ ./config/

RUN ember build --environment=production

FROM nginx:mainline-alpine

RUN apk add --update --no-cache \
  gomplate

COPY --from=pompa-build /builder/dist/ /var/www/pompa-admin/

RUN rm -rf /var/www/default

RUN set -eux; \
  mkdir /var/www/pompa-tmp; \
  chmod u=rwx,g=rx,o=rx /var/www/pompa-tmp; \
  chown 500:500 /var/www/pompa-tmp

VOLUME /var/www/pompa-tmp

COPY error-pages/ /var/www/error-pages/

COPY pompa-admin/ /var/www/pompa-admin/
COPY pompa-public/ /var/www/pompa-public/

COPY nginx/ /etc/nginx/

RUN mkdir -p /etc/nginx/private
RUN set -eux; \
  chmod u=rwx,g=,o= /etc/nginx/private; \
  chown nginx:nginx /etc/nginx/private

VOLUME /etc/nginx/private

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

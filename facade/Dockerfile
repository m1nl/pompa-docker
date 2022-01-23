# 2048 SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8 github.com (RSA)
ARG GITHUB_KNOWN_HOSTS="github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="

FROM node:gallium-buster-slim AS pompa-build

ARG GITHUB_KNOWN_HOSTS

RUN set -eux; \
  apt-get update; \
  apt-get install -y git curl bash wget adduser; \
  apt-get -y --purge autoremove; \
  apt-get -y clean; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /usr/share/man/*; \
  rm -rf /usr/share/doc/*; \
  rm -rf /var/tmp/*; \
  rm -rf /tmp/*; \
  find /var/log -type f -regex '.*\.\([0-9]\|gz\)$' -print0 | xargs -0 rm -f; \
  find /var/log -type f -print0 | xargs -0 truncate -s 0

RUN set -eux; \
  npm -g install npm@latest; \
  npm -g cache clean --force; \
  npm install -g ember-cli

RUN set -eux; \
  addgroup --system --gid 500 builder; \
  adduser --system --home /builder --no-create-home --gid 500 --uid 500 builder; \
  mkdir -p /builder /builder/bin; \
  chown builder:builder -R /builder

WORKDIR /builder

USER builder

ENV PATH=/builder/bin:$PATH

RUN set -eux ; \
  mkdir -p /builder/.ssh ; \
  echo "${GITHUB_KNOWN_HOSTS}" > /builder/.ssh/known_hosts

COPY --chown=builder pompa/package*.json ./

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

RUN set -eux; \
  mkdir -p /spool/nginx/proxy-temp; \
  mkdir -p /etc/nginx/private; \
  chmod u=rwx,g=,o= /spool/nginx/proxy-temp; \
  chown nginx:nginx /spool/nginx/proxy-temp; \
  chmod u=rwx,g=,o= /etc/nginx/private; \
  chown nginx:nginx /etc/nginx/private

VOLUME /spool/nginx/proxy-temp
VOLUME /etc/nginx/private

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

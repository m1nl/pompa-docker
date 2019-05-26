FROM node:dubnium AS pompa-build

WORKDIR /usr/src/app
ENV PATH=/usr/src/app/bin:$PATH

RUN npm install -g npm@latest
RUN npm install -g ember-cli

COPY pompa/package*.json ./
RUN npm install

COPY pompa/ ./
COPY config/ ./config/

RUN ember build --environment=production

FROM nginx:alpine

COPY --from=pompa-build /usr/src/app/dist/ /var/www/pompa/

RUN rm -rf /var/www/default/*
COPY public_root/ /var/www/default/

COPY nginx/ /etc/nginx/

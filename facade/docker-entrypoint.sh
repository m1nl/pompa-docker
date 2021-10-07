#!/bin/sh

set -e

ln -s /proc/$$/fd/1 /dev/docker-stdout
ln -s /proc/$$/fd/2 /dev/docker-stderr

GOMPLATE="/usr/bin/gomplate"
NGINX="/usr/sbin/nginx"

NGINX_CONF="/etc/nginx/nginx.conf"
NGINX_CONF_TEMPLATE="/etc/nginx/nginx.conf.template"

export POMPA_ADMIN_ENABLE="${POMPA_ADMIN_ENABLE:-true}"
export POMPA_ADMIN_HOSTNAME="${POMPA_ADMIN_HOSTNAME:-_}"
export POMPA_ADMIN_ENDPOINT="${POMPA_ADMIN_ENDPOINT:-app:3000}"
export POMPA_ADMIN_ENDPOINT_PREFIX="${POMPA_ADMIN_ENDPOINT_PREFIX:-/api}"

export POMPA_PUBLIC_ENABLE="${POMPA_PUBLIC_ENABLE:-true}"
export POMPA_PUBLIC_ENDPOINT="${POMPA_PUBLIC_ENDPOINT:-app:3000}"
export POMPA_PUBLIC_ENDPOINT_PREFIX="${POMPA_PUBLIC_ENDPOINT_PREFIX:-/api}"
export POMPA_PUBLIC_ENDPOINT_CACHE_SIZE="${POMPA_PUBLIC_CACHE_SIZE:-1g}"

export POMPA_SENDFILE_ENABLE="${POMPA_SENDFILE_ENABLE:-true}"
export POMPA_SENDFILE_MAPPING="${POMPA_SENDFILE_MAPPING:-/app/tmp/shared}"

[ -f $NGINX_CONF_TEMPLATE ] && $GOMPLATE -f "$NGINX_CONF_TEMPLATE" -o "$NGINX_CONF"

$NGINX -g "daemon off;"

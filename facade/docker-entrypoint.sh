#!/bin/sh

set -e

ln -s /proc/$$/fd/1 /dev/docker-stdout
ln -s /proc/$$/fd/2 /dev/docker-stderr

GOMPLATE="/usr/bin/gomplate"
NGINX="/usr/sbin/nginx"

NGINX_CONF="/etc/nginx/nginx.conf"
NGINX_CONF_TEMPLATE="/etc/nginx/nginx.conf.template"

export POMPA_ADMIN_ENABLE="${POMPA_ADMIN_ENABLE:-true}"
export POMPA_ADMIN_HOST="${POMPA_ADMIN_HOST:-localhost}"
export POMPA_ADMIN_API="${POMPA_ADMIN_API:-app:3000}"
export POMPA_ADMIN_API_PREFIX="${POMPA_ADMIN_API_PREFIX:-/api}"

export POMPA_PUBLIC_ENABLE="${POMPA_PUBLIC_ENABLE:-true}"
export POMPA_PUBLIC_API="${POMPA_PUBLIC_API:-app:3000}"
export POMPA_PUBLIC_API_PREFIX="${POMPA_PUBLIC_API_PREFIX:-/api}"

export POMPA_SENDFILE_ENABLE="${POMPA_SENDFILE_ENABLE:-true}"
export POMPA_SENDFILE_MAPPING="${POMPA_SENDFILE_MAPPING:-/app/tmp/shared}"

[ -f $NGINX_CONF_TEMPLATE ] && $GOMPLATE -f "$NGINX_CONF_TEMPLATE" -o "$NGINX_CONF"

$NGINX -g "daemon off;"

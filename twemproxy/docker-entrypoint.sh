#!/bin/sh

set -e
CONFIG_PATH=/etc/nutcracker.conf

generate_config() {
  cat > $CONFIG_PATH <<EOF
pool:
  listen: ${LISTEN_ADDR}:${LISTEN_PORT}
  hash: ${HASH}
  distribution: ${DISTRIBUTION}
  timeout: ${TIMEOUT}
  preconnect: ${PRECONNECT}
  redis: ${REDIS}
  redis_db: ${REDIS_DB}
  server_connections: ${SERVER_CONNECTIONS}
  server_retry_timeout: ${SERVER_RETRY_TIMEOUT}
  server_failure_limit: ${SERVER_FAILURE_LIMIT}
  auto_eject_hosts: ${AUTO_EJECT_HOSTS}
  servers:
EOF

  IFS=,
  for server in $SERVERS; do
    echo "   - ${server}" >> $CONFIG_PATH
  done
}


if [ ! -e "$CONFIG_PATH" ]; then
  generate_config
fi

exec "$@"

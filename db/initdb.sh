#!/bin/bash

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  CREATE USER $POMPA_DB_USERNAME WITH PASSWORD '`cat /run/secrets/pompa_db_password`';
  CREATE DATABASE $POMPA_DB OWNER $POMPA_DB_USERNAME;
  \c $POMPA_DB
  CREATE EXTENSION citext;
  CREATE EXTENSION pg_trgm;
  CREATE EXTENSION tablefunc;
EOSQL

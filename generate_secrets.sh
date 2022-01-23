#!/bin/sh

rand() {
  od -vN "$1" -An -tx1 /dev/urandom | tr -d " \n"
}

[ -d .secrets ] || mkdir .secrets
chmod 0700 .secrets

[ -f .secrets/pompa_db_password ] || rand 16 > .secrets/pompa_db_password
[ -f .secrets/postgres_db_password ] || rand 16 > .secrets/postgres_db_password

[ -f .secrets/secret_key_base ] || rand 64 > .secrets/secret_key_base

[ -f .secrets/active_record_primary_key ] || rand 32 > .secrets/active_record_primary_key
[ -f .secrets/active_record_deterministic_key ] || rand 32 > .secrets/active_record_deterministic_key
[ -f .secrets/active_record_key_derivation_salt ] || rand 32 > .secrets/active_record_key_derivation_salt

#!/bin/sh

set -e

SUPERVISORCTL="/usr/bin/supervisorctl"

SUPERVISORCTLOPTS="-u dummy -p dummy"

NUM_FATAL=`( $SUPERVISORCTL $SUPERVISORCTLOPTS status | grep -c FATAL ) || true`

[ $NUM_FATAL -gt 0 ] && exit 1

exit 0

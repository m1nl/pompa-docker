#!/bin/sh

set -e

SUPERVISORCTL="/usr/bin/supervisorctl"

SUPERVISORCTLOPTS="-u dummy -p dummy"

COMPONENTS="${COMPONENTS:-puma sidekiq model-sync}"

for i in $COMPONENTS ; do 
  RUNNING=`( $SUPERVISORCTL $SUPERVISORCTLOPTS status $i | grep -c RUNNING ) || true`

  [ $RUNNING -ne 1 ] && exit 1
done

exit 0

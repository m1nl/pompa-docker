#!/bin/sh

set -e

ln -s /proc/$$/fd/1 /dev/docker-stdout
ln -s /proc/$$/fd/2 /dev/docker-stderr

SUPERVISORCTL="/usr/bin/supervisorctl"
SUPERVISORD="/usr/bin/supervisord"
SUEXEC="/sbin/su-exec"

SUPERVISORCTLOPTS="-u dummy -p dummy"
SUPERVISORDOPTS="-c /etc/supervisord.conf"
SUPERVISORDPID="/var/run/supervisord.pid"

MANAGE_DB="${MANAGE_DB:-true}"
COMPONENTS="${COMPONENTS:-puma sidekiq model-sync}"

reload() {
  SIDEKIQ_PID="`$SUPERVISORCTL $SUPERVISORCTLOPTS pid sidekiq`"
  [ "x$SIDEKIQ_PID" != "$SIDEKIQ_PID" ] && kill -TSTP $SIDEKIQ_PID

  $SUPERVISORCTL $SUPERVISORCTLOPTS reload
}

shutdown() {
  SIDEKIQ_PID="`$SUPERVISORCTL $SUPERVISORCTLOPTS pid sidekiq`"
  [ "x$SIDEKIQ_PID" != "$SIDEKIQ_PID" ] && kill -TSTP $SIDEKIQ_PID

  $SUPERVISORCTL $SUPERVISORCTLOPTS shutdown
}

if [ "$MANAGE_DB" == "true" ] ; then
  $SUEXEC $POMPA_USER:$POMPA_GROUP bundle exec rake db:migrate
fi

$SUEXEC $POMPA_USER:$POMPA_GROUP bundle exec rake db:abort_if_pending_migrations
$SUEXEC $POMPA_USER:$POMPA_GROUP bundle exec rake pompa:clear_cache
$SUEXEC $POMPA_USER:$POMPA_GROUP rm -rf tmp/cache/* > /dev/null 2>&1

trap reload 1
trap shutdown 2 15

$SUPERVISORD $SUPERVISORDOPTS

sleep 1 && kill -0 `cat $SUPERVISORDPID`

for i in $COMPONENTS ; do
  echo "[docker-entrypoint] $i: starting"
  $SUPERVISORCTL $SUPERVISORCTLOPTS start $i &
  sleep 1
done

EXITCODE=0

while (kill -0 `cat $SUPERVISORDPID 2> /dev/null` > /dev/null 2>&1) ; do
  sleep 5

  NUM_FATAL=`( $SUPERVISORCTL $SUPERVISORCTLOPTS status | grep -c FATAL ) || true`
  if [ $NUM_FATAL -gt 0 ] ; then
    echo "[docker-entrypoint] at least one required component stuck in FATAL state - exiting."
    EXITCODE=1
    shutdown
  fi
done

exit $EXITCODE

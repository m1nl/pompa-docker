#!/bin/sh
  
set -eu

ln -s /proc/$$/fd/1 /dev/docker-stdout
ln -s /proc/$$/fd/2 /dev/docker-stderr

SUPERVISORCTL="/usr/bin/supervisorctl"
SUPERVISORD="/usr/bin/supervisord"
SUEXEC="/sbin/su-exec"

SUPERVISORCTLOPTS="-u dummy -p dummy"
SUPERVISORDOPTS="-c /etc/supervisord.conf"

$SUEXEC pompa bundle exec rake db:migrate

reload() {
  SIDEKIQ_PID="`cat tmp/pids/sidekiq.pid 2> /dev/null`"
  [ "x$SIDEKIQ_PID" != "$SIDEKIQ_PID" ] && kill -TSTP $SIDEKIQ_PID

  $SUPERVISORCTL $SUPERVISORCTLOPTS reload
}

shutdown() {
  SIDEKIQ_PID="`cat tmp/pids/sidekiq.pid 2> /dev/null`"
  [ "x$SIDEKIQ_PID" != "$SIDEKIQ_PID" ] && kill -TSTP $SIDEKIQ_PID

  $SUPERVISORCTL $SUPERVISORCTLOPTS shutdown
}

trap reload 1
trap shutdown 2 15

$SUPERVISORD $SUPERVISORDOPTS

while (kill -0 `cat /var/run/supervisord.pid 2> /dev/null` > /dev/null 2>&1) ; do
  sleep 5
done

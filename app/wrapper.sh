#!/bin/sh

SUEXEC="/sbin/su-exec"
SCRIPT="`basename \"$0\"`"
GEMFILE="$POMPA_HOME/Gemfile"

$SUEXEC $POMPA_USER bundle exec --gemfile "$GEMFILE" "$SCRIPT" "$@"

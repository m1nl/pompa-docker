#!/bin/sh

SUEXEC="/sbin/su-exec"
SCRIPT="`basename \"$0\"`"
BUNDLE_DIR="/usr/local/bundle/bin"

$SUEXEC $POMPA_USER:$POMPA_GROUP "$BUNDLE_DIR/$SCRIPT" "$@"

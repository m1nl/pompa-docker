#!/bin/sh

SUEXEC="/sbin/su-exec"
SCRIPT="`basename \"$0\"`"
BUNDLE_DIR="/app/vendor/bundle/ruby/$RUBY_ABI_VERSION/bin"

$SUEXEC $POMPA_USER:$POMPA_GROUP "$BUNDLE_DIR/$SCRIPT" "$@"

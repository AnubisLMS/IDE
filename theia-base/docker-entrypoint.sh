#!/usr/bin/env sh

if [ "$ANUBIS_SHELL_AUTOGRADE" != "" ]; then
    export IDE_SHELL=/usr/local/bin/jbash
else
    export IDE_SHELL=$SHELL
fi

if (( $# >= 1 )); then
    exec $@
fi

exec /usr/local/bin/supervisord --nodaemon -c /supervisord.conf

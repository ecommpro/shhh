# shhh

Here's the code. That's all:

    #!/bin/sh
    [ -z "$VALUE" ] && [ ! -t 0 ] && VALUE=$(cat -)
    : "${SHHH_ROOT:=$HOME/.shhh}" "${LENGTH:=24}" "${CHARS:=[A-Z][a-z][0-9]_\-\$:\!\(\)\.}" ${SHHH_FILE:=$SHHH_ROOT/$1.shhh}
    CONTENT=${VALUE:-$(< /dev/urandom tr -dc $CHARS | head -c$LENGTH)}
    [ -f $SHHH_FILE ] && [ -z "$RESET" ] || ( >&2 echo 🤫 $SHHH_FILE && umask 0077 && mkdir -p "${SHHH_FILE%/*}" && umask 0177 && echo $CONTENT > $SHHH_FILE )
    [ -z "$VALUE" ] && cat $SHHH_FILE

Really? Do we need a GitHub repo for this? 🤷


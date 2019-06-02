# shhh

Here's the code. That's all:

    #!/bin/sh
    [ -z "$VALUE" ] && [ ! -t 0 ] && VALUE=$(cat -)
    : "${SHHH_ROOT:=$HOME/.shhh}" "${LENGTH:=24}" "${CHARS:=[A-Z][a-z][0-9]_\-\$:\!\(\)\.}" ${SHHH_FILE:=$SHHH_ROOT/$1.shhh}
    CONTENT=${VALUE:-$(< /dev/urandom tr -dc $CHARS | head -c$LENGTH)}
    [ -f $SHHH_FILE ] && [ -z "$RESET" ] || ( >&2 echo 🤫 $SHHH_FILE && umask 0077 && mkdir -p "${SHHH_FILE%/*}" && umask 0177 && printf '%s' "$CONTENT" > $SHHH_FILE )
    [ -z "$VALUE" ] && cat $SHHH_FILE

Really? Do we need a GitHub repo for this? 🤷


# Installation

**User space**, assuming you have a `~/.local/bin` folder in `$PATH`:

    TO=~/.local/bin && (mkdir -p $TO && wget -O $TO/shhh https://raw.githubusercontent.com/ecommpro/shhh/master/shhh && chmod +x $TO/shhh)

**Global**, assuming `/usr/local/bin` is in your `$PATH`:

    TO=/usr/local/bin && sudo sh -c "wget -O $TO/shhh https://raw.githubusercontent.com/ecommpro/shhh/master/shhh && chmod +x $TO/shhh"


# Use

    ➜  shhh-playground shhh mysq/project1
    🤫 /home/manel/.shhh/mysq/project1.shhh
    R1FPZ)T514Ud3NE9Mq:jJJzz

    ➜  shhh-playground shhh mysq/project1
    R1FPZ)T514Ud3NE9Mq:jJJzz
    
    ➜  shhh-playground shhh mysq/project2
    🤫 /home/manel/.shhh/mysq/project2.shhh
    aNqL6d[-1rA][okW$UmNv!qe
    
    ➜  shhh-playground shhh mysq/project2
    aNqL6d[-1rA][okW$UmNv!qe
    
    ➜  shhh-playground shhh some.service.that.requires.a.password
    🤫 /home/manel/.shhh/some.service.that.requires.a.password.shhh
    P3heq6zU)4swts[Wf9z.FXZe
    
    ➜  shhh-playground shhh some.service.that.requires.a.password
    P3heq6zU)4swts[Wf9z.FXZe
    
    ➜  shhh-playground RESET=1 shhh some.service.that.requires.a.password
    🤫 /home/manel/.shhh/some.service.that.requires.a.password.shhh
    cDBFO6LD3x!3]T(7Vu$o:yw9
    
    ➜  shhh-playground CHARS=abc LENGTH=9 shhh my/dummy/password
    🤫 /home/manel/.shhh/my/dummy/password.shhh
    acaccaabc
    
    ➜  shhh-playground CHARS=abc LENGTH=9 shhh my/dummy/password
    acaccaabc
    
    ➜  shhh-playground shhh my/dummy/password 
    acaccaabc

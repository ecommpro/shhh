# shhh 🤫

Here's the code. That's all:

    #!/bin/sh
    [ -z "$SHHH_VALUE" ] && [ ! -t 0 ] && SHHH_VALUE=$(cat -)
    : "${SHHH_ROOT:=$HOME/.shhh}" "${SHHH_LENGTH:=24}" "${SHHH_CHARS:=[A-Z][a-z][0-9]_\-\$:\!\(\)\.}" ${SHHH_FILE:=$SHHH_ROOT/$1.shhh}
    SHHH_CONTENT=${SHHH_VALUE:-$(< /dev/urandom tr -dc $SHHH_CHARS | head -c$SHHH_LENGTH)}
    [ -f $SHHH_FILE ] && [ -z "$SHHH_RESET" ] || ( >&2 echo 🤫 $SHHH_FILE && umask 0077 && mkdir -p "${SHHH_FILE%/*}" && umask 0177 && printf '%s' "$SHHH_CONTENT" > $SHHH_FILE )
    [ -z "$SHHH_VALUE" ] && cat $SHHH_FILE

Really? Do we need a GitHub repo for this? 🤷


# Installation

**User space**, assuming you have a `~/.local/bin` folder in `$PATH`:

    TO=~/.local/bin && (mkdir -p $TO && wget -O $TO/shhh https://raw.githubusercontent.com/ecommpro/shhh/master/shhh && chmod +x $TO/shhh)

**Global**, assuming `/usr/local/bin` is in your `$PATH`:

    TO=/usr/local/bin && sudo sh -c "wget -O $TO/shhh https://raw.githubusercontent.com/ecommpro/shhh/master/shhh && chmod +x $TO/shhh"

# Configuration

Default directory for storing the credentials is `~/.shhh`. You can override this value by setting the variable `$SHHH_ROOT`.

Other variables used by the script:

`SHHH_CHARS`: set of characters used to create the password.

`SHHH_LENGTH`: passord length.

`SHHH_RESET`: ignore the current value and force the creation of a new password.

`SHHH_VALUE`: force a value for the password. `SHHH_VALUE=abc shhh redis/dummy-password`.


# Use

    ➜  shhh mysq/project1
    🤫 /home/manel/.shhh/mysq/project1.shhh
    R1FPZ)T514Ud3NE9Mq:jJJzz

    ➜  shhh mysq/project1
    R1FPZ)T514Ud3NE9Mq:jJJzz
    
    ➜  shhh mysq/project2
    🤫 /home/manel/.shhh/mysq/project2.shhh
    aNqL6d[-1rA][okW$UmNv!qe
    
    ➜  shhh mysq/project2
    aNqL6d[-1rA][okW$UmNv!qe
    
    ➜  shhh some.service.that.requires.a.password
    🤫 /home/manel/.shhh/some.service.that.requires.a.password.shhh
    P3heq6zU)4swts[Wf9z.FXZe
    
    ➜  shhh some.service.that.requires.a.password
    P3heq6zU)4swts[Wf9z.FXZe
    
    ➜  SHHH_RESET=1 shhh some.service.that.requires.a.password
    🤫 /home/manel/.shhh/some.service.that.requires.a.password.shhh
    cDBFO6LD3x!3]T(7Vu$o:yw9
    
    ➜  SHHH_CHARS=abc SHHH_LENGTH=9 shhh my/dummy/password
    🤫 /home/manel/.shhh/my/dummy/password.shhh
    acaccaabc
    
    ➜  SHHH_CHARS=abc SHHH_LENGTH=9 shhh my/dummy/password
    acaccaabc
    
    ➜  shhh my/dummy/password 
    acaccaabc

    ➜  SHHH_VALUE=abc shhh redis/dummy-password
    🤫 /home/manel/.shhh/redis/dummy-password.shhh
    
    ➜  shhh redis/dummy-password 
    abc%                                                             


# Dockerized

We use this tool to create credentials for our dockerized Magento projects:

    services:
    
        # ...

        shhh:
            image: ecommpro/shhh
            volumes:
                - shhh-data:/shhh
            environment:
                - SHHH_ROOT=/shhh
                - "SECRETS=mysql:root mysql:user"

        # ...

        db:
            # ...
            volumes:
                - shhh-data:/shhh
            # ...
            
            environment:
                - MYSQL_DATABASE=app
                - MYSQL_USER=app
                - MYSQL_ROOT_PASSWORD_FILE=/shhh/mysql:root.shhh
                - MYSQL_PASSWORD_FILE=/shhh/mysql:user.shhh
                - "WAIT_FOR_FILES=/shhh/mysql:root.shhh /shhh/mysql:user.shhh"

        php-fpm:
            # ...
            volumes:
                - shhh-data:/shhh
            # ...

        php-cli:
            # ...
            volumes:
                - shhh-data:/shhh
            # ...

    volumes:
        # ...
        shhh-data:
        # ...
        

That way we can make use of the password in a Magento 2 `app/etc/env.php` file without having to see, copy or paste the password.

    <?php
    return [
        // ...
        'db' => [
            'table_prefix' => '',
            'connection' => [
                'default' => [
                    'host' => 'db',
                    'dbname' => 'app',
                    'username' => 'app',
                    'password' => file_get_contents('/shhh/mysql:user.shhh'),
                    'model' => 'mysql4',
                    'engine' => 'innodb',
                    'initStatements' => 'SET NAMES utf8;',
                    'active' => '1'
                ]
            ]
        ],
        // ...
    ];



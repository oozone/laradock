#!/usr/bin/env bash
# see https://carstenwindler.de/php/enable-xdebug-on-demand-in-your-local-docker-environment/

if [ "$#" -ne 1 ]; then
    SCRIPT_PATH=`basename "$0"`
    echo "Usage: $SCRIPT_PATH enable|disable"
    exit 1;
fi

# Workspace container
SERVICE_ID=$(docker-compose ps -q workspace)

if [ "$1" == "enable" ]; then
    docker exec -i $SERVICE_ID bash -c \
        '[ -f /etc/php/8.2/cli/disabled/xdebug.ini ] && cd /etc/php/8.2/cli/ && mv disabled/xdebug.ini conf.d/ || echo "Xdebug enabled"'
else
    docker exec -i $SERVICE_ID bash -c \
        '[ -f /etc/php/8.2/cli/conf.d/xdebug.ini ] && cd /etc/php/8.2/cli/ && mkdir -p disabled/ && mv conf.d/xdebug.ini disabled/ || echo "Xdebug disabled"'
fi

docker restart $SERVICE_ID

docker exec -i $SERVICE_ID bash -c '$(php -m | grep -q Xdebug) && echo "Status: Workspace Xdebug ENABLED" || echo "Status: Workspace Xdebug DISABLED"'


# php-fpm container
SERVICE_ID=$(docker-compose ps -q php-fpm)

if [ "$1" == "enable" ]; then
    docker exec -i $SERVICE_ID bash -c \
        '[ -f /usr/local/etc/php/disabled/xdebug.ini ] && cd /usr/local/etc/php/ && mv disabled/xdebug.ini conf.d/ || echo "Xdebug enabled"'
else
    docker exec -i $SERVICE_ID bash -c \
        '[ -f /usr/local/etc/php/conf.d/xdebug.ini ] && cd /usr/local/etc/php/ && mkdir -p disabled/ && mv conf.d/xdebug.ini disabled/ || echo "Xdebug disabled"'
fi

docker restart $SERVICE_ID

docker exec -i $SERVICE_ID bash -c '$(php -m | grep -q Xdebug) && echo "Status: PHP-FPM Xdebug ENABLED" || echo "Status: PHP-FPM Xdebug DISABLED"'

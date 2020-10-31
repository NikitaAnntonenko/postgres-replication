#!/bin/bash
set -e

if [ -z "$POSTGRES_USER" ] 
then
    echo "POSTGRES_USER Not seted !!!"
    exit 1
fi

if [ -z "$POSTGRES_DB" ] 
then
    echo "POSTGRES_DB Not seted !!!"
    exit 1
fi

if [ -z "$PG_REP_USER" ] 
then
    echo "PG_REP_USER Not seted !!!"
    exit 1
fi

if [ -z "$PG_REP_PASSWORD" ] 
then
    echo "PG_REP_PASSWORD Not seted !!!"
    exit 1
fi

if [ -z "$PG_MASTER_IP" ] 
then
    echo "PG_MASTER_IP Not seted !!!"
    exit 1
fi

if [ -z "$PG_MASTER_PORT" ] 
then
    echo "PG_MASTER_PORT Not seted !!!"
    exit 1
fi

if [ "$FIRST_START" == "true" ]
then
    sh /scripts/init-slave.sh
fi

if [ "$RESTART_AS_SLAVE" == "true" ]
then
    sh /scripts/restore-slave.sh
fi

echo "--->>> Start postgres <<<---"
exec "$@"
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

if [ -z "$POSTGRES_PASSWORD" ] 
then
    echo "POSTGRES_PASSWORD Not seted !!!"
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

if [ -z "$REPLICA_IP" ] 
then
    echo "REPLICA_IP Not seted !!!"
    exit 1
fi

if [ "$RESTORE_MASTER" == "true" ]
then
    sh /scripts/start-recovery.sh
fi

echo "--->>> Start postgres <<<---"
exec "$@"
echo "--->>> Postgres started <<<---"
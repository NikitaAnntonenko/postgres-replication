#!/bin/bash
set -e

echo "1. Creare replica user"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" << EOSQL
CREATE USER $PG_REP_USER WITH REPLICATION LOGIN ENCRYPTED PASSWORD '$PG_REP_PASSWORD';
EOSQL

echo "2. Set replica host for receiving connections from it"
echo "host replication $PG_REP_USER $REPLICA_IP/0 md5" >> "$PGDATA/pg_hba.conf"

echo "3. Create replica slot"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" << EOSQL
SELECT pg_create_physical_replication_slot('replica_slot'); 
EOSQL

echo "4. Set configurations for master"
cat >> ${PGDATA}/postgresql.conf << EOF
# wal_level = replica
wal_log_hints = on # for pg_rewind !!!
# hot_standby = on
logging_collector = on
log_directory = 'pg_log'                    
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
log_statement = 'mod'
EOF
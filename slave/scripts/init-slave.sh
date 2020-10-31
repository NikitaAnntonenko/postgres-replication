#!/bin/bash
set -e

echo "1. Save to .pgpass"
echo "*:*:*:$PG_REP_USER:$PG_REP_PASSWORD" > ~/.pgpass
chmod 0600 ~/.pgpass

echo "2. Ping master host -> $PG_MASTER_IP" 
until ping -c 1 -W 1 ${PG_MASTER_IP}
do
echo "Waiting for master to ping..."
sleep 1s
done

echo "3. Restore all data from $PG_MASTER_IP:$PG_MASTER_PORT postgressql server" 
until pg_basebackup -h host.docker.internal -p ${PG_MASTER_PORT} -D ${PGDATA} -U ${PG_REP_USER} -vP -W
do
echo "Waiting for master to connect..."
sleep 1s
done

echo "4. Set config for replica server"
# touch $PGDATA/standby.signal # for postgres 12 !!!
echo "host replication all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
set -e
# recovery.conf (postgresql.auto.conf) - file for postgres 12 !!!
cat > ${PGDATA}/recovery.conf << EOF
# listen_addresses = '*'
# restore_command = 'cp /var/lib/postgresql/pg_log_archive/main/%f %p'
# recovery_target_timeline = 'latest'
standby_mode = on
primary_conninfo = 'host=host.docker.internal port=$PG_MASTER_PORT user=$PG_REP_USER password=$PG_REP_PASSWORD'
primary_slot_name = 'replica_slot'
EOF

chown postgres. ${PGDATA} -R
chmod 700 ${PGDATA} -R

echo "5. Delete master's logs"
rm -rf $PGDATA/pg_log/

# sed -i 's/wal_level = hot_standby/wal_level = replica/g' ${PGDATA}/postgresql.conf # <<<--- ???

# host.docker.internal
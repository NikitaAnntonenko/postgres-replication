#!/bin/bash
set -e

echo "--->>> Run recovery <<<---"

echo "--->>> 1. Run pg_rewind <<<---"
gosu postgres /usr/lib/postgresql/11/bin/pg_rewind \
  --target-pgdata $PGDATA \
  --source-server="host=host.docker.internal port=5433 user=postgres password=docker" \
  --progress

set +e
rm $PGDATA/recovery.done
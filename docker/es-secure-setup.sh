#!/bin/sh
# Sets the kibana_system password on elasticsearch-secure from KIBANA_SYSTEM_PASSWORD.
set -eu

echo "waiting for elasticsearch-secure..."
until curl -fs -u "elastic:${ES_SECURE_PASSWORD}" http://elasticsearch-secure:9200 >/dev/null 2>&1; do
  sleep 3
done

echo "setting kibana_system password..."
curl -fs -u "elastic:${ES_SECURE_PASSWORD}" -X POST \
  http://elasticsearch-secure:9200/_security/user/kibana_system/_password \
  -H 'Content-Type: application/json' \
  -d "{\"password\":\"${KIBANA_SYSTEM_PASSWORD}\"}"

echo "kibana_system password set from KIBANA_SYSTEM_PASSWORD"

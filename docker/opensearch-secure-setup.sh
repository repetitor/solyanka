#!/usr/bin/env bash
# Sets the kibanaserver password from KIBANASERVER_PASSWORD via securityadmin
# (kibanaserver is reserved, so the REST API can't set it).
set -euo pipefail
cd /usr/share/opensearch

echo "waiting for opensearch-secure..."
until curl -sk -u "admin:${OPENSEARCH_SECURE_PASSWORD}" https://opensearch-secure:9200 >/dev/null 2>&1; do
  sleep 3
done

echo "generating bcrypt hash for kibanaserver..."
HASH="$(bash plugins/opensearch-security/tools/hash.sh -p "${KIBANASERVER_PASSWORD}" | grep '^\$2' | tail -1)"

echo "writing the hash into internal_users.yml..."
awk -v h="$HASH" '
  /^kibanaserver:/ { k = 1 }
  k && /^[[:space:]]*hash:/ { print "  hash: \"" h "\""; k = 0; next }
  { print }
' config/opensearch-security/internal_users.yml > /tmp/iu.yml
mv /tmp/iu.yml config/opensearch-security/internal_users.yml

echo "applying config with securityadmin (admin cert)..."
bash plugins/opensearch-security/tools/securityadmin.sh \
  -f config/opensearch-security/internal_users.yml -t internalusers \
  -icl -nhnv \
  -cacert config/root-ca.pem -cert config/kirk.pem -key config/kirk-key.pem \
  -h opensearch-secure -p 9200

echo "kibanaserver password set from KIBANASERVER_PASSWORD"

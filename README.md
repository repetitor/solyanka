# solyanka — Elasticsearch & OpenSearch playground

Local stack for learning Elasticsearch and OpenSearch, each in an **open** (no auth)
and a **secured** (auth + roles) variant.

## Quick start

```bash
cp .env.example .env
docker compose up -d
```

## Services & ports

| Service | URL | UI login |
|---------|-----|----------|
| Elasticsearch (open) | http://localhost:9202 | none |
| Kibana (open) | http://localhost:5601 | none |
| OpenSearch (open) | http://localhost:9203 | none |
| OpenSearch Dashboards (open) | http://localhost:5602 | none |
| Elasticsearch (secured) | http://localhost:9205 | `elastic` / `ES_SECURE_PASSWORD` |
| Kibana (secured) | http://localhost:5603 | log in as `elastic` |
| OpenSearch (secured) | https://localhost:9204 | `admin` / `OPENSEARCH_SECURE_PASSWORD` |
| OpenSearch Dashboards (secured) | http://localhost:5604 | log in as `admin` |

Ports and passwords come from `.env` (see `.env.example` for defaults).

## Secured passwords

Service-account passwords are set from `.env` by init containers on `docker compose up`:

- `KIBANA_SYSTEM_PASSWORD` — Elasticsearch's `kibana_system` (`docker/es-secure-setup.sh`)
- `KIBANASERVER_PASSWORD` — OpenSearch's `kibanaserver` (`docker/opensearch-secure-setup.sh`)

The superuser passwords (`ES_SECURE_PASSWORD` → `elastic`, `OPENSEARCH_SECURE_PASSWORD`
→ `admin`) are set by the engines themselves at startup.

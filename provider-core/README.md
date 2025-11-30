# Arkeo Provider Core (Docker)

Containerized hot-wallet admin UI + API + sentinel reverse-proxy for Arkeo providers. Run locally or on a server to bond/modify services and manage sentinel config through a web UI.

## Prerequisites
- Docker 20+ (buildkit preferred)
- An environment file with your keys and defaults (see `provider.env`)

## Quick Start (build locally)
```bash
cd provider-core
docker build -t arkeonetwork/provider-core:dev .
docker run --rm --env-file provider.env \
  -p 8080:8080 -p 9999:9999 -p 3636:3636 \
  arkeonetwork/provider-core:dev
```
- Admin UI: http://localhost:8080/index.html  
- Admin API: http://localhost:9999  
- Sentinel metadata: http://localhost:3636/metadata.json

## Environment
Copy `provider.env` and set at least:
```
`PROVIDER_NAME=(Use your provider name)`
`MONIKER=(Use a moniker for your provider name)`
`WEBSITE=(Use your website)`
`DESCRIPTION=(Add a description)`
`LOCATION=(Add a location)`
`FREE_RATE_LIMIT=10`
`FREE_RATE_LIMIT_DURATION=1`

`KEY_NAME=provider`
`KEY_KEYRING_BACKEND=test`
`KEY_MNEMONIC=(Use your own Arkeo hot wallet mnemonic)`
`CHAIN_ID=arkeo-main-v1`

`ARKEOD_HOME=~/.arkeod`
`EXTERNAL_ARKEOD_NODE=tcp://provider1.innovationtheory.com:26657`
`ARKEO_REST_API_PORT=http://provider1.innovationtheory.com:1317`

`SENTINEL_NODE=`
`SENTINEL_PORT=`

ADMIN_PORT=8080
ADMIN_API_PORT=9999
```

The UI also persists sentinel values in `config/sentinel.env` and `config/sentinel.yaml`.

## Pull from GHCR (once published)
```bash
docker pull ghcr.io/arkeonetwork/provider-core:latest
docker run --rm --env-file provider.env \
  -p 8080:8080 -p 9999:9999 -p 3636:3636 \
  ghcr.io/arkeonetwork/provider-core:latest
```

## Workflow
1) Start container (above).  
2) Open the Admin UI.  
3) Sentinel form: set Provider Name/Moniker and save (restarts sentinel).  
4) Provider Services form: bond + mod a service, supply RPC URL (and optional user/pass). On success the sentinel YAML is updated and sentinel is restarted.

## Notes
- Exposed ports: 8080 (web), 9999 (admin API), 3636 (sentinel). Adjust `-p` as needed.
- Sentinel YAML lives at `/app/config/sentinel.yaml`; services are added/removed by the Provider Services form (inactive services are removed; a placeholder is only kept when no services remain).
- Provider claims are auto-triggered every 30 minutes inside the container via `/api/provider-claims` (see `claim_cron.sh`). Override interval with `CLAIM_CRON_INTERVAL` env var if needed.

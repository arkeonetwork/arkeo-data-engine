# Arkeo Provider Admin (Docker Image)

Containerized admin UI + API paired with the Arkeo sentinel service reverse-proxy that onboards your node as an Arkeo provider, manages the provider hot wallet, bonds services, and announces them to the Arkeo Data Marketplace for pay-as-you-go access.

![Provider admin UI overview](../images/readme-providers-1.png)

## Install Docker on you host
Before you start, install Docker on your host and be comfortable with basic Docker commands (start/stop, logs, pull). Use your OS vendor’s Docker docs.

## Configure the container (no provider.env required)
You can pass env vars directly in `docker run` or configure everything in the Admin UI after startup. Settings persist to `/app/config/provider-settings.json` (mounted via the config volume).

Common env vars (all optional; defaults are sane, and `CHAIN_ID` defaults to `arkeo-main-v1`):
```
KEY_NAME=provider
KEY_KEYRING_BACKEND=test
KEY_MNEMONIC=
CHAIN_ID=arkeo-main-v1

ARKEOD_HOME=~/.arkeo
EXTERNAL_ARKEOD_NODE=tcp://provider1.innovationtheory.com:26657
# use PROVIDER_HUB_URI
# ARKEO_REST_API_PORT=http://provider1.innovationtheory.com:1317

SENTINEL_NODE=http://provider-core-1.innovationtheory.com
SENTINEL_PORT=3636

ADMIN_PORT=8080
ADMIN_API_PORT=9999
```
- If you don’t have a mnemonic, leave `KEY_MNEMONIC` empty. On first launch the container will create a hotwallet and print the mnemonic in logs; save it and paste it into the Admin UI (Provider Settings -> Hotwallet Mnemonic) if you want it persisted.

## Run the latest Provider Core docker image
```bash
# create host dirs
mkdir -p ~/provider-core/config ~/provider-core/cache ~/provider-core/arkeo

# stop/remove any existing container with this name
docker stop provider-core || true
docker rm provider-core || true

# pull latest image (optional but recommended)
docker pull ghcr.io/arkeonetwork/provider-core:latest

# run
docker run -d --name provider-core --restart=unless-stopped \
  -e ENV_ADMIN_PORT=8080 \
  -p 8080:8080 -p 3636:3636 -p 9999:9999 \
  -v ~/provider-core/config:/app/config \
  -v ~/subscriber-core/cache:/app/cache \
  -v ~/provider-core/arkeo:/root/.arkeo \
  ghcr.io/arkeonetwork/provider-core:latest
```

## Using the Provider Core Admin
- Open firewall for ports 8080 (admin UI), 9999 (admin API), 3636 (sentinel).
- Admin UI: `http://<host>:8080`
- Copy the Arkeo address shown at the top; fund the address with a small amount of ARKEO (hotwallet).
- In Admin: configure sentinel (so your provider is discoverable).
- Add provider services: pick the service type, set RPC URI and optional user/pass. If your node is firewalled, allow the Docker host IP. The host must reach your node.
- Each provider service requires a minimum bond of 1 ARKEO to prevent spam.
- Do a Provider Export when done. Keep your mnemonic and exports safe - they contain secrets.

You’re now on the Arkeo Data Marketplace.

## Getting ARKEO Tokens (using the Keplr wallet)
In Keplr, add the Osmosis chain, swap for `ARKEO` on Osmosis, then IBC-transfer it to your Arkeo address via the `ARKEO (Arkeo/channel-103074)` route. After it lands, it appears as native `ARKEO` on Arkeo. Start with a small test send and keep a little OSMO for fees.

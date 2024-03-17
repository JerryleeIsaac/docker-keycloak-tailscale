# Keycloak + Tailscale Docker configuration

This repository contains Docker configuration files and setup instructions for deploying Keycloak, an open-source identity and access management solution, alongside Tailscale, a secure network connectivity tool in single container.

This allows the container to connect directly to tailscale network.

## Minimum Environment Variables needed to run

### Tailscale
* `TS_AUTHKEY` - Tailscale authorization key generated from tailscale admin console.
* `TS_HOSTNAME` - Hostname to be used for the container. Sample value: `keycloak`
* `TS_DOMAIN` - Fully qualified domain name of your tailscale network + keycloak hostname. Format: `<TS_HOSTNAME>.<tailsacle network>.ts.net`. Sample: `keycloak.tail1234.ts.net`

### Keycloak
* `KEYCLOAK_ADMIN` - Default admin username
* `KEYCLOAK_ADMIN_PASSWORD` - Initial admin password
* `KC_HTTP_ENABLED` - Set to `false` to restrict access to HTTPs only.
* `KC_HOSTNAME_STRICT` - Set to `true` to restrict keycloak to be accessed only with a specific hostname.
* `KC_DB` - DB backend. Please use `mariadb`
* `KC_DB_PASSWORD` - DB password
* `KC_DB_USERNAME` - DB username
* `KC_DB_URL_HOST` - DB host
* `KC_DB_URL_PORT` - DB port
* `KC_DB_SCHEMA` - DB schema

## Minimum volumes required needed to run
* `-v <tailscale-data-dir>:/var/lib/tailscale` - Set `<tailscale-data-dir>` as the path used by tailscale to store data.
* `-v <cert-file>:/opt/certs/cert.crt` - (Optional) Set `cert-file` to be cert file for https. If not provided, container will use tailscale to generate the certs.
* `-v <key-file>:/opt/certs/cert.key` - (Optional) Set `key-file` to be key file for https. If not provided, container will use tailscale to generate the certs.

## Running the container

Run the following docker command to start the container:

```bash
docker run -d \
  --name keycloak \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=admin \
  -e KC_HTTP_ENABLED=true \
  -e KC_HOSTNAME_STRICT=false \
  -e KC_DB=mariadb \
  -e KC_DB_PASSWORD=<db user> \
  -e KC_DB_USERNAME=<db password> \
  -e KC_DB_URL_HOST=<db host> \
  -e KC_DB_URL_PORT=<db port> \
  -e KC_DB_SCHEMA=keycloak \
  -e TS_AUTHKEY=<TS_AUTHKEY> \
  -e TS_DOMAIN=<TS_DOMAIN> \
  -e TS_HOSTNAME=<TS_hostname> \
  -v <tailscale-data-dir>:/var/lib/tailscale \
  -v <cert-file>:/opt/certs/cert.crt \
  -v <key-file>:/opt/certs/cert.key \
  --device /dev/net/tun:/dev/net/tun \ 
  ghcr.io/JerryleeIsaac/keycloak-tailscale:latest 
```

Alternatively, modify the compose file provided in the repo and run: `docker compose up`

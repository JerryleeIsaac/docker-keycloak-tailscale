#! /bin/bash

set -u

# Run tailscale
tailscaled &
sleep 5
tailscale up --auth-key $TS_AUTHKEY --hostname $TS_HOSTNAME
tailscale update
tailscale set --auto-update
tailscale cert --cert-file $KC_HTTPS_CERTIFICATE_FILE --key-file $KC_HTTPS_CERTIFICATE_KEY_FILE $TS_DOMAIN
tailscale funnel --bg https+insecure://localhost:8443

# Run keycloak
./bin/kc.sh start &

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?

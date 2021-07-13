#!/bin/bash
set -eo pipefail

cat > /etc/dnscrypt-proxy/dnscrypt-proxy.toml <<EOF
EOF

exec "$@"

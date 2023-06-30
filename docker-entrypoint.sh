#!/bin/bash
set -eo pipefail

# If forwarders were present, create forwarders directive
function generate_forwarders () {
  if [[ "$1" ]]; then
    IFS='|' read -ra forwarders <<< "$1"
    for forwarder in "${forwarders[@]}"; do
      IFS=',' read domain server <<< "$forwarder"
      FWDS+="${domain}\t${server}\n"
    done
    echo -en "$FWDS"
  fi
}

function generate_bootstrap () {
  if [[ "$1" ]]; then
    # Add single quote to beginning and end
    BS="'${1}'"
    # Add single quotes around commas and return
    echo -en "${BS/,/\', \'}"
  fi
}

_SERVERS_=${SERVERS:=quad9-doh-ip4-filter-pri}
_FORWARDERS_=$(generate_forwarders $FORWARDERS)
if [[ -v BOOTSTRAP ]]; then
  _BOOTSTRAP_=$(generate_bootstrap ${BOOTSTRAP})
fi

sed -i.dockersave \
  -e 's/^#\s\(server_names\).*/\1 = ['"'$_SERVERS_'"']/gi;' \
  -e 's/127.0.0.1:53/0.0.0.0:53/gi;' \
  -e 's/^#\s\(forwarding_rules.*\)/\1/gi;' \
  /etc/dnscrypt-proxy/dnscrypt-proxy.toml

if [[ -v _BOOTSTRAP_ ]]; then
  sed -i.bootstrap \
      -e 's/^\(bootstrap_resolvers\).*/\1 = ['"$_BOOTSTRAP_"']/gi;' \
    /etc/dnscrypt-proxy/dnscrypt-proxy.toml
fi

cat > /etc/dnscrypt-proxy/forwarding-rules.txt <<EOF
$_FORWARDERS_
EOF

exec "$@"

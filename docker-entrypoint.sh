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

_SERVERS_=${SERVERS:=quad9-doh-ip4-filter-pri}
_FORWARDERS_=$(generate_forwarders $FORWARDERS)

sed -i.dockersave \
  -e 's/^#\s\(server_names\).*/\1 = ['"'$_SERVERS_'"']/gi;' \
  -e 's/127.0.0.1:53/0.0.0.0:53/gi;' \
  -e 's/^#\s\(forwarding_rules.*\)/\1/gi;' \
  /etc/dnscrypt-proxy/dnscrypt-proxy.toml
cat > /etc/dnscrypt-proxy/forwarding-rules.txt <<EOF
$_FORWARDERS_
EOF

exec "$@"

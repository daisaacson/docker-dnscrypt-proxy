# docker-dnscrypt-proxy
docker image for dnscrypt-proxy

# Variables
SERVERS
* quad9-dnscrypt-ip4-filter-pri

FORWARDERS
format:

zone,server[|domain,server|....]

example:
mydomain.com,192.168.0.1|0.168.192.in-addr.arpa,192.168.0.0


```bash
docker run --rm -it --env "SERVERS=quad9-dnscrypt-ip4-filter-pri" --env "mydomain.com,192.168.0.1|0.168.192.in-addr.arpa,192.168.0.1" --publish 53:53/tcp --publish 53:53/udp aiur/docker-dnscrypt
```
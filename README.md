# docker-dnscrypt-proxy
docker image for dnscrypt-proxy

## Variables
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

## Build

### docker

### podman

```shell
version="0.19"
image="daisaacson/dnscrypt-proxy"
podman manifest create ${image}:${version}
podman build --platform linux/amd64,linux/arm64,linux/i386 --manifest ${image}:${version} .
podman login docker.io
podman manifest push ${image}:${version}
```

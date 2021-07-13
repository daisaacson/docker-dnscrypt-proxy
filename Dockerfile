FROM alpine:3.14.0
RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache bash dnscypt-proxy execline
COPY docker-entrypoint.sh /usr/local/bin
EXPOSE 53/tcp
EXPOSE 53/udp
ENTRYPOINT ["docker-entrypoint.sh"]
CMD []

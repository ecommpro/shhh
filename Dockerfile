FROM alpine:3.8
RUN apk add --no-cache pwgen
COPY shhh /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]
FROM alpine:edge

ENV ALPINE_VERSION=3.8
ENV ALPINE_MIRROR=http://nl.alpinelinux.org/alpine

RUN set -xe \
	&& echo ${ALPINE_MIRROR}/v${ALPINE_VERSION}/main > /etc/apk/repositories \
    && echo ${ALPINE_MIRROR}/v${ALPINE_VERSION}/community >> /etc/apk/repositories \
    && apk add --no-cache rspamd rspamd-controller rspamd-proxy ca-certificates

RUN mkdir /run/rspamd
COPY config /etc/rspamd/local.d
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Temporary fix to remove references to rspamd-fuzzy for now
# I copied this from mailu, but looking into the container, I cannot find any line which this references :/
RUN sed -i '/fuzzy/,$d' /etc/rspamd/rspamd.conf

EXPOSE 11332/tcp 11333/tcp 11334/tcp

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/rspamd", "-i", "-f", "-u", "root", "-g", "root"]

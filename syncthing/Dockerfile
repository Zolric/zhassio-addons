ARG BUILD_FROM
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apk update\
	&& apk add --no-cache \
		rsync \
		cifs-utils \
		nginx \
		syncthing \
		\
	&& rm -fr \
		/etc/nginx \
    && mkdir -p /var/log/nginx \
    && touch /var/log/nginx/error.log
	
# Copy data for add-on
COPY rootfs /

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Syncthing" \
    io.hass.description="outil de synchronisation" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Florent" \
    org.opencontainers.image.title="syncthing" \
    org.opencontainers.image.description="outil synchro" \
    org.opencontainers.image.authors="Florent" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/zolric/addons/" \
    org.opencontainers.image.documentation="https://github.com/hassio-addons/addon-plex/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

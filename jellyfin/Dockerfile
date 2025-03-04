ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV JELLYFIN_DATA_DIR=/config/jellyfin \
	JELLYFIN_CONFIG_DIR=/config/jellyfin/config \
	JELLYFIN_LOG_DIR=/config/jellyfin/logs/jellyfin \
	JELLYFIN_WEB_DIR=/usr/share/webapps/jellyfin-web \
	JELLYFIN_CACHE_DIR=/config/jellyfin/cache 
	

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apk update\
	&& apk add --no-cache \
		cifs-utils \
		lshw \
		nginx \
		jellyfin \
		ffmpeg \
		jellyfin-web \
		\
	&& rm -fr \
		/etc/nginx \
    && mkdir -p /var/log/nginx \
    && touch /var/log/nginx/error.log
	
# Copy data for add-on
COPY rootfs /

RUN chmod 755 -R /etc

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="jellyfin" \
    io.hass.description="outil de streaming video" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Florent" \
    org.opencontainers.image.title="jellyfin" \
    org.opencontainers.image.description="outil synchro" \
    org.opencontainers.image.authors="Florent" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/zolric/addons/" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

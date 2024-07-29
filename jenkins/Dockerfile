ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base/amd64:7.2.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

USER root

ENV JENKINS_HOME="/config/jenkins"
	
# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base system
ARG BUILD_ARCH=amd64
RUN \
    ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "aarch64" ]; then ARCH="arm64"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then ARCH="armhf"; fi \
    \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        nginx \
		fontconfig \
		openjdk-17-jre \
		curl \
		wget \
		git \
		python3 \
		default-mysql-client \
		ssh-client \
	\
	&& wget -O /usr/share/keyrings/jenkins-keyring.asc \
	   https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
	&& echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
	   https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null \
	&& apt-get update \
	\
	&& apt-get install -y \
	   jenkins \
	&& apt-get purge -y --auto-remove \
       xz-utils \
    && apt-get clean \
	&& curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=/usr/local/bin sh \
	&& arduino-cli config init --additional-urls https://arduino.esp8266.com/stable/package_esp8266com_index.json \
	&& arduino-cli core update-index \
	&& arduino-cli core install esp8266:esp8266 \
    \
    && rm -fr \
        /etc/nginx \
    \
    && mkdir -p /var/log/nginx \
    && touch /var/log/nginx/error.log 

# Copy root filesystem
COPY rootfs /
RUN chmod -R 755 /etc 

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

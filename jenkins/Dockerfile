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
	&& apt-cache search openjdk \
    && apt-get install -y --no-install-recommends \
        nginx \
		fontconfig \
		openjdk-17-jre \
		curl \
		wget \
		git \
		python3 \
		default-mysql-client \
		ssh-client 
	
RUN \
	wget -O /usr/share/keyrings/jenkins-keyring.asc \
	   https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
	&& echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
	   https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null 
RUN \
	apt-get update \
	&& apt-get install -y \
	   jenkins \
	&& apt-get purge -y --auto-remove \
       xz-utils \
    && apt-get clean \
	&& curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=/usr/local/bin sh \
	&& arduino-cli config init --additional-urls "https://arduino.esp8266.com/stable/package_esp8266com_index.json,https://espressif.github.io/arduino-esp32/package_esp32_index.json" \
	&& arduino-cli core update-index \
	&& arduino-cli core install esp8266:esp8266 \
	&& arduino-cli core install esp32:esp32 
RUN \
    rm -fr \
        /etc/nginx \
    && mkdir -p /var/log/nginx \
    && touch /var/log/nginx/error.log \
 	&& usermod -aG jenkins www-data

# Copy root filesystem
COPY rootfs /tmp

RUN chmod -R 755 /tmp \
	&& mv /tmp/etc/* /etc/.

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
    io.hass.name="Jenkins" \
    io.hass.description="Jenkins add-on by Zolric" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Zolric <zolric@gmail.com>" \
    org.label-schema.description="Jenkins add-on by Zolric" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Jenkins" \
    org.label-schema.schema-version="1.0.0" \
    org.label-schema.url="https://github.com/Zolric/zhassio-addons/jenkins" \
    org.label-schema.usage="https://github.com/Zolric/zhassio-addons/tree/main/jenkins/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/Zolric/zhassio-addons/jenkins/" \
    org.label-schema.vendor="Zolric Hass.io Add-ons"

ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV PHP_MEMORY_LIMIT=512M

# Copy root filesystem
COPY rootfs /

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y jq smbclient sudo \
 && apt-get install -y cron redis-server redis\
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache \
 && chmod +x /usr/bin/* 

# Change the root folder for Nextcloud to the /share directory to be persistent
RUN  sed -i "s|/var/www|/share/nextcloud|g" /etc/apache2/sites-enabled/000-default.conf \
  && sed -i "s|/var/www|/share/nextcloud|g" /etc/apache2/apache2.conf \
  && sed -i "s|/var/www/html|/share/nextcloud/html|g" /entrypoint.sh \
  && sed -i "s|/var/www/html|/share/nextcloud/html|g" /usr/src/nextcloud/config/autoconfig.php

RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf && a2enconf fqdn

ENTRYPOINT [ "/usr/bin/run.sh" ]
CMD ["apache2-foreground"]

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Nextcloud" \
    io.hass.description="Nextcloud add-on by Zolric" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Zolric <zolric@gmail.com>" \
    org.label-schema.description="Nextcloud add-on by Zolric" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Nextcloud" \
    org.label-schema.schema-version="1.0.0" \
    org.label-schema.url="https://github.com/Zolric/hassio-addons/nextcloud" \
    org.label-schema.usage="https://github.com/Zolric/hassio-addons/tree/main/nextcloud/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/Zolric/hassio-addons/nextcloud/" \
    org.label-schema.vendor="Zolric Hass.io Add-ons"

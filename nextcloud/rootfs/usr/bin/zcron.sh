#!/bin/bash

# make folders
mkdir -p \
    /share/nextcloud/crontabs

## root
# if crontabs do not exist in config
if [[ ! -f /share/nextcloud/crontabs/root ]]; then
    # copy crontab from system
    if crontab -l -u root; then
        crontab -l -u root >/share/nextcloud/crontabs/root
    fi

    # if crontabs still do not exist in config (were not copied from system)
    # copy crontab from included defaults (using -n, do not overwrite an existing file)
    cp -n /etc/crontabs/root /share/nextcloud/crontabs/
fi

# set permissions and import user crontabs

crontab -u root /share/nextcloud/crontabs/root
crontab -u www-data /share/nextcloud/crontabs/root

echo "cron start"
service cron restart

whoami
crontab -l
crontab -u www-data -l
ls -1 /var/spool/cron/crontabs
#!/usr/bin/with-contenv bashio

bashio::log.info "Protection Mode is $(bashio::app.protected)"
bashio::log.info "montage usb Disk Hass.io"
disk_s=$(bashio::config 'disk_s')
type_s=$(bashio::config 'type_s')
version_syncthing=$(syncthing version)

# Mount CIFS Share if configured and if Protection Mode is active
#ls -ltr /disk1
bashio::log.info "link disk USB ${disk_s} sur /disk1"
mkdir -p /disk1
if [ $type_s != "ext4" ]
then
	typeopt="-t ${type_s}"
else 
	typeopt=""
fi
mount ${typeopt} /dev/disk/by-label/${disk_s} /disk1 

bashio::log.info "Version Syncthing: ${version_syncthing}"
#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

#echo "[Info]Protection Mode is $(jq --raw-output '.addon.protected' $CONFIG_PATH)"
echo "[Info]Démarrage NextCloud"
disk_s=$(jq --raw-output '.disk_s[]' $CONFIG_PATH)
proprio=$(jq --raw-output '.NEXTCLOUD_ADMIN_USER' $CONFIG_PATH)
source=$(jq --raw-output '.source[]' $CONFIG_PATH)
option=$(jq --raw-output '.option' $CONFIG_PATH)
datashare=$(jq --raw-output '.DATA_users' $CONFIG_PATH)

SHARE_DIR=/share/nextcloud
chown -R www-data:root ${SHARE_DIR}


if [ ! -d "${SHARE_DIR}" ]; then
    mkdir -p "${SHARE_DIR}"
    chown -R www-data:root "${SHARE_DIR}"
    chmod -R g=u "${SHARE_DIR}"
fi


#cache redis
#php -m
usermod -a -G www-data redis
#pstree
service --status-all
service redis-server restart
cp -n /etc/redis/redis.conf /share/nextcloud/crontabs/

if [ -n "${disk_s}" ]; then
	for param_dd in $disk_s
	do
		dd=`echo ${param_dd} | cut -f1 -d'='`
		ddlow=`echo ${dd} | awk '{print tolower($0)}'`
		typdd=`echo ${param_dd} | cut -f2 -d'=' | sed 's/ *$//g' | sed 's/^ *//g'`
		
		if [[ $typdd = "local" ]]
		then
			echo "[Info]Link data en local ${datasource}"
		else
			echo "[Info]montage usb Disk Hass.io et démarrage NextCloud"
			echo "[Info]Link disk ${dd} type ${typdd} "
			mkdir /${ddlow}
			if [ "$typdd" != "ext4" ]
			then
				typeopt="-t ${typdd}"
			else 
				typeopt=""
			fi
			#echo "mount ${typeopt} /dev/disk/by-label/${dd} /${ddlow}"
			mount ${typeopt} /dev/disk/by-label/${dd} /${ddlow}
			echo "[Info]Link disk USB OK"
		fi
	done
fi

export NEXTCLOUD_DATA_DIR="${datashare}/nextcloud/users/data"
chown -R www-data:root "${NEXTCLOUD_DATA_DIR}"
if [ ! -d "${NEXTCLOUD_DATA_DIR}" ]; then
    mkdir -p "${NEXTCLOUD_DATA_DIR}"
    chown -R www-data:root "${NEXTCLOUD_DATA_DIR}"
    chmod -R g=u "${NEXTCLOUD_DATA_DIR}"
fi

if [ -n "${source}" ]; then
	for folder in $source
	do
		slien=`echo ${folder} | cut -f1 -d'=' | awk '{print tolower($0)}'`
		partage=`echo ${folder} | cut -f2 -d'=' | awk '{print tolower($0)}'`
		DISK_DATA=${NEXTCLOUD_DATA_DIR}/${proprio}/files/${partage}/
		DISK_SRC=${slien}/
		if [ -d "${DISK_SRC}" ]; then
			echo "ajout du repertoire ${DISK_SRC} en partage ${partage}"
			if [ ! -d "${DISK_DATA}" ]; then
				mkdir -p "${DISK_DATA}"
				chown -R www-data:root "${DISK_DATA}"
			fi
			mount --bind ${DISK_SRC} ${DISK_DATA}
			chown -R root:www-data "${DISK_SRC}"
			chmod -R 770 "${DISK_SRC}"
		else echo "le repertoire ${DISK_SRC} n'existe pas"
		fi

	done
	#ls -ltr /share/nextcloud/html/data/${proprio}
	if [[ $option = "force" ]]
	then
		echo "[info]montage forcé"
		#sudo -u www-data PHP_MEMORY_LIMIT=1G php /share/nextcloud/html/occ files:scan ${proprio}
		sudo -u www-data PHP_MEMORY_LIMIT=1G php /share/nextcloud/html/occ files:scan --all
	else
		sudo -u www-data PHP_MEMORY_LIMIT=1G php /share/nextcloud/html/occ files:scan --unscanned ${proprio}
	fi
	echo "[Info]recherche d'un Script /share/nextcloud/maintenance/occ_act.sh"
	if test -f "/share/nextcloud/maintenance/occ_act.sh"; then
		echo "[Info]Script de maintenance démarrage présent"
		chmod +x /share/nextcloud/maintenance/occ_act.sh
		/share/nextcloud/maintenance/occ_act.sh
	fi
fi


/usr/bin/zcron.sh


echo 'Starting with the following configuration:';
jq --raw-output 'keys[] as $k | select(.[$k] != "" and .[$k] != null) | "\t" + ($k | ascii_upcase) + "=\"" + (.[$k]|tostring) + "\""' $CONFIG_PATH;
eval $(jq --raw-output 'keys[] as $k | select(.[$k] != "" and .[$k] != null) | "export " + ($k | ascii_upcase) + "=\"" + (.[$k]|tostring) + "\""' $CONFIG_PATH);

/entrypoint.sh "$@"

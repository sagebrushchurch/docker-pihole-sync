#!/bin/bash
inotifywait -r -m -e modify --exclude '01-pihole\.conf' --format '%w%f' /mnt/etc-dnsmasq.d/ | while read MODFILE
do
    rsync -a -P --exclude '01-pihole.conf' /mnt/etc-dnsmasq.d/ -e "ssh -p ${REM_SSH_PORT}" root@${REM_HOST}:/mnt/etc-dnsmasq.d/ --delete
    if [[ "${?}" -ne "0" ]]; then
        touch /fail
    elif [[ -f "/fail" ]]; then
        rm -f /fail
    fi
done

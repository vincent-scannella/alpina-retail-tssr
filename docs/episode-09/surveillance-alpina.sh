#!/bin/bash

# ALPINA RETAIL - Surveillance legere FS1 (reconstitution documentee du laboratoire)
LOG="/var/log/surveillance-alpina.log"

# Disponibilite ICMP des equipements
for cible in "pfSense:10.10.10.1" "DC1:10.10.10.10"
do
    nom="${cible%%:*}"
    ip="${cible#*:}"

    if ping -c 2 -W 2 "$ip" > /dev/null 2>&1
    then
        etat="OK"
    else
        etat="ALERTE"
    fi

    echo "$(date '+%F %T') | $nom | $ip | $etat" | tee -a "$LOG"
done

# Services essentiels du serveur de fichiers
for service in smbd winbind ssh
do
    if systemctl is-active --quiet "$service"
    then
        etat="OK"
    else
        etat="ALERTE"
    fi

    echo "$(date '+%F %T') | FS1 | $service | $etat" | tee -a "$LOG"
done

# Montage et remplissage du disque de sauvegarde
if ! mountpoint -q /mnt/backup
then
    echo "$(date '+%F %T') | FS1 | BACKUP | ALERTE : disque non monte" | tee -a "$LOG"
else
    utilisation=$(df -P /mnt/backup | awk 'NR==2 {gsub(/%/, "", $5); print $5}')

    if [ "$utilisation" -ge 80 ]
    then
        etat="ALERTE"
    else
        etat="OK"
    fi

    echo "$(date '+%F %T') | FS1 | BACKUP | ${utilisation}% | $etat" | tee -a "$LOG"
fi

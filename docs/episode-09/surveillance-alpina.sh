#!/bin/bash

# ALPINA RETAIL - Surveillance legere FS1 (reconstitution documentee du laboratoire)
# Correctif de robustesse sur la mesure du disque ajoute au depot apres l'audit.
# Ce correctif n'a pas encore ete applique ni teste sur la VM FS1.
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
    # Ne jamais qualifier le disque OK si df echoue ou renvoie une valeur vide/invalide.
    if ! df_sortie=$(LC_ALL=C df -P /mnt/backup 2>/dev/null)
    then
        echo "$(date '+%F %T') | FS1 | BACKUP | ALERTE : lecture du disque impossible" | tee -a "$LOG"
    else
        utilisation=$(printf '%s\n' "$df_sortie" | awk 'NR==2 {gsub(/%/, "", $5); print $5}')

        if [[ ! "$utilisation" =~ ^[0-9]+$ ]] || (( utilisation > 100 ))
        then
            echo "$(date '+%F %T') | FS1 | BACKUP | ALERTE : valeur d'utilisation invalide" | tee -a "$LOG"
        else
            if (( utilisation >= 80 ))
            then
                etat="ALERTE"
            else
                etat="OK"
            fi

            echo "$(date '+%F %T') | FS1 | BACKUP | ${utilisation}% | $etat" | tee -a "$LOG"
        fi
    fi
fi

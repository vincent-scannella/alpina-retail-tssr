# ALPINA RETAIL — Épisode 07 — Captures de sauvegarde et restauration

**10 novembre 2026.** Cinq captures authentiques fournies au cours de la séance ; images compressées pour le dépôt.

| Capture | Information vérifiée |
|---|---|
| [01 — Deux disques dans VMware](01-vmware-disques.png) | Disque système SCSI de 40 Gio et second disque SCSI de 15 Gio non préalloué |
| [02 — Détection du disque dans Debian](02-lsblk-nouveau-disque.png) | `lsblk` montre `/dev/sda` (40 Go) et `/dev/sdb` (15 Go) |
| [03 — Montage ext4 confirmé](03-stockage-monte.png) | `df -hT /mnt/backup` → `/dev/sdb1`, ext4, 15 Go |
| [04 — Liste de l'archive tar](04-archive-liste.png) | `commun/` et `commun/test-commun.txt` présents |
| [05 — Restauration validée par cmp](05-fichier-restaure-identique.png) | Message `Fichiers identiques` après comparaison de l'original et de la copie restaurée |

## Disque et stockage

![Deux disques dans VMware](01-vmware-disques.png)

![Détection du nouveau disque sous Debian](02-lsblk-nouveau-disque.png)

![Disque de sauvegarde monté](03-stockage-monte.png)

## Sauvegarde et restauration

![Contenu de la sauvegarde](04-archive-liste.png)

![Comparaison après restauration](05-fichier-restaure-identique.png)

**Limites :** la vérification `cmp` porte sur un fichier de test ; elle ne vaut pas validation des permissions d'accès Samba ou restauration après perte totale de VM. Le montage automatique est configuré, mais son fonctionnement après redémarrage n'a pas encore été contrôlé.

[Revenir au compte rendu de l'épisode 07](../README.md)

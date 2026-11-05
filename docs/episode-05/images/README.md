# Épisode 05 — Captures authentiques Debian / Réseau / DNS

**Date des manipulations : 05 novembre 2026.** Les onze fichiers PNG de ce dossier sont des **captures d'écran d'origine fournies au fil des manipulations**, sans génération ni simulation graphique. Elles servent de preuves associées au [journal technique de l'épisode 05](../README.md).

Le projet est fictif. Les noms des hôtes et les IP visibles appartiennent au laboratoire ; aucune capture de mot de passe ni de jeton d'accès n'est publiée.

| Fichier | Contrôle réalisé |
|---|---|
| [01-fs1-ip-statique.png](01-fs1-ip-statique.png) | `ip -br address` : interface ens33 UP, adresse 10.10.10.30/24 |
| [02-connectivite-pfsense.png](02-connectivite-pfsense.png) | `ping -c 4 10.10.10.1` : 4 réponses, 0 % de perte |
| [03-connectivite-dc1.png](03-connectivite-dc1.png) | `ping -c 4 10.10.10.10` : 4 réponses, 0 % de perte |
| [04-dns-ancien-resolv-conf.png](04-dns-ancien-resolv-conf.png) | Ancien `nameserver 10.50.10.2` et `localdomain` dans `/etc/resolv.conf` |
| [05-dns-resolv-conf-corrige.png](05-dns-resolv-conf-corrige.png) | `search ironman.test` et `nameserver 10.10.10.10` |
| [06-dns-resolution-dc1.png](06-dns-resolution-dc1.png) | `getent ahostsv4 dc1-gre-siege.ironman.test` → `10.10.10.10` |
| [07-dns-persistant-apres-redemarrage.png](07-dns-persistant-apres-redemarrage.png) | Même configuration `/etc/resolv.conf` conservée après `sudo reboot` et reconnexion SSH |
| [08-interfaces-ip-statique.png](08-interfaces-ip-statique.png) | `/etc/network/interfaces` : adresse, masque, passerelle et DNS cible |
| [09-sudo-groupe-admin.png](09-sudo-groupe-admin.png) | `id administrateur` : appartenance au groupe sudo |
| [10-reseau-nat-provisoire.png](10-reseau-nat-provisoire.png) | `ens33` UP avec IPv4 DHCP 10.50.10.131/24 sur VMnet8 |

| [11-jonction-domaine-ads.png](11-jonction-domaine-ads.png) | Commande `net ads join` : jonction de FS1 au domaine `ironman.test` confirmée |

## Captures essentielles

### Interface et IP statique

![Adresse IPv4 de FS1 sur VMnet1](01-fs1-ip-statique.png)

### Test de communication avec pfSense

![Ping Debian vers pfSense avec zéro perte](02-connectivite-pfsense.png)

### Test de communication avec DC1

![Ping Debian vers Windows Server avec zéro perte](03-connectivite-dc1.png)

### Incident DNS : ancienne configuration héritée de VMnet8

![DNS obsolète 10.50.10.2](04-dns-ancien-resolv-conf.png)

### DNS corrigé vers Active Directory

![DNS corrigé 10.10.10.10 et ironman.test](05-dns-resolv-conf-corrige.png)

### Résolution du nom du contrôleur de domaine

![getent ahostsv4 dc1-gre-siege.ironman.test retourne 10.10.10.10](06-dns-resolution-dc1.png)

### DNS conservé après redémarrage Debian

![DNS après reboot, noms et IP attendus](07-dns-persistant-apres-redemarrage.png)

### Première jonction au domaine Active Directory

![Résultat net ads join vers ironman.test](11-jonction-domaine-ads.png)

**Précautions d'interprétation :** ces contrôles attestent une configuration réseau et une résolution de nom au moment des tests, pas la disponibilité des services AD/Kerberos, un contrôle exhaustif des conflits d'adresses, ni une relation de confiance Winbind validée ni un partage Samba en fonctionnement. La connexion SSH a été observée en session, mais aucun audit de sécurisation SSH n'a encore été effectué.

[Retour à l'épisode 05](../README.md)

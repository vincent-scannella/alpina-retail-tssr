# ALPINA RETAIL — Historique des objectifs

Suivi historique des réalisations et des travaux complémentaires du laboratoire. **La V1 est clôturée le 17 novembre 2026 sur le périmètre testé**, sans déclarer ces travaux ouverts réalisés. Voir le [bilan final](../episode-13/README.md).

## Objectifs ouverts (7 — hors périmètre de clôture V1)

- [ ] Approfondir les diagnostics AD DS et les contrôles des autres fichiers de stratégies.
- [ ] Poursuivre le filtrage IPv4 restrictif sur pfSense.
- [ ] Tester le mappage GPO avec un utilisateur hors du groupe `GG_FS1_COMMUN_RW`.
- [ ] Vérifier une exécution cron de la version enrichie de surveillance et réaliser un test `ALERTE` non destructif.
- [ ] Fiabiliser les alertes MariaDB/processus/swap de Centreon-central (6 CRITICAL, 8 UNKNOWN au 16/11) ; superviser réellement FS1 et PC-TEST si le laboratoire est repris.
- [ ] Refaire des captures Centreon pour l'épisode 10 : les six captures d'origine n'ont pas été conservées.
- [ ] Vérifier l'exécution automatique réelle de la sauvegarde cron à 02 h et prévoir une copie hors de l'hôte VMware ; poursuivre les futurs VPN intersites.

## Objectifs atteints (37)

- [x] Définir l'entreprise fictive, son organisation et ses besoins informatiques.
- [x] Installer pfSense et valider la connectivité IP, le NAT/PAT et un scénario de filtrage.
- [x] Déployer `DC1-GRE-SIEGE`, créer `ironman.test` et vérifier les services AD DS / DNS ciblés.
- [x] Créer et activer l'étendue DHCP du siège ; contrôler sa plage et ses options.
- [x] Confirmer la durée du bail de **8 jours** et l'attribution DHCP à `PC-TEST-GRE` (`ipconfig /all`).
- [x] Joindre Windows 11 au domaine, authentifier des comptes AD et vérifier l'application d'une GPO ordinateur à 900 secondes.
- [x] Observer le verrouillage automatique sur `PC-TEST-GRE` (observation du 03/11/2026 ; pas de capture ni de chronométrage précis).
- [x] Vérifier depuis Windows 11 les partages `SYSVOL` et `NETLOGON` (captures non publiées).
- [x] Vérifier la découverte du contrôleur de domaine avec `nltest` depuis Windows 11 (`DC1-GRE-SIEGE`, `10.10.10.10`).
- [x] Vérifier le canal sécurisé de `PC-TEST-GRE` avec `Test-ComputerSecureChannel -Verbose` : `True` le 03/11/2026 (capture non publiée).
- [x] Lire depuis Windows 11 le fichier `GPT.INI` de la Default Domain Policy via SYSVOL (`[General]`, `Version=3` ; capture non publiée).
- [x] Installer Debian 12 sur `FS1-GRE-SIEGE`, réussir la connexion console et vérifier l'identité via `hostnamectl` (capture non publiée).
- [x] Raccorder FS1 au réseau LAN, configurer IPv4/DNS et vérifier les pings et l'accès SSH après redémarrage.
- [x] Vérifier DNS SRV LDAP/Kerberos, installer Samba/Winbind et joindre FS1 à `ironman.test` (`net ads join`).
- [x] Vérifier la relation de confiance `net ads testjoin` et l'énumération des utilisateurs IRONMAN via Winbind après diagnostic.
- [x] Résoudre les identités AD par NSS sur Debian, attribuer le groupe de sécurité et les permissions au dossier COMMUN, et ouvrir le partage depuis Windows 11.
- [x] Créer et enregistrer un fichier depuis Windows 11 ; vérifier sa lecture sur Debian, son propriétaire AD, son groupe et les permissions `660`.
- [x] Confirmer le refus d'accès SMB (`NT_STATUS_ACCESS_DENIED`) pour `IRONMAN\Administrateur`, compte sans autorisation dans le scénario.
- [x] Durcir SSH sur FS1 : désactiver `PermitRootLogin`, mots de passe et clavier interactif ; vérifier une nouvelle connexion ED25519 après rechargement.
- [x] Durcir Samba sur FS1 : signature serveur requise, chiffrement SMB3 obligatoire pour COMMUN, partages invités désactivés, ouverture du partage vérifiée sur Windows 11 (`Encrypted=True`, SMB 3.1.1).
- [x] Vérifier le pare-feu de domaine de DC1 : actif et politique `BlockInbound,AllowOutbound`.
- [x] Renforcer la politique de mots de passe du domaine `ironman.test` : longueur minimale 14, complexité activée, verrouillage après 10 échecs pendant 15 minutes, compteur réinitialisé après 15 minutes.
- [x] Confirmer Microsoft Defender sur DC1 ; ajuster pfSense au WAN VMware NAT, sauvegarder sa configuration et configurer les règles LAN DNS/NTP/Web.
- [x] Configurer NTP externe sur le PDC Emulator, diagnostiquer l'échec DNS externe et rétablir la résolution via le redirecteur pfSense, validée depuis DC1 et PC-TEST.
- [x] Vérifier le refus DNS direct du poste client vers pfSense (timeout constaté dans l'épisode 06).
- [x] Préparer un disque de sauvegarde dédié sur FS1, créer et vérifier une archive `tar.gz`, restaurer un fichier et confirmer son intégrité par `cmp` (épisode 07).
- [x] Créer un script Bash de sauvegarde, le tester, enregistrer une tâche quotidienne cron à 02 h et confirmer l'écriture dans le journal.
- [x] Vérifier le montage automatique du disque de sauvegarde par UUID après redémarrage de FS1.
- [x] Transférer les archives du partage FS1 vers DC1 avec SCP et vérifier l'intégrité SHA-256 d'une copie.
- [x] Déployer la GPO `GPO_ALPINA_Lecteur_COMMUN` : lecteur `P:` sur Windows 11, ciblage AD et écriture sur Debian vérifiés (épisode 08).
- [x] Mettre en place un script de surveillance Bash (ICMP, services, montage/capacité disque), six contrôles manuels réussis ; planification cron 5 minutes et exécution initiale constatée (épisode 09).
- [x] Importer la VM `CENTREON-GRE-SIEGE` dans VMware Workstation ; import constaté dans VMware (sans démarrage).
- [x] Démarrer Centreon, accéder à son interface Web et vérifier le service ICMP pfSense : UP / OK, 0 % de perte le 11/11/2026 (épisode 10).
- [x] Valider les contrôles CPU, RAM et disque principal de Centreon ; créer le tableau de bord du siège avec les trois jauges et le service ICMP de pfSense (13/11/2026).
- [x] Superviser DC1 via Windows CMA : CPU, RAM, disque C: et ICMP OK ; tableau de bord actualisé le 16/11/2026.
- [x] Documenter un **scénario fictif** de supervision FS1 sous Centreon (épisode 11), **sans déploiement ni test**.
- [x] Installer GLPI 12.0.2 sur Debian 13 (VM dédiée), sécuriser les comptes de démonstration et réaliser le cycle du ticket n°1 de Camille Martin jusqu'à **Clos** le 17/11/2026 ; incident AD/Samba **fictif**, sans réparation réelle ([épisode 12](../episode-12/README.md)).

[Retour au sommaire](../../README.md)

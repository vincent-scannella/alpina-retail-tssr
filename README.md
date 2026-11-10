![Bannière ALPINA RETAIL](IMG_0869.png)

# ALPINA RETAIL — Laboratoire systèmes & réseaux

**Projet personnel TSSR · Infrastructure multisite fictive · Documentation technique et preuves de validation**

Je conçois, déploie et dépanne progressivement une infrastructure informatique inspirée des besoins d'une PME du prêt-à-porter. Le projet associe **architecture réseau, Windows Server, Active Directory, DNS, DHCP, pfSense, virtualisation et support utilisateurs**.

> **À propos du périmètre :** ALPINA RETAIL est une **entreprise entièrement fictive**. Les quatre sites et leurs 75 collaborateurs sont simulés ; seules certaines machines du **laboratoire du siège de Grenoble** sont réellement déployées. Chaque résultat annoncé comme validé renvoie à une manipulation documentée.

## Le projet en bref

| Entreprise simulée | Laboratoire personnel | Progression |
|---|---|---|
| **4 sites** · 75 collaborateurs fictifs | **Windows 11** · VMware Workstation · **16 Go de RAM sur l'hôte** | **Épisodes 00 à 07 documentés**, sécurisation du siège en cours |

**Ce qui est déjà vérifié :**

- **Réseau et sécurité :** pfSense CE 2.9.0 configuré ; LAN/WAN, accès Internet depuis Windows 11, NAT/PAT observé, filtrage ICMP ciblé testé puis retiré, sauvegarde de configuration chiffrée conservée hors GitHub.
- **Windows Server et AD DS :** Windows Server 2025, forêt `ironman.test`, promotion de `DC1-GRE-SIEGE`, tests `dcdiag` ciblés réussis ; partages `SYSVOL` et `NETLOGON` accessibles depuis Windows 11 et découverte du DC par `nltest /dsgetdc:ironman.test` réussie et canal sécurisé vérifié par PowerShell (`True`) et lecture de `GPT.INI` depuis SYSVOL (`Version=3`) ; captures fournies en conversation, pas encore déposées sur GitHub.
- **DNS et dépannage :** résolution des noms internes et externes ; diagnostic du message `Server: UnKnown`, création d'une zone inversée et d'un enregistrement PTR, contre-test réussi.
- **DHCP :** serveur autorisé dans Active Directory, étendue `DHCP-GRE-SIEGE` active ; **bail `10.10.10.100/24` de huit jours reçu et options vérifiées sur le client Windows 11**.
- **Debian FS1 (épisode 05) :** Debian 12 sur `VMnet1` (`10.10.10.30/24`) ; AD `ironman.test` joint ; Winbind/NSS reconnaît utilisateurs et groupes AD ; groupe `GG_FS1_COMMUN_RW` et permissions Linux `2770` en place ; **partage `COMMUN` accessible en lecture/écriture depuis Windows 11**, contenu relu sur Debian, propriétaire/groupe et permissions `660` observés ; **refus SMB `NT_STATUS_ACCESS_DENIED`** obtenu avec un compte non autorisé le 09/11/2026. L'accès SSH de FS1 est renforcé par clé ED25519 ; Samba impose désormais la signature serveur et le chiffrement SMB3 du partage COMMUN (SMB 3.1.1, `Encrypted=True` côté Windows 11) ; le durcissement global reste en cours.

[**Voir les preuves pfSense — épisode 03**](docs/episode-03/README.md) · [**Voir les 40 captures Windows Server / AD / DNS / DHCP / GPO — épisode 04**](docs/episode-04/README.md)

## Architecture actuelle du laboratoire

La topologie suivante décrit les composants **créés dans VMware**, et non les futurs réseaux de toutes les boutiques.

![Topologie réelle du laboratoire du siège de Grenoble : Internet, VMware NAT VMnet8, pfSense, VMnet1, DC1 Windows Server et PC-TEST-GRE](docs/topologie-laboratoire-siege.svg)

*Schéma de synthèse au 3 novembre 2026 — équipement du laboratoire réellement créé. **DHCP client, jonction AD et application de la GPO vérifiés** ; verrouillage automatique observé par l'auteur sans capture ni mesure chronométrée précise. [Ouvrir le schéma vectoriel en grand](docs/topologie-laboratoire-siege.svg).*

*Le poste `PC-TEST-GRE`, initialement configuré en statique sur `10.10.10.20`, utilise maintenant un **bail DHCP `10.10.10.100` délivré par DC1**. Les trois VM ont été allumées simultanément pour les essais du 3 novembre, malgré les 16 Go de RAM de l'hôte.*

### Repères d'adressage du siège

| Composant | Configuration | État |
|---|---|---|
| pfSense LAN | `10.10.10.1/24` | Configuré et testé |
| DC1 — AD DS / DNS | `10.10.10.10/24` | Configuré et testé |
| PC-TEST-GRE | `10.10.10.100/24` (DHCP ; statique initiale `10.10.10.20`) | Bail, DNS, jonction AD, sessions et GPO vérifiés |
| FS1 — Debian 12 | `10.10.10.30/24` (statique, VMnet1) | AD/Winbind et partage Samba validés ; SSH par clé ED25519 ; COMMUN chiffré via SMB 3.1.1 confirmé par Windows 11 le 09/11 |
| Étendue Windows DHCP | `10.10.10.100` → `10.10.10.199` | Active ; bail client de 8 jours confirmé |

**À distinguer :** la connexion entre les quatre sites, les VPN et les autres serveurs de l'architecture cible sont pour le moment des **éléments de conception**, pas un environnement multisite opérationnel.

## Journal de bord — choisir un épisode

| Épisode | Sujet | Livrables et validation |
|---|---|---|
| **00** | [Présentation du projet](#vue-densemble-de-lentreprise-fictive) | Contexte, sites et objectifs de la maquette |
| **01** | [Organisation et organigramme](docs/episode-01/README.md) | Répartition des 75 collaborateurs simulés, organigramme et [dossier PDF](docs/episode-01/Alpina_Retail_Organisation_Episode_01.pdf) |
| **02** | [Cahier des charges informatique](docs/episode-02/README.md) | Besoins métier, architecture cible, droits d'accès et limites du laboratoire |
| **03** | [Pare-feu pfSense et poste Windows 11](docs/episode-03/README.md) | Installation, adressage, NAT/PAT, filtrage ICMP, tests réseau et sauvegarde chiffrée |
| **04** | [Windows Server, AD DS, DNS et DHCP](docs/episode-04/README.md) | DC1, dépannage DNS, DHCP réel sur Windows 11, jonction à `ironman.test`, utilisateur AD et première GPO (application vérifiée ; verrouillage ensuite observé par l'auteur sans capture) |
| **05** | [FS1 — Serveur de fichiers Debian Linux](docs/episode-05/README.md) | Samba/AD/Winbind, groupe de sécurité, partage `[COMMUN]` ; écriture et lecture fonctionnelles, permissions `660`, accès non autorisé refusé ; [22 captures authentiques](docs/episode-05/images/README.md) ; chantier Samba du siège validé le 09/11/2026 |
| **06** | [Durcissement de l'infrastructure — siège Grenoble](docs/episode-06/README.md) | SSH/SMB sécurisés ; pare-feu Windows et comptes AD renforcés ; pfSense (WAN NAT, règles DNS/NTP/Web) ; source NTP du PDC vérifiée ; **incident DNS externe résolu par redirecteur pfSense**, validé sur DC1 et PC-TEST ; [16 captures](docs/episode-06/images/README.md). Contrôle DNS direct de PC-TEST vers pfSense conforme (timeout) ; filtrage IPv4 restrictif à poursuivre. |
| **07** | [FS1 — Sauvegarder et restaurer le partage Samba](docs/episode-07/README.md) | Disque de sauvegarde virtuel 15 Gio, ext4 et montage `/mnt/backup` **vérifié après redémarrage par UUID** ; sauvegarde `tar.gz` et restauration testées avec contenu et droits identiques ; script Bash sécurisé par contrôle du montage, cron quotidien à 02 h, journal testé ; [7 captures](docs/episode-07/images/README.md). Exécution automatique réelle et copie hors VM encore à vérifier. |

**Preuves visuelles :** [épisode 07 — 7 captures authentiques de la sauvegarde et restauration FS1](docs/episode-07/images/README.md) · [épisode 03 — 8 captures authentiques et 2 schémas pédagogiques](docs/episode-03/images/README.md) · [épisode 04 — 40 captures Windows Server / AD DS / DNS / DHCP / GPO](docs/episode-04/images/README.md) · [épisode 05 — 22 captures authentiques Debian / réseau / DNS / AD / SMB](docs/episode-05/images/README.md).

## Vue d'ensemble de l'entreprise fictive

![Schéma des quatre implantations d'ALPINA RETAIL : siège et trois boutiques](docs/episode-00/images/vue-ensemble-multisite.svg)

*Schéma de conception — entreprise fictive de 75 collaborateurs : Grenoble (siège, 30), Grenoble Centre (15), Voiron (15) et Chambéry (15). Les liaisons intersites sont des objectifs futurs.*

Les collaborateurs sont principalement représentés par des **besoins métier, des rôles et, progressivement, des comptes de test**. Il n'est pas prévu de démarrer 75 postes ou de simuler 75 personnes en activité simultanément.

## Démarche TSSR et compétences mobilisées

Chaque épisode technique suit la même logique :

**Besoin → architecture → configuration → vérification → diagnostic → documentation.**

Les compétences travaillées comprennent l'administration Windows Server, AD DS, DNS, DHCP, la virtualisation, les réseaux IPv4, le routage/NAT, les règles de filtrage et le dépannage d'incidents.

**Exemple documenté :** dans l'[épisode 04](docs/episode-04/README.md), un test `nslookup` affichait initialement `Server: UnKnown` et un délai d'attente. L'inspection DNS a révélé l'absence de zone inversée et de PTR ; après leur création, les recherches directe et inverse ont réussi sans le message initial. Les captures **avant / après** sont présentes dans le dossier de l'épisode.

> **Rigueur de validation :** une configuration affichée comme active ne remplace pas un test de fonctionnement côté client. Les erreurs, limites et étapes non vérifiées sont conservées dans les comptes rendus.

## Prochains objectifs

- [x] Définir l'entreprise fictive, son organisation et ses besoins informatiques.
- [x] Installer pfSense et valider la connectivité IP, le NAT/PAT et un scénario de filtrage.
- [x] Déployer `DC1-GRE-SIEGE`, créer `ironman.test` et vérifier les services AD DS / DNS ciblés.
- [x] Créer et activer l'étendue DHCP du siège ; contrôler sa plage et ses options.
- [x] Confirmer la durée du bail de **8 jours** et l'attribution DHCP à `PC-TEST-GRE` (`ipconfig /all`).
- [x] Joindre Windows 11 au domaine, authentifier des comptes AD et vérifier l'application d'une GPO ordinateur à 900 secondes.
- [x] Observer le verrouillage automatique sur `PC-TEST-GRE` (retour de l'auteur du 03/11/2026 ; pas de capture ni de chronométrage précis).
- [x] Vérifier depuis Windows 11 les partages `SYSVOL` et `NETLOGON` (captures transmises en conversation, non encore déposées sur GitHub).
- [x] Vérifier la découverte du contrôleur de domaine avec `nltest` depuis Windows 11 (`DC1-GRE-SIEGE`, `10.10.10.10`).
- [x] Vérifier le canal sécurisé de `PC-TEST-GRE` avec `Test-ComputerSecureChannel -Verbose` : `True` le 03/11/2026 (capture en conversation, non encore déposée sur GitHub).
- [x] Lire depuis Windows 11 le fichier `GPT.INI` de la Default Domain Policy via SYSVOL (`[General]`, `Version=3` ; capture fournie dans la conversation, non encore déposée sur GitHub).
- [ ] Approfondir les diagnostics AD DS et les contrôles des autres fichiers de stratégies.
- [x] Installer Debian 12 sur `FS1-GRE-SIEGE`, réussir la connexion console et vérifier l'identité via `hostnamectl` (capture en conversation, non encore sur GitHub).
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
- [ ] Vérifier le blocage DNS direct depuis un poste client et poursuivre le filtrage IPv4 restrictif.
- [x] Préparer un disque de sauvegarde dédié sur FS1, créer et vérifier une archive `tar.gz`, restaurer un fichier et confirmer son intégrité par `cmp` (épisode 07).
- [x] Créer un script Bash de sauvegarde, le tester, enregistrer une tâche quotidienne cron à 02 h et confirmer l'écriture dans le journal.
- [x] Vérifier le montage automatique du disque de sauvegarde par UUID après redémarrage de FS1.
- [ ] Vérifier l'exécution automatique réelle de cron à 02 h et prévoir une copie hors VM ; poursuivre la supervision et les futurs VPN intersites.

## À propos

**Auteur : Vincent Scannella — Technicien Supérieur Systèmes et Réseaux (TSSR).**

Ce dépôt est un **portfolio de mise en pratique** destiné à montrer une méthode de travail : installer, vérifier, diagnostiquer et produire une documentation exploitable. Les données, utilisateurs et sites de l'entreprise sont fictifs ; les captures de laboratoire sont authentiques et sélectionnées pour ne pas divulguer de secrets.

[Profil LinkedIn](https://fr.linkedin.com/in/vincent-scannella)

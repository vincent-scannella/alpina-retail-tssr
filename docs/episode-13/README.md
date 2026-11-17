# ALPINA RETAIL — Épisode 13 : bilan final et clôture de la V1

**Date de clôture documentaire : 17 novembre 2026**  
**Statut : V1 du laboratoire du siège de Grenoble clôturée sur le périmètre effectivement réalisé.**  
**Nature : portfolio technique personnel TSSR — entreprise et organisation fictives.**

> **Définition de « clôturée » :** les principaux scénarios prévus pour la maquette du **siège** ont été exécutés et décrits. Cela **ne signifie pas** que les quatre sites fictifs sont déployés, que la sécurité est complète, que tous les services Centreon sont sains ou que le laboratoire constitue une infrastructure de production. Des limites et des preuves visuelles à publier demeurent.

## 1. Présentation du projet

ALPINA RETAIL représente une PME fictive de prêt-à-porter et accessoires : **4 sites** et **75 collaborateurs simulés**. Le projet est né d'un cahier des charges portant sur les comptes et droits centralisés, l'accès aux ressources communes, les sauvegardes, la supervision, le réseau et le support.

**Périmètre réellement déployé :** un laboratoire VMware Workstation sur un ordinateur disposant de **16 Go de RAM**, limité au siège de Grenoble. Les boutiques, les VPN intersites et les 75 postes ne sont pas déployés.

### Architecture du laboratoire V1

```text
                        Réseau VMware NAT / Internet
                                   |
                             pfSense (WAN)
                                   |
                         LAN 10.10.10.0/24 — VMnet1
                                   |
                +------------------+-------------------+
                |                  |                   |
       pfSense (LAN)          DC1-GRE-SIEGE       PC-TEST-GRE
         10.10.10.1             10.10.10.10        10.10.10.100*
       Passerelle/NAT        Windows Server 2025    Windows 11
                            AD DS/DNS/DHCP           |
                |                  |                  |
          FS1-GRE-SIEGE      CENTREON-GRE-SIEGE  GLPI-GRE-SIEGE
           10.10.10.30         10.10.10.40        10.10.10.50
          Debian 12/SMB       Debian 13/CMA       Debian 13/LAMP
```

`*` Adresse DHCP observée sur PC-TEST-GRE. La topologie est **logique** : toutes les machines du LAN sont reliées à VMnet1, et non chaînées physiquement. Ne pas déduire de la position du dessin l'état actuel de chaque VM : elles ne tournent pas nécessairement simultanément.

| Équipement réel | Rôle mis en œuvre | Preuve principale |
|---|---|---|
| pfSense — `10.10.10.1` | Passerelle, NAT/PAT et filtrage | [Épisode 03](../episode-03/README.md), [06](../episode-06/README.md) |
| DC1-GRE-SIEGE — `10.10.10.10` | AD DS, DNS, DHCP, GPO | [Épisode 04](../episode-04/README.md), [08](../episode-08/README.md) |
| PC-TEST-GRE — DHCP `10.10.10.100` observé | Poste client Windows 11, tests AD/GPO/partage | [Épisode 04](../episode-04/README.md), [08](../episode-08/README.md) |
| FS1-GRE-SIEGE — `10.10.10.30` | Debian 12, Samba, Winbind, SSH, sauvegardes | [Épisode 05](../episode-05/README.md), [07](../episode-07/README.md) |
| CENTREON-GRE-SIEGE — `10.10.10.40` | Supervision ICMP et Windows CMA | [Épisode 10](../episode-10/README.md) |
| GLPI-GRE-SIEGE — `10.10.10.50` | Debian 13, Apache, PHP, MariaDB, Helpdesk | [Épisode 12](../episode-12/README.md) |

## 2. Réalisations et validations

### Réseau et sécurité

- Réseau du laboratoire, pfSense LAN/WAN, connectivité IPv4 et NAT/PAT vérifiés.
- Règles de filtrage et diagnostic DNS documentés ; un incident de résolution DNS externe a été corrigé en configurant un redirecteur pfSense.
- Renforcement partiel de la sécurité : règles pfSense, pare-feu du domaine Windows, politique de mots de passe AD, SSH par clé ED25519 et partage Samba chiffré en SMB3.

### Windows Server et Active Directory

- Déploiement de Windows Server 2025 et du domaine `ironman.test`.
- Contrôles AD DS, DNS, DHCP, découverte du DC, canal sécurisé du poste Windows 11 et application des GPO documentés.
- Déploiement de la GPO du lecteur réseau **P:** ciblant le groupe `GG_FS1_COMMUN_RW`, avec écriture sur le partage Linux confirmée depuis le client.

### Linux, fichiers et sauvegardes

- Installation de FS1 Debian 12 ; intégration au domaine via Samba/Winbind et résolution des utilisateurs/groupes AD.
- Partage `COMMUN` accessible en lecture/écriture ; autorisations Linux et refus d'un compte non autorisé effectivement observés.
- Sauvegarde `tar.gz` et restauration de données validées manuellement, montage du disque de sauvegarde par UUID contrôlé, archives transférées vers DC1 avec comparaison SHA-256.
- Scripts Bash de sauvegarde/surveillance et tâches `cron` configurés ; la fiabilité d'une exécution automatique **sur une durée prolongée** n'a pas été démontrée.

### Supervision Centreon

- Collecteur Centreon sous Debian 13 opérationnel ; disponibilité **ICMP** validée pour pfSense et DC1.
- Agent **Centreon Monitoring Agent** installé sur DC1. Après diagnostic du TLS et du filtrage stockage, services **CPU**, **MEMORY**, **DISK-C** et **ICMP** de DC1 en état **OK**.
- Tableau de bord « **ALPINA RETAIL | Supervision du siège — Grenoble** » sauvegardé avec trois jauges Windows et la disponibilité des trois équipements.
- **Limite conservée :** au dernier relevé, `Centreon-central` possède **6 contrôles CRITICAL et 8 UNKNOWN**. Ils sont documentés, mais **pas corrigés**.

### Support utilisateurs — GLPI

- Création d'une VM dédiée Debian 13 (2 vCPU, 2 Go RAM, 40 Go), avec IP statique `10.10.10.50/24`, DNS DC1 et accès via `PC-TEST-GRE`.
- Installation et validation de GLPI **12.0.2** sous Apache, PHP 8.4 et MariaDB (`glpidb`, utilisateur SQL dédié).
- Sécurisation initiale : changement du mot de passe `glpi`, désactivation de `tech`, `normal` et `post-only`, suppression du script `install.php`.
- Comptes GLPI locaux **`camille.martin`** (Self-Service) et **`support.alpina`** (Technicien) créés et testés. **Pas de synchronisation AD/LDAP.**

**Ticket n°1 — « Accès impossible au lecteur réseau COMMUN » :** réellement ouvert depuis l'interface Self-Service, affecté au technicien, passé « En cours », accompagné d'une tâche de diagnostic puis d'une solution, approuvé par la demandeuse et affiché au statut **Clos** le **17/11/2026 à 10:04:55**.

**Distinction essentielle :** les opérations *dans GLPI* ont réellement été testées ; le problème de permissions AD/Samba et sa correction constituent un **scénario fictif**. Aucun défaut du lecteur P: n'a été reproduit ni réparé à l'occasion de ce ticket. Voir les [preuves détaillées de l'épisode 12](../episode-12/README.md).

## 3. Problèmes rencontrés et méthode de dépannage

| Incident / difficulté | Méthode appliquée | Issue observée |
|---|---|---|
| DNS externe sur les VM du laboratoire | Contrôles de résolution et configuration du redirecteur pfSense | Résolution interne/externe rétablie sur DC1 et PC-TEST |
| Accès au partage `COMMUN` | Contrôle de Winbind, des groupes AD, des permissions Samba et tests depuis Windows | Lecture/écriture vérifiées ; accès d'un compte non autorisé refusé |
| Deux plugins Centreon absents | Vérification des chemins et paquets APT ; installation des plugins manquants | Exécution des plugins rétablie ; autres alertes distinctes conservées |
| Certificat / connexion CMA Windows | Vérification des erreurs TLS, de la connexion au collecteur et des contrôles applicatifs | Connexion CMA et métriques Windows validées |
| Disque C: `No storage found` | Revue des filtres de stockage, export et vérification forcée | Service `DISK-C` OK ; graphe de capacité visible |
| GLPI inaccessible depuis le PC hôte VMware | Test TCP 80 depuis l'hôte, puis test depuis le client du LAN virtuel | **PC-TEST-GRE accède à GLPI** ; accès depuis l'hôte **non résolu** |

Ce tableau reprend des diagnostics et résultats déjà documentés dans les épisodes ; il ne décrit pas des tests supplémentaires exécutés au moment de la clôture.

## 4. Compétences TSSR illustrées

| Compétence mise en pratique | Exemple vérifiable dans le dépôt |
|---|---|
| Installer et administrer des services Windows | AD DS, DNS, DHCP, GPO, partages et comptes |
| Exploiter un environnement Linux | Debian, Samba, Winbind, SSH, sauvegarde `tar`, `cron` |
| Diagnostiquer des problèmes réseau | NAT, DNS, DHCP, ping, contrôles ciblés pfSense |
| Mettre en œuvre des contrôles de sécurité | ACL/groupes AD, SMB3 chiffré, SSH renforcé, filtrage |
| Superviser des équipements | Centreon, ICMP et métriques Windows via CMA |
| Gérer un incident de support | GLPI : utilisateur Self-Service, attribution technicien, solution, approbation et clôture |
| Documenter les interventions | Commandes, résultats, incidents, limites et bilans par épisode |

**Portée :** ces travaux mettent en pratique des compétences de technicien systèmes et réseaux. Ils ne constituent pas une certification officielle de chaque compétence, ni une démonstration complète de l'administration d'infrastructures sécurisées (AIS).

## 5. Limites connues au jour de clôture

| Sujet | Situation exacte | Priorité si reprise |
|---|---|---|
| Centreon-central | 6 contrôles critiques et 8 inconnus au dernier relevé (processus, swap, MariaDB, broker) | Haute |
| GLPI | Accès HTTP sur LAN virtuel ; HTTPS et 2FA non validés | Haute avant toute exposition externe |
| Sauvegardes | Restauration testée ; supervision de l'exécution cron sur la durée et copie hors hôte à démontrer | Haute si exploitation durable |
| Captures | Plusieurs preuves authentiques présentes dans la conversation, **pas toutes publiées dans GitHub**, notamment Centreon et GLPI | Moyenne pour le portfolio |
| GLPI | LDAP/AD, inventaire automatisé, notification courriel et sauvegarde propre de la base non testés | Fonctionnalités futures |
| FS1/Centreon | **Épisode 11 simulé, non déployé** | Facultative |
| Réseau | VPN et boutiques non déployés ; filtrage IPv4 restrictif non achevé | Hors périmètre V1 |
| Tests complémentaires | Contre-test GPO hors groupe et panne AD/Samba du ticket GLPI non reproduite | Facultatifs |
| Accès GLPI depuis l'hôte | Test TCP 80 négatif ; fonctionnement depuis PC-TEST-GRE confirmé | Diagnostic ultérieur |

**Aucune de ces limites n'est masquée ou déclarée corrigée.** Le projet clôture son **périmètre pédagogique V1**, pas l'ensemble des objectifs possibles.

## 6. Bilan et décision de clôture

**Ce que la V1 démontre effectivement :** conception et mise en œuvre progressive d'un laboratoire du siège réunissant des services Windows et Linux, du réseau, des sauvegardes, de la supervision et un véritable cycle de ticket GLPI.

**Ce qu'elle ne démontre pas :** exploitation d'une infrastructure multisite complète, résolution effective de l'incident fictif du lecteur réseau, disponibilité continue de tous les composants, sécurité de niveau production ou suppression des alertes Centreon.

**Décision au 17 novembre 2026 :** la **V1 est clôturée comme projet de laboratoire TSSR** ; les interventions non réalisées sont conservées dans le [suivi des objectifs](../suivi/objectifs.md). Tout travail supplémentaire pourra être documenté dans une évolution ultérieure, sans réécrire les validations historiques.

### Présentation courte pour un entretien

> « J'ai conçu ALPINA RETAIL, un laboratoire informatique basé sur une PME fictive. Sur le siège de Grenoble, j'ai déployé un réseau avec pfSense, un serveur Windows avec Active Directory, DNS, DHCP et GPO, ainsi qu'un serveur de fichiers Linux Samba. J'ai testé les droits d'accès, une sauvegarde et une restauration, puis ajouté Centreon pour la supervision. Enfin, j'ai installé GLPI et validé tout le cycle d'un ticket, depuis la demande d'un utilisateur jusqu'à sa clôture. J'ai documenté les tests et les incidents sur GitHub, en distinguant ce qui fonctionne, ce qui reste à corriger et ce qui est simulé. »

---

[Accueil du projet](../../README.md) · [Épisode 12 — GLPI](../episode-12/README.md) · [Historique des objectifs](../suivi/objectifs.md)

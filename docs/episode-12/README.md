# ALPINA RETAIL — Épisode 12 : GLPI et traitement d'un ticket Helpdesk

**Date de réalisation : 17 novembre 2026**  
**Statut : installation et cycle GLPI validés ; incident métier simulé, sans correction réelle dans Active Directory.**

> ALPINA RETAIL représente une entreprise fictive. La machine virtuelle GLPI, l'application web, les comptes de test et le ticket n°1 ont bien été créés et utilisés dans le laboratoire. Le refus d'accès au partage COMMUN et sa cause sont des hypothèses de simulation : aucune panne sur le partage n'a été reproduite ou réparée pendant cette séance.

## 1. Besoin métier

Mettre à disposition des utilisateurs du siège de Grenoble une plateforme Helpdesk permettant de déclarer un incident, l'attribuer à un technicien, consigner les actions, proposer une solution et faire approuver la clôture par le demandeur.

La supervision Centreon (épisode 10) concerne la surveillance technique des équipements ; GLPI concerne la gestion du support. **Aucune intégration automatique Centreon–GLPI n'a été réalisée.**

## 2. Architecture réellement déployée

| Composant | Configuration utilisée |
|---|---|
| Hyperviseur | VMware Workstation 17 |
| VM | `GLPI-GRE-SIEGE` |
| Système | Debian 13, installation serveur sans interface graphique |
| Ressources VM | 2 vCPU, 2 Go RAM, disque virtuel SCSI 40 Go |
| Réseau | VMware `VMnet1`, carte `ens33` |
| Adresse | `10.10.10.50/24` (statique) |
| Passerelle | pfSense LAN `10.10.10.1` |
| DNS | `10.10.10.10` (DC1 Windows Server / domaine `ironman.test`) |
| Nom système | `glpi-gre-siege.ironman.test` |
| Application | GLPI 12.0.2, archive officielle GitHub |
| Serveur web | Apache 2, racine `/var/www/glpi/public` |
| PHP | PHP 8.4 avec extensions installées |
| Base de données | MariaDB, base `glpidb`, compte applicatif `glpiuser@localhost` |
| Accès testé | `http://10.10.10.50` depuis `PC-TEST-GRE` sur VMnet1 |

**Limite :** l'accès est actuellement en HTTP sur le laboratoire isolé, **sans HTTPS** ; la sécurisation TLS serait indispensable avant toute exposition hors de ce réseau de test. L'intégration de GLPI à LDAP/Active Directory et l'inventaire automatisé ne sont **pas configurés**.

## 3. Installation et contrôles réalisés

### 3.1. Debian et connectivité

- Installation de Debian 13 avec **serveur SSH** et **utilitaires usuels**, sans environnement graphique.
- Adresse `10.10.10.50/24` visible dans `ip -br addr` sur `ens33`.
- Réponses aux tests de ping de la passerelle `10.10.10.1` et de l'adresse externe `1.1.1.1`.
- Résolution DNS externe confirmée avec `getent hosts debian.org`.
- Accès SSH au serveur depuis le laboratoire, puis mises à jour APT.

### 3.2. Serveur applicatif et base

- Installation puis activation d'Apache ; `systemctl is-active apache2` a retourné `active`.
- Installation de PHP 8.4, de l'extension Apache PHP et des extensions nécessaires (notamment mysql, curl, gd, intl, mbstring, xml, zip, bz2, bcmath, ldap, apcu).
- Installation et démarrage de MariaDB ; connexion locale administrateur vérifiée avec `mariadb -e "SELECT VERSION();"`.
- Création de `glpidb` avec l'encodage `utf8mb4` et création du compte dédié `glpiuser@localhost`, autorisé sur cette seule base.
- Vérification réussie : `mariadb -u glpiuser -p glpidb -e "SELECT DATABASE();"` retourne `glpidb`.
- Déploiement de l'archive officielle `glpi-12.0.2.tgz` dans `/var/www/glpi` ; répertoire `/var/www/glpi/public` confirmé.
- Propriété `www-data` appliquée aux répertoires `config` et `files` ; site Apache avec `DocumentRoot /var/www/glpi/public`, réécriture activée et site Apache par défaut désactivé.
- `apache2ctl configtest` : `Syntax OK` ; accès GLPI dans le navigateur confirmé.

### 3.3. Assistant et configuration initiale

- Connexion MariaDB depuis l'assistant GLPI **réussie** ; base existante `glpidb` sélectionnée.
- Authentification sur l'interface GLPI avec le compte initial `glpi`, affichage du profil **Super-Admin**.
- Mot de passe par défaut du compte administrateur **modifié**.
- Fichier `/var/www/glpi/install/install.php` **supprimé**, puis absence vérifiée.
- Comptes prédéfinis `tech`, `normal` et `post-only` **désactivés**.
- Comptes locaux GLPI créés : `support.alpina` (profil **Technicien**) et `camille.martin` (profil **Self-Service**). Ces comptes **ne sont pas des comptes AD** et la synchronisation LDAP n'a pas été testée.
- Doublon d'habilitation Self-Service sur `camille.martin` détecté puis supprimé.

**Limites de sécurité :** le compte administrateur initial `glpi` subsiste avec un mot de passe changé ; l'authentification multifacteur, les notifications et l'HTTPS ne sont pas validés. Une alerte GLPI concernant la configuration des fuseaux horaires a également été visible et n'a pas fait l'objet d'une correction vérifiée.

## 4. Mise en situation — Ticket n°1 (cycle réel dans GLPI)

### Scénario fictif

Une collaboratrice du siège, **Camille Martin**, signale qu'elle ne peut plus ouvrir le lecteur réseau **P:** pointant vers le partage Samba **COMMUN** du serveur de fichiers FS1. Elle décrit un message « Accès refusé ». Il s'agit d'un **incident imaginé** pour tester le processus d'assistance, pas d'un défaut reproduit sur PC-TEST-GRE.

### Déroulement vérifié dans GLPI

| Étape | Action effectivement réalisée dans GLPI | Preuve observée |
|---|---|---|
| Déclaration | `camille.martin` connectée via Self-Service, formulaire « Signaler un incident » rempli | Ticket **n°1**, intitulé « Accès impossible au lecteur réseau COMMUN » |
| Qualification | Type **Incident**, urgence et priorité **Moyenne**, demandeur Camille Martin | Capture fiche du ticket |
| Attribution | Administrateur affecte le ticket à `support.alpina` | Champ « Attribué à : Support Informatique » enregistré |
| Prise en charge | Connexion avec `support.alpina` et sélection du profil **Technicien** | Ticket n°1 visible dans « Tickets à traiter » |
| Suivi | Statut **En cours (Attribué)** et tâche de diagnostic créée | Tâche décrivant vérifications AD/Samba, initialement « À faire » |
| Proposition | Ajout d'une **solution simulée** | Ticket passe à **Résolu**, date de résolution affichée |
| Acceptation | `camille.martin` approuve la solution avec un commentaire explicitement fictif | Mention « Accepté le 2026-11-17 10:04 par Martin Camille » |
| Clôture | Après approbation, le ticket apparaît en statut **Clos** | Champ « Date de fermeture : 2026-11-17 10:04:55 » |

**Chronologie :** création du ticket à **09:45:12** et clôture à **10:04:55**, le **17/11/2026**, selon l'interface GLPI du laboratoire.

### Diagnostic et correction : uniquement proposés

Le scénario retient l'hypothèse d'une **absence d'appartenance au groupe Active Directory `GG_FS1_COMMUN_RW`**. La démarche technique proposée est de :

1. Vérifier le compte utilisateur et son appartenance au groupe AD.
2. Contrôler les permissions Samba du partage `COMMUN` et les droits sur FS1.
3. Ajouter au groupe autorisé **uniquement si l'absence est réellement confirmée**.
4. Actualiser la session et tester l'accès au lecteur P: depuis un poste Windows.
5. Confirmer la lecture d'un fichier avant une résolution effective.

**Ces commandes et vérifications n'ont pas été exécutées au cours de l'épisode 12.** La tâche est une documentation pédagogique, et non une preuve d'intervention sur Active Directory. La solution a été approuvée pour **tester le circuit GLPI**, non pour attester d'un rétablissement du partage réseau.

## 5. Résultats et limites

| Critère | État |
|---|---|
| VM Debian 13, réseau, SSH, Apache, PHP et MariaDB | **Validé dans le laboratoire** |
| GLPI 12.0.2 accessible depuis `PC-TEST-GRE` | **Validé** |
| Connexion GLPI à la base `glpidb` | **Validée** |
| Compte administrateur initial sécurisé, comptes de démonstration désactivés, script d'installation supprimé | **Validé pour les actions décrites** |
| Ticket Helpdesk n°1, affectation, solution, approbation et clôture | **Validé** |
| Panne Samba/AD effectivement reproduite et réparée | **Non réalisée — scénario fictif** |
| HTTPS, 2FA, LDAP/AD, inventaire automatisé et notifications | **Non validés** |
| Accessibilité GLPI depuis le PC hôte VMware | **Échec de connexion TCP 80 observé** ; accès via PC-TEST-GRE confirmé |
| Captures authentiques déposées sur GitHub | **À faire** ; captures fournies dans la conversation |

## 6. Bilan de l'épisode

**La chaîne de support GLPI a réellement fonctionné de bout en bout**, du ticket ouvert par un utilisateur Self-Service à sa clôture après approbation. Le diagnostic de droits AD/Samba reste un exemple pédagogique, sans panne réelle reproduite.

Cette réalisation complète l'administration Windows, Linux, réseau, sauvegarde et supervision déjà documentée. La première version du laboratoire peut désormais être évaluée pour sa clôture documentaire, en conservant les limites techniques connues.

---

[Retour au projet](../../README.md) · [Épisode 10 — Centreon](../episode-10/README.md) · [Épisode 11 — simulation FS1/Centreon](../episode-11/README.md)

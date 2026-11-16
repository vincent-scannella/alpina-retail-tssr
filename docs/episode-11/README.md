# ALPINA RETAIL — Épisode 11 : supervision FS1 (étude de cas simulée)

**Statut : scénario technique documenté, non exécuté dans Centreon.**  
**Périmètre :** laboratoire du siège fictif de Grenoble.  
**Date de rédaction :** 16 novembre 2026.

> **Transparence :** le serveur FS1 existe réellement dans le laboratoire et ses fonctions Samba/Winbind/SSH ont été testées lors des épisodes précédents. En revanche, les contrôles Centreon CPU, RAM, disque et ICMP présentés ci-dessous sont **une procédure proposée**, pas des opérations effectuées ou des résultats mesurés. Aucune capture ni état `OK` n'est revendiqué pour cette supervision.

## 1. Besoin

Le serveur `FS1-GRE-SIEGE` héberge le partage Samba `COMMUN` utilisé par les postes du domaine `ironman.test`. Une panne réseau, une saturation du disque ou une pression mémoire pourrait rendre les fichiers indisponibles.

L'objectif de supervision est de détecter ces situations depuis le collecteur `Central` avant qu'elles n'affectent les utilisateurs.

## 2. Architecture retenue pour le scénario

| Composant | Rôle | Adresse / état |
|---|---|---|
| `FS1-GRE-SIEGE` | Debian 12, Samba, Winbind, SSH | `10.10.10.30/24` — serveur et partage déjà testés |
| `CENTREON-GRE-SIEGE` | Supervision centralisée, collecteur `Central` | `10.10.10.40` — opérationnel |
| Protocole prévu | SNMPv3 (`authPriv`) pour CPU, RAM et disque | **Non configuré sur FS1 dans ce scénario** |
| Disponibilité prévue | ICMP | **Non créée dans Centreon pour FS1** |

La préférence va à **SNMPv3**, avec authentification et chiffrement, plutôt qu'à une communauté SNMPv2c en clair. L'accès UDP/161 devrait être limité à l'adresse du collecteur par filtrage sur le serveur. Sur un même LAN, ne pas supposer que le trafic passe par pfSense.

## 3. Mise en œuvre proposée — non réalisée

### 3.1. Préparer FS1

1. Vérifier l'adresse IP et la connectivité entre FS1 et Centreon.
2. Installer les composants SNMP de Debian : `snmpd` et les outils de vérification nécessaires.
3. Créer un utilisateur SNMPv3 **en lecture seule** avec niveau `authPriv` (secrets conservés hors dépôt).
4. Limiter l'écoute de SNMP à l'interface appropriée et les connexions UDP/161 au seul collecteur `10.10.10.40`.
5. Contrôler la configuration et le service :

```bash
ip -br addr
systemctl status snmpd --no-pager
ss -lunp | grep ':161'
```

**Points de vigilance :** ne jamais publier les secrets SNMPv3 dans GitHub ; vérifier les droits et la syntaxe de `snmpd.conf` avant de redémarrer le démon. Une connexion réseau correcte ne prouve pas que SNMP répond.

### 3.2. Ajouter l'hôte dans Centreon

Configuration envisagée dans `Configuration → Hôtes → Hôtes` :

| Champ | Valeur de scénario |
|---|---|
| Nom | `FS1-GRE-SIEGE` |
| Alias | `Serveur de fichiers Debian 12 — Grenoble` |
| Adresse | `10.10.10.30` |
| Collecteur | `Central` |
| Modèle envisagé | `OS-Linux-SNMP-custom` (à vérifier dans l'instance) |
| Identifiants SNMPv3 | Configurés dans Centreon, hors dépôt |

Le connecteur Linux SNMP était présent dans l'interface du laboratoire. Cela **ne valide pas** la configuration future de FS1.

### 3.3. Associer les contrôles

Services prévus, dont les noms et filtres exacts restent à ajuster selon les modèles disponibles :

| Contrôle | Problème détecté | Validation attendue |
|---|---|---|
| ICMP | FS1 injoignable | État `UP`, service `OK` |
| CPU | Saturation processeur | Utilisation moyenne en % |
| Memory | Pression sur la RAM | Mémoire utilisée et disponible |
| Disk-/ | Saturation du système de fichiers `/` | Espace occupé et disponible |
| Samba (option ultérieure) | Indisponibilité du service métier | Contrôle distinct de la simple disponibilité machine |

**Attention :** un `ping` `OK` ne garantit pas que le partage `COMMUN` fonctionne. Le service Samba et l'accès depuis Windows nécessitent des vérifications spécifiques.

## 4. Procédure de validation prévue

La réussite ne doit être annoncée **qu'après exécution** des vérifications suivantes :

1. Tester depuis Centreon la résolution réseau de `10.10.10.30` et la réponse SNMPv3 avec les identifiants provisionnés, sans afficher les secrets.
2. Exporter puis recharger la configuration du collecteur `Central`.
3. Dans `Supervision → Statut des ressources`, filtrer sur `FS1-GRE-SIEGE`.
4. Confirmer un résultat réellement retourné pour chaque contrôle ; relever sa date, son état et ses données de performance.
5. Contrôler qu'un graphique CPU, RAM et disque est alimenté et qu'il correspond à la bonne ressource.
6. Réaliser un test d'alerte non destructif si possible, puis vérifier le retour à `OK`.
7. Déposer des captures authentiques après contrôle qu'elles ne contiennent ni identifiants ni secrets.

### Critères d'acceptation

| Critère | État |
|---|---|
| FS1 déjà présent et opérationnel pour Samba/AD/SSH | **Validé dans les épisodes 05–09** |
| Configuration SNMPv3 de FS1 | **À réaliser** |
| Hôte FS1 ajouté à Centreon | **À réaliser** |
| Contrôle ICMP et contrôles CPU/RAM/disque | **À réaliser** |
| Mesures et graphes Centreon authentifiés | **Non disponibles** |
| Capture de preuve FS1 dans Centreon | **Non disponible** |

## 5. Dépannage envisagé

| Symptôme possible | Vérification à effectuer |
|---|---|
| `UNKNOWN` / délai SNMP expiré | Service `snmpd`, écoute UDP/161, filtrage local, IP source du collecteur |
| Échec d'authentification SNMPv3 | Utilisateur, niveau `authPriv`, algorithmes et secrets, sans les exposer |
| `No storage found` | Points de montage réels (`df -hT`) et filtre du service |
| Service `PENDING` | Export, affectation au collecteur, exécution d'un contrôle forcé |
| Hôte `UP` mais partage inaccessible | Diagnostic séparé de `smbd`, Winbind, ACL et accès SMB depuis Windows |

## 6. Conclusion et état réel

Cette étude de cas fournit **une méthode reproductible de supervision Linux**, mais pas un déploiement réalisé. Elle complète les épisodes déjà validés : le serveur FS1 et son partage ont été testés, tandis que Centreon supervise effectivement DC1, pfSense et ses propres métriques. **L'intégration de FS1 à Centreon reste facultative et non effectuée.**

---

[Retour au projet](../../README.md) · [Épisode 10 — Centreon : contrôles réels](../episode-10/README.md) · [Épisode 05 — FS1 : mise en œuvre réelle](../episode-05/README.md)

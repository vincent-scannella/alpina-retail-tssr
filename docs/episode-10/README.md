# ALPINA RETAIL — Épisode 10 : Centreon et supervision ICMP de pfSense

**Date de validation : 11 novembre 2026**  
**Statut : partiellement validé** — pfSense est supervisé par ICMP ; les autres contrôles Centreon restent à fiabiliser.

## 1. Objectif

Passer de la surveillance légère Bash (épisode 09) à une supervision centralisée. Le premier équipement supervisé est le pare-feu du siège fictif Grenoble, `PFSENSE-GRE-SIEGE` (`10.10.10.1`), depuis la VM Centreon (`10.10.10.40`).

**Périmètre :** laboratoire informatique personnel d'ALPINA RETAIL ; l'entreprise, ses employés et ses boutiques sont simulés.

## 2. Configuration vérifiée

| Élément | Paramètre observé |
|---|---|
| Collecteur | `Central` |
| Hôte supervisé | `PFSENSE-GRE-SIEGE` |
| Adresse de l'hôte | `10.10.10.1` |
| Service ajouté | `ICMP` |
| Modèle du service | `Base-Ping-LAN-custom` |
| Modèle parent | `Base-Ping-LAN` |
| Commande héritée | `base_centreon_ping` |
| Nombre de paquets | 5 |
| Seuil WARNING du modèle | `200,20%` |
| Seuil CRITICAL du modèle | `400,50%` |

La commande de vérification peut rester vide au niveau du service car le modèle personnalisé hérite de sa commande via `Base-Ping-LAN`. L'écran du modèle parent confirme explicitement `base_centreon_ping`.

**Export Centreon :** génération des fichiers **OK**, déplacement des fichiers **OK**, rechargement de l'ordonnanceur **OK** (progression 100 %). L'export a été réalisé après création du service.

## 3. Incident rencontré et diagnostic

La page « Statut des ressources » affichait de nombreux services `UNKNOWN` avec le message `Execute command failed`. Le journal `/var/log/centreon-engine/centengine.log` indiquait notamment :

```text
Service check command execution failed: No such file or directory
```

Deux chemins de plugins échouaient :

- `/usr/lib/centreon/plugins/centreon_linux_snmp.pl`
- `/usr/lib/centreon/plugins/centreon_mysql.pl`

Une commande `ls -l` a confirmé leur absence. Le serveur utilise Debian 13 et le dépôt Centreon APT `trixie/main`. La commande `apt-cache policy` a montré les deux paquets disponibles mais non installés :

- `centreon-plugin-operatingsystems-linux-snmp`
- `centreon-plugin-applications-databases-mysql`

Après installation par `apt install`, les deux fichiers ont été revérifiés par `ls -l` : ils sont présents avec des droits d'exécution. Les contrôles concernés sont alors passés d'erreurs de démarrage des commandes à des retours fonctionnels, dont plusieurs états `CRITICAL`.

**Limites non résolues :** plusieurs services locaux indiquaient « Number of current processes running: 0 » et le contrôle MySQL `Connection-Time` affichait un refus d'accès pour `centreon-engine@localhost`. Cela nécessite un diagnostic distinct ; ce n'est pas une preuve que les processus sont réellement arrêtés.

## 4. Test fonctionnel de pfSense — VALIDÉ

Capture observée dans **Supervision → Statut des ressources**, filtre `PFSENSE-GRE-SIEGE`, le **11/11/2026 à 10:16** :

| Ressource | Statut | Dernier message affiché |
|---|---|---|
| Hôte `PFSENSE-GRE-SIEGE` | **Disponible / UP** | `OK - 10.10.10.1 rta 3.666ms lost 0%` |
| Service `ICMP` | **OK** | `OK - 10.10.10.1 rta 1.028ms lost 0%` |

**Conclusion limitée à ce contrôle :** le collecteur Centreon a réussi à vérifier la disponibilité réseau de pfSense avec **0 % de perte de paquets** lors de la dernière exécution affichée. Cela ne démontre pas à lui seul l'état du pare-feu, de ses interfaces ou de ses autres services.

> **Preuve visuelle :** la capture de la page de ressources a été fournie en conversation le 11/11/2026. **Elle reste à déposer dans le dépôt GitHub** pour rendre la validation directement consultable depuis cet épisode.

## 5. État d'avancement

- [x] Centreon accessible depuis le navigateur sur `10.10.10.40`.
- [x] Création de l'hôte `PFSENSE-GRE-SIEGE`.
- [x] Création et héritage vérifié du service ICMP.
- [x] Export/rechargement de la configuration réussi.
- [x] Absence de deux plugins diagnostiquée ; paquets installés et fichiers revérifiés.
- [x] Service ICMP **OK** et hôte pfSense **UP** observés.
- [ ] Ajouter la capture authentique du contrôle ICMP à ce dossier.
- [ ] Diagnostiquer les contrôles de processus remontant `CRITICAL` sur Centreon-central.
- [ ] Diagnostiquer l'accès MySQL de `Connection-Time`.
- [ ] Étendre progressivement la supervision à DC1 puis FS1, selon la disponibilité des VM et la RAM du laboratoire.

**État de preuve :** une disponibilité ICMP ponctuelle est validée, pas une supervision complète de l'infrastructure.

---

[Retour au journal du projet](../../README.md) · [Épisode précédent : supervision Bash](../episode-09/README.md)

## 6. Suivi complémentaire — 11 novembre 2026 (fin de séance)

Après la validation ICMP, les contrôles du serveur `Centreon-central` ont fait l'objet d'un diagnostic ciblé.

### CPU : contrôle fonctionnel

- Le service `snmpd` était actif, mais les outils `snmpget` et `snmpwalk` étaient initialement absents ; installation du paquet Debian `snmp`.
- Un `snmpget -v2c -c public localhost 1.3.6.1.2.1.1.1.0` retournait bien la description Linux.
- Une requête sur `1.3.6.1.2.1.25.3.3.1.2` ne fournissait pas de métrique CPU ; la configuration de `snmpd` limitait `public` à la vue `systemonly`.
- Le fichier `/etc/snmp/snmpd.conf` a été sauvegardé dans `/etc/snmp/snmpd.conf.bak` (présence et taille identique vérifiées). La ligne `rocommunity public default -V systemonly` a été remplacée par `rocommunity public 127.0.0.1 -V centreon`, puis `snmpd` redémarré.
- Après modification, les compteurs `1.3.6.1.4.1.2021.11` (UCD-SNMP) étaient accessibles.
- Test manuel du plugin Centreon avec `--mode=cpu --use-ucd` : `OK: CPU(s) average usage is 18.00 %`.
- **Capture de la page Centreon, 11/11/2026 à 10:51 : service `Cpu` de `Centreon-central` en état `OK`, utilisation moyenne `18.50 %`, 2 CPU détectés.**

**Point restant à confirmer :** la capture finale ne prouve pas comment l'option `--use-ucd` a été enregistrée dans la configuration Centreon. Vérifier ce réglage avant de considérer la correction persistante sur le long terme.

### Mémoire : contrôle non résolu

Sur la dernière capture de séance, le service `Memory` de `Centreon-central` affiche :

```text
UNKNOWN: SNMP GET Request: Can't get a single value.
```

Les contrôles `proc-broker-rrd` et `proc-broker-sql` sont `OK` ; ces états ne signifient pas que la supervision globale est réparée.

### Prochaine séance

1. Diagnostiquer la récupération des métriques RAM par le plugin Centreon et vérifier l'état `Memory`.
2. Tester les contrôles de stockage/disques du serveur Centreon.
3. Étendre la supervision CPU/RAM/disques aux autres machines actives (DC1, FS1, PC-TEST), selon leur disponibilité.
4. Construire un tableau de bord Centreon à partir des métriques et états effectivement validés.
5. Ajouter les captures authentiques des tests dans le dépôt après vérification de leur contenu et de l'absence de secrets.

**Fin de séance :** 11/11/2026. La collecte CPU et le contrôle ICMP pfSense fonctionnent ; la RAM demeure `UNKNOWN`.

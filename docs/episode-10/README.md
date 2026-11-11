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

# ALPINA RETAIL — Épisode 12 : GLPI et support utilisateurs

**Statut : prévu — GLPI n'est pas installé.**  
**Date de préparation : 16 novembre 2026.**

## Besoin métier

Mettre en place un service d'assistance pour les collaborateurs fictifs d'ALPINA RETAIL : incidents, demandes, affectation aux techniciens, résolutions et historique. Centreon détecte des anomalies techniques ; GLPI permettra de suivre leur traitement sous forme de tickets. **Aucune liaison Centreon–GLPI n'est actuellement configurée.**

## Architecture proposée (à confirmer)

- Une machine virtuelle distincte pour GLPI, afin de séparer son serveur web et sa base des composants Centreon.
- Une distribution Debian adaptée et un dimensionnement réaliste au regard des 16 Go de RAM du PC hôte. Démarrer uniquement les VM nécessaires aux tests.
- Serveur web Apache ou Nginx, PHP et MariaDB/MySQL compatibles avec la version GLPI choisie.
- Adresse IP, DNS et accès HTTPS à déterminer **avant** l'installation. Aucun nom ni adresse n'est réservé à ce stade.
- Comptes de démonstration fictifs ; pas de données personnelles réelles.

Documents de référence : [pré-requis officiels GLPI](https://glpi-install.readthedocs.io/fr/latest/prerequisites.html) et [installation officielle](https://glpi-install.readthedocs.io/fr/latest/install/).

## Étapes prévues

1. Vérifier l'espace disque, la RAM disponible et le réseau virtuel ; préparer la VM.
2. Installer Debian et vérifier SSH, IPv4, DNS et mises à jour.
3. Installer les dépendances : serveur web, PHP, base MariaDB.
4. Télécharger une version stable vérifiée de GLPI ; configurer sa racine web sécurisée et lancer l'installation.
5. Sécuriser les comptes initiaux, les permissions et l'accès HTTPS.
6. Créer les profils fictifs « Demandeur » et « Technicien ».
7. Tester un cycle complet : ouvrir un ticket, l'affecter, le résoudre et le clôturer.
8. Envisager ultérieurement l'inventaire et l'authentification AD/LDAP, sans annoncer ces fonctions comme opérationnelles sans test.
9. Documenter les résultats réels et déposer des captures sans secrets.

## Critères d'acceptation

| Vérification | Statut |
|---|---|
| VM et réseau | Non réalisé |
| Application GLPI accessible | Non réalisé |
| Base de données et installation fonctionnelles | Non réalisé |
| Ticket de test traité jusqu'à clôture | Non réalisé |
| Captures authentiques publiées | Non réalisé |

[Retour au journal du projet](../../README.md) · [Épisode 10 — Centreon](../episode-10/README.md)

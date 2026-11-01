# ALPINA RETAIL — Épisode 03 : Installation du pare-feu pfSense au siège de Grenoble

> **Date :** 1er novembre 2026  
> **Statut :** installation et configuration initiale réalisées ; tests IP et DNS réussis depuis pfSense. Validation depuis le LAN à poursuivre.  
> **Projet :** laboratoire personnel TSSR simulant une entreprise entièrement fictive.

## 1. Contexte et objectif

ALPINA RETAIL est une entreprise fictive de prêt-à-porter et d'accessoires, composée de 75 collaborateurs simulés sur quatre sites : un siège à Grenoble et trois boutiques.

Après l'organisation de l'entreprise (épisode 01) et la rédaction du cahier des charges informatique (épisode 02), cette étape marque le début du déploiement technique.

**Objectif :** installer un pare-feu au siège, séparer le réseau WAN du LAN et préparer le routage, le filtrage et les futurs VPN intersites.

Cet épisode concerne uniquement le pare-feu du siège. L'infrastructure multisite complète n'est pas encore déployée.

## 2. Environnement de laboratoire

| Élément | Configuration |
|---|---|
| Système hôte | Windows 11 |
| Hyperviseur | VMware Workstation Pro 17 |
| Mémoire physique de l'hôte | 16 Go |
| Machine virtuelle | pfSense-GRE-SIEGE |
| Système installé | pfSense Community Edition 2.9.0 |
| Processeur | 2 vCPU |
| Mémoire virtuelle | 2 Go |
| Disque virtuel | 20 Go |
| Système de fichiers | ZFS |
| Partitionnement | GPT |
| Stockage ZFS | Stripe sur un seul disque, sans redondance |

Les ressources sont adaptées à un laboratoire personnel et ne constituent pas un dimensionnement de production pour 75 collaborateurs.

## 3. Architecture réseau

```text
              INTERNET
                 |
          PC hôte Windows
                 |
      VMnet8 — NAT VMware
          10.50.10.0/24
                 |
       WAN em0 — DHCP
        10.50.10.128/24
                 |
        pfSense-GRE-SIEGE
                 |
       LAN em1 — Statique
          10.10.10.1/24
                 |
       VMnet1 — Host-only
          10.10.10.0/24
                 |
       Futur client Windows
        (non encore installé)
```

### Configuration WAN

- Interface pfSense : `em0`
- Réseau VMware : `VMnet8`
- Mode : NAT
- Adressage : DHCP
- Adresse observée : `10.50.10.128/24`
- Serveur DHCP VMware : activé

L'adresse WAN est une adresse privée, attribuée dynamiquement. Elle peut changer lors d'un renouvellement DHCP.

### Configuration LAN

- Interface pfSense : `em1`
- Réseau VMware : `VMnet1`
- Mode : Host-only
- Réseau : `10.10.10.0/24`
- Passerelle prévue : `10.10.10.1`
- DHCP pfSense : désactivé
- DHCP VMware sur VMnet1 : désactivé et vérifié

Le service DHCP du LAN sera ultérieurement assuré par Windows Server, conformément au cahier des charges.

## 4. Installation et configuration réalisées

1. Préparation des réseaux virtuels VMware.
2. Configuration de VMnet8 en NAT avec DHCP VMware.
3. Configuration de VMnet1 en réseau interne isolé, sans DHCP VMware.
4. Création de la VM `pfSense-GRE-SIEGE`.
5. Attribution de 2 vCPU, 2 Go de RAM et 20 Go de stockage.
6. Installation de pfSense CE 2.9.0.
7. Attribution de `em0` au WAN et de `em1` au LAN.
8. Configuration du LAN en `10.10.10.1/24`.
9. Désactivation du DHCP pfSense sur le LAN.
10. Réalisation des tests de connectivité.
11. Arrêt propre de la VM après les vérifications.

## 5. Tests et résultats observés

| Vérification | Résultat |
|---|---|
| Démarrage de pfSense | Réussi |
| Détection des deux interfaces | Réussie |
| Obtention d'une adresse WAN DHCP | Réussie |
| Configuration du LAN statique | Réussie |
| Ping vers `8.8.8.8` depuis pfSense | Réussi |
| Ping vers `www.google.com` depuis pfSense | Réussi |
| Arrêt propre du système | Effectué |

### Interprétation technique

Le ping vers `8.8.8.8` confirme une connectivité IP sortante depuis pfSense vers cette destination.

Le ping vers `www.google.com` confirme également que la résolution DNS et la connectivité ICMP fonctionnaient au moment du test.

**Attention :** ces tests ont été exécutés depuis pfSense et ne démontrent pas encore qu'un poste du LAN peut accéder à Internet à travers le pare-feu.

Aucun temps de réponse, taux de perte ou nombre de paquets n'est présenté, car ces mesures n'ont pas été consignées.

## 6. Limites de la validation

Les éléments suivants ne sont pas encore validés :

- Connectivité IP depuis un poste client du LAN.
- Accès à l'interface Web d'administration de pfSense.
- Navigation HTTP/HTTPS depuis le LAN.
- Routage et traduction NAT du trafic provenant du LAN.
- Politique de filtrage et règles de pare-feu.
- Attribution DHCP par un futur serveur Windows.
- VPN IPsec entre le siège et les boutiques.
- Conservation de la configuration après redémarrage.

Aucun test non réalisé n'est présenté comme réussi.

## 7. Prochaines étapes

- [ ] Redémarrer pfSense et vérifier la persistance des paramètres.
- [ ] Créer un poste client Windows connecté à VMnet1.
- [ ] Configurer temporairement son adressage IPv4 statique.
- [ ] Tester la communication avec `10.10.10.1`.
- [ ] Accéder à l'interface Web de pfSense.
- [ ] Vérifier la passerelle, la résolution DNS et l'accès Internet depuis le LAN.
- [ ] Installer Windows Server et préparer les services AD DS, DNS et DHCP.
- [ ] Réaliser des tests de filtrage et des scénarios de dépannage.
- [ ] Préparer les futurs VPN IPsec intersites.
- [ ] Ajouter des captures et preuves techniques après vérification et anonymisation.

## 8. Compétences TSSR mobilisées

- Virtualisation avec VMware Workstation.
- Configuration de réseaux virtuels NAT et Host-only.
- Installation d'un système de pare-feu.
- Adressage IPv4 statique et dynamique.
- Identification des interfaces WAN et LAN.
- Diagnostic de connectivité IP avec ICMP.
- Vérification de la résolution DNS.
- Documentation technique et traçabilité des tests.

## 9. Références du projet

- [Épisode 02 — Cahier des charges informatique](../episode-02/README.md)
- [Retour à la présentation générale](../../README.md)

---

**Auteur :** Vincent Scannella — Technicien Supérieur Systèmes et Réseaux (TSSR).

**ALPINA RETAIL est une entreprise fictive. Ce laboratoire personnel a pour objectif la mise en pratique et la démonstration de compétences techniques.**

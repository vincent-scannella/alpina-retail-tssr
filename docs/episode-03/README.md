# ALPINA RETAIL — Épisode 03 : Installation du pare-feu pfSense au siège de Grenoble

> **Date :** 1er novembre 2026  
> **Statut :** installation, redémarrage et configuration initiale vérifiés ; tests IP et DNS réussis depuis pfSense **et depuis un poste Windows 11 sur le LAN**. Administration Web, HTTP/HTTPS et services avancés à vérifier.  
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
       PC-TEST-GRE — Windows 11 Pro
          10.10.10.20/24
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
11. Arrêt propre de la VM après les premières vérifications.
12. Redémarrage de pfSense et confirmation de la persistance des adresses WAN `10.50.10.128/24` (adresse observée lors du nouveau démarrage) et LAN `10.10.10.1/24`.
13. Installation de Windows 11 Professionnel sur `PC-TEST-GRE` (VMnet1, 2 vCPU, 4 Go de RAM, disque virtuel de 64 Go).
14. Création du compte local de laboratoire `tech.alpina`, sans divulgation du mot de passe.
15. Configuration IPv4 statique de `PC-TEST-GRE` : `10.10.10.20/24`, passerelle `10.10.10.1`, DNS `10.10.10.1`.
16. Vérification des communications LAN, WAN et DNS depuis Windows 11.

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
| Redémarrage et maintien des paramètres d'interface WAN/LAN | Réussi (adresses observées à nouveau dans la console) |
| Installation Windows 11 Pro sur `PC-TEST-GRE` | Réussie |
| Ping `10.10.10.1` depuis Windows 11 | **4 paquets envoyés, 4 reçus, 0 perdu (0 %) ; minimum 1 ms, maximum 6 ms, moyenne 2 ms** |
| Ping `8.8.8.8` depuis Windows 11 | **4 paquets envoyés, 4 reçus, 0 perdu (0 %) ; minimum 19 ms, maximum 20 ms, moyenne 19 ms** |
| `nslookup www.google.fr` depuis Windows 11 | **Réussi ; DNS interrogé : `pfSense.home.arpa` (`10.10.10.1`) ; réponses observées : `172.217.22.131` (IPv4) et `2a00:1450:4007:81b::2003` (IPv6)** |

### Interprétation technique

Le ping vers `8.8.8.8` confirme une connectivité IP sortante depuis pfSense vers cette destination.

Le ping vers `www.google.com` confirme également que la résolution DNS et la connectivité ICMP fonctionnaient au moment du test.

**Mise à jour après déploiement du poste client :** les tests précédemment limités à pfSense sont désormais complétés par des vérifications effectuées **depuis Windows 11 sur VMnet1**. Les deux séries de ping depuis Windows ont réussi avec 0 % de perte sur quatre requêtes chacune. Le test DNS montre que la requête adressée au résolveur pfSense (`10.10.10.1`) retourne des adresses IPv4 et IPv6 pour `www.google.fr`.

**Portée :** ces tests attestent l'accessibilité ICMP de la passerelle et d'une destination extérieure ainsi que la résolution DNS au moment des mesures. Ils ne constituent pas un test de navigation HTTP/HTTPS, un audit complet des règles du pare-feu ni une vérification indépendante de la traduction NAT.

Les durées et pertes chiffrées ci-dessus proviennent de la capture des sorties Windows fournie par l'auteur. Aucun secret n'est consigné.

## 6. Limites de la validation

Les éléments suivants ne sont pas encore validés :

- Accès à l'interface Web d'administration de pfSense.
- Navigation HTTP/HTTPS depuis le LAN.
- Vérification détaillée des règles de filtrage et de la traduction NAT (la connectivité ICMP externe est confirmée, mais aucun contrôle spécifique des états/NAT n'a été consigné).
- Attribution DHCP par un futur serveur Windows.
- VPN IPsec entre le siège et les boutiques.
- Persistance d'autres paramètres de configuration après redémarrage (la persistance des adresses WAN/LAN a été observée).

Aucun test non réalisé n'est présenté comme réussi.

## 7. Prochaines étapes

- [x] Redémarrer pfSense et vérifier la persistance de l'adressage WAN/LAN.
- [x] Créer un poste client Windows 11 sur VMnet1.
- [x] Configurer temporairement son adressage IPv4 statique (`10.10.10.20/24`).
- [x] Tester la communication avec `10.10.10.1`.
- [x] Vérifier la connectivité IP vers `8.8.8.8` et la résolution DNS depuis le LAN.
- [ ] Accéder à l'interface Web de pfSense sur `https://10.10.10.1`.
- [ ] Vérifier la navigation HTTP/HTTPS et, séparément, le comportement des règles/NAT depuis le LAN.
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
- Vérification de la résolution DNS avec `nslookup` depuis Windows 11.
- Vérification de la connectivité LAN et WAN depuis un client Windows avec `ping`, relevé du taux de perte et des latences.
- Validation du redémarrage et de la persistance de l'adressage des interfaces.
- Documentation technique et traçabilité des tests.

## 9. Références du projet

- [Épisode 02 — Cahier des charges informatique](../episode-02/README.md)
- [Retour à la présentation générale](../../README.md)

---

**Auteur :** Vincent Scannella — Technicien Supérieur Systèmes et Réseaux (TSSR).

**ALPINA RETAIL est une entreprise fictive. Ce laboratoire personnel a pour objectif la mise en pratique et la démonstration de compétences techniques.**

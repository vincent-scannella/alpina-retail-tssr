![Bannière ALPINA RETAIL](IMG_0869.png)

# ALPINA RETAIL — Laboratoire systèmes & réseaux

**Projet personnel TSSR · Infrastructure multisite fictive · Documentation technique et preuves de validation**

Je conçois, déploie et dépanne progressivement une infrastructure informatique inspirée des besoins d'une PME du prêt-à-porter. Le projet associe **architecture réseau, Windows Server, Active Directory, DNS, DHCP, pfSense, virtualisation et support utilisateurs**.

> **À propos du périmètre :** ALPINA RETAIL est une **entreprise entièrement fictive**. Les quatre sites et leurs 75 collaborateurs sont simulés ; seules certaines machines du **laboratoire du siège de Grenoble** sont réellement déployées. Chaque résultat annoncé comme validé renvoie à une manipulation documentée.

## Le projet en bref

| Entreprise simulée | Laboratoire personnel | Progression |
|---|---|---|
| **4 sites** · 75 collaborateurs fictifs | **Windows 11** · VMware Workstation · **16 Go de RAM sur l'hôte** | **Épisodes 00 à 04 documentés**, déploiement en cours |

**Ce qui est déjà vérifié :**

- **Réseau et sécurité :** pfSense CE 2.9.0 configuré ; LAN/WAN, accès Internet depuis Windows 11, NAT/PAT observé, filtrage ICMP ciblé testé puis retiré, sauvegarde de configuration chiffrée conservée hors GitHub.
- **Windows Server et AD DS :** installation de Windows Server 2025, création de la forêt `ironman.test`, promotion de `DC1-GRE-SIEGE`, tests `dcdiag` ciblés réussis, partages `SYSVOL` et `NETLOGON` publiés.
- **DNS et dépannage :** résolution des noms internes et externes ; diagnostic du message `Server: UnKnown`, création d'une zone inversée et d'un enregistrement PTR, contre-test réussi.
- **DHCP :** serveur autorisé dans Active Directory, étendue `DHCP-GRE-SIEGE` active, plage et options réseau contrôlées dans la console. **Aucun bail client n'a encore été validé.**

[**Voir les preuves pfSense — épisode 03**](docs/episode-03/README.md) · [**Voir les 23 captures Windows Server / DNS / DHCP — épisode 04**](docs/episode-04/README.md)

## Architecture actuelle du laboratoire

La topologie suivante décrit les composants **créés dans VMware**, et non les futurs réseaux de toutes les boutiques.

![Topologie réelle du laboratoire du siège de Grenoble : Internet, VMware NAT VMnet8, pfSense, VMnet1, DC1 Windows Server et PC-TEST-GRE](docs/topologie-laboratoire-siege.svg)

*Schéma de synthèse au 2 novembre 2026 — équipement du laboratoire réellement créé. Le DHCP Windows est configuré, mais **le bail client et la jonction au domaine ne sont pas encore testés**. [Ouvrir le schéma vectoriel en grand](docs/topologie-laboratoire-siege.svg).*

*L'adresse `10.10.10.20` est la configuration **statique utilisée lors des premiers tests** du poste client. Son passage en DHCP et l'obtention d'un bail réel restent à vérifier. Les trois VM ne sont pas nécessairement allumées simultanément, compte tenu des 16 Go de RAM disponibles.*

### Repères d'adressage du siège

| Composant | Configuration | État |
|---|---|---|
| pfSense LAN | `10.10.10.1/24` | Configuré et testé |
| DC1 — AD DS / DNS | `10.10.10.10/24` | Configuré et testé |
| PC-TEST-GRE | `10.10.10.20/24` (statique, tests initiaux) | Connectivité IP testée ; DHCP à tester |
| Étendue Windows DHCP | `10.10.10.100` → `10.10.10.199` | Créée et active ; aucun bail client validé |

**À distinguer :** la connexion entre les quatre sites, les VPN et les autres serveurs de l'architecture cible sont pour le moment des **éléments de conception**, pas un environnement multisite opérationnel.

## Journal de bord — choisir un épisode

| Épisode | Sujet | Livrables et validation |
|---|---|---|
| **00** | [Présentation du projet](#vue-densemble-de-lentreprise-fictive) | Contexte, sites et objectifs de la maquette |
| **01** | [Organisation et organigramme](docs/episode-01/README.md) | Répartition des 75 collaborateurs simulés, organigramme et [dossier PDF](docs/episode-01/Alpina_Retail_Organisation_Episode_01.pdf) |
| **02** | [Cahier des charges informatique](docs/episode-02/README.md) | Besoins métier, architecture cible, droits d'accès et limites du laboratoire |
| **03** | [Pare-feu pfSense et poste Windows 11](docs/episode-03/README.md) | Installation, adressage, NAT/PAT, filtrage ICMP, tests réseau et sauvegarde chiffrée |
| **04** | [Windows Server, AD DS, DNS et DHCP](docs/episode-04/README.md) | Déploiement de DC1, diagnostic DNS avant/après, contrôles AD et étendue DHCP ; tests clients en attente |

**Preuves visuelles :** [épisode 03 — 8 captures authentiques et 2 schémas pédagogiques](docs/episode-03/images/README.md) · [épisode 04 — 23 captures authentiques de Windows Server / AD DS / DNS / DHCP](docs/episode-04/images/README.md).

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
- [ ] Confirmer la durée du bail et l'attribution DHCP depuis `PC-TEST-GRE` (`ipconfig /all`).
- [ ] Joindre le poste Windows 11 au domaine, tester une connexion utilisateur et l'application des GPO.
- [ ] Poursuivre la conception et le déploiement progressif des autres serveurs, des sauvegardes, de la supervision et des futurs VPN intersites.

## À propos

**Auteur : Vincent Scannella — Technicien Supérieur Systèmes et Réseaux (TSSR).**

Ce dépôt est un **portfolio de mise en pratique** destiné à montrer une méthode de travail : installer, vérifier, diagnostiquer et produire une documentation exploitable. Les données, utilisateurs et sites de l'entreprise sont fictifs ; les captures de laboratoire sont authentiques et sélectionnées pour ne pas divulguer de secrets.

[Guide des preuves visuelles et du suivi des publications](docs/GUIDE_CAPTURES_PUBLICATIONS.md) · [Profil LinkedIn](https://fr.linkedin.com/in/vincent-scannella)

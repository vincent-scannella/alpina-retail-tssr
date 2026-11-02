# ALPINA RETAIL — Épisode 01 : Organisation et organigramme

> **Date du livrable :** 1er novembre 2026  
> **Statut de cet épisode :** organisation fictive définie et documentée.  
> **Périmètre :** conception métier et hiérarchique ; aucune installation technique n'est revendiquée pour cette étape. Les déploiements ultérieurs sont présentés dans les [épisodes 03](../episode-03/README.md) et [04](../episode-04/README.md).

**Objectif :** définir les quatre sites, les fonctions des 75 collaborateurs simulés et les besoins qui serviront à concevoir une infrastructure informatique cohérente.

**Navigation :** [Accueil / épisode 00](../../README.md) · [Épisode suivant : 02 — Cahier des charges](../episode-02/README.md)

## En bref

| Entreprise fictive | Siège de Grenoble | Boutiques | Service informatique |
|---|---:|---:|---:|
| **75 collaborateurs simulés** | 30 | 3 × 15 | 2 personnes au siège |

**Sommaire :** [Organisation générale](#1-vue-générale-de-lorganisation) · [Implantations](#2-implantation-des-sites) · [Siège](#3-organisation-du-siège) · [Boutiques](#4-organisation-des-boutiques) · [Informatique](#5-service-informatique) · [Besoins](#6-premiers-besoins-informatiques) · [Compétences TSSR](#7-application-aux-compétences-tssr) · [Avancement](#8-avancement-et-suite)

## 1. Vue générale de l'organisation

ALPINA RETAIL est une **PME entièrement fictive** spécialisée dans le prêt-à-porter et les accessoires. Son organisation sert de contexte aux futurs exercices de support utilisateurs, d'administration systèmes et de gestion des accès.

![Organigramme et organisation ALPINA RETAIL](IMG_0878.png)

*Organigramme du scénario métier : fonctions et responsabilités simulées, pas comptes Active Directory ou salariés réels.*

**Dossier détaillé :** [consulter l'organigramme et le document d'organisation (PDF)](Alpina_Retail_Organisation_Episode_01.pdf).

## 2. Implantation des sites

| Identifiant | Implantation | Activité | Effectif simulé |
|---|---|---|---:|
| SITE-01 | Grenoble | Siège administratif | 30 |
| SITE-02 | Grenoble Centre | Boutique | 15 |
| SITE-03 | Voiron | Boutique | 15 |
| SITE-04 | Chambéry | Boutique | 15 |
| **TOTAL** | **4 sites** | | **75** |

![Répartition des 75 collaborateurs simulés dans les quatre implantations et les services du siège](images/repartition-effectifs.svg)

*Répartition de conception : 30 personnes au siège, 15 dans chacune des trois boutiques. Le diagramme représente des effectifs fictifs.*

## 3. Organisation du siège

| Service | Collaborateurs simulés |
|---|---:|
| Direction générale | 2 |
| Ressources humaines | 3 |
| Comptabilité et finances | 3 |
| Achats et merchandising | 5 |
| Marketing et e-commerce | 4 |
| Logistique et stocks | 9 |
| Informatique | 2 |
| Administration générale | 2 |
| **TOTAL** | **30** |

La direction comprend un **directeur général** et un **directeur des opérations commerciales**.

## 4. Organisation des boutiques

Chaque boutique comprend les fonctions suivantes :

| Fonction | Effectif simulé par boutique |
|---|---:|
| Responsable de magasin | 1 |
| Responsable adjoint | 1 |
| Conseillers de vente | 9 |
| Employés de caisse | 2 |
| Employés de stock et logistique | 2 |
| **TOTAL par boutique** | **15** |

Les trois responsables de magasin sont supervisés par le directeur des opérations commerciales.

## 5. Service informatique

L'équipe informatique du scénario est composée de **deux personnes**, basées au siège.

| Fonction | Responsabilités prévues |
|---|---|
| **Responsable informatique** | Pilotage des projets, priorités et budgets ; politique de sécurité ; validation des changements sensibles |
| **Technicien systèmes et réseaux** | Assistance utilisateurs ; administration Windows Server et Linux ; comptes Active Directory ; maintenance ; résolution des incidents ; supervision, sauvegardes et documentation |

Le support des boutiques est **prévu principalement à distance** depuis le siège. Cela décrit une organisation cible, pas un service de support déjà mis en production.

## 6. Premiers besoins informatiques

Les besoins identifiés à partir de l'organisation sont :

- centraliser la gestion des utilisateurs et des accès ;
- distinguer les droits par service, fonction et site ;
- proposer des documents partagés sécurisés ;
- relier les quatre sites ;
- suivre les demandes de support et les incidents ;
- protéger les données et prévoir des sauvegardes ;
- superviser les équipements et les services.

Ces besoins sont détaillés dans l'[épisode 02 — Cahier des charges informatique](../episode-02/README.md).

## 7. Application aux compétences TSSR

Cette analyse prépare les travaux techniques suivants :

- conception des **unités d'organisation (OU)** Active Directory ;
- création des utilisateurs et des groupes de sécurité ;
- définition et vérification des habilitations ;
- mise en œuvre des **GPO** et des partages ;
- organisation du support utilisateurs ;
- conception de la future infrastructure multisite.

> **Point de vigilance :** l'organigramme RH ne doit pas être reproduit automatiquement dans Active Directory. La structure des OU et des groupes doit répondre aux besoins d'administration, de délégation et de sécurité.

## 8. Avancement et suite

- [x] Définir l'identité et les quatre implantations de l'entreprise fictive.
- [x] Répartir les 75 collaborateurs simulés et établir l'organigramme.
- [x] Définir les deux responsabilités du service informatique.
- [x] Identifier les premiers besoins à partir de l'organisation.
- [x] Publier un organigramme, le dossier PDF et une vue de répartition des effectifs.

**Suite du parcours :** [épisode 02 — Cahier des charges](../episode-02/README.md), puis [épisode 03 — pfSense](../episode-03/README.md) et [épisode 04 — Windows Server / Active Directory / DNS / DHCP](../episode-04/README.md). Ces réalisations postérieures ne sont pas présentées comme déjà effectuées au moment de l'épisode 01.

---

**Auteur : Vincent Scannella — Technicien Supérieur Systèmes et Réseaux (TSSR)**  
[Retour à l'accueil du portfolio](../../README.md) · [Continuer vers l'épisode 02](../episode-02/README.md)

# ALPINA RETAIL — Épisode 04 : Déploiement de Windows Server 2025 au siège de Grenoble

> **Date des opérations :** 2 novembre 2026  
> **Statut :** Windows Server installé, renommé et adressé en IPv4 statique ; connectivité vers pfSense et vers `8.8.8.8` **testée avec succès**. **Rôle AD DS installé, promotion de `DC1-GRE-SIEGE` vers la nouvelle forêt `ironman.test` engagée et redémarrage suivi d'une connexion au domaine `IRONMAN` confirmés. L'identité de domaine apparaît dans « Serveur local ». La santé d'AD DS et la résolution DNS restent à tester ; DHCP n'est pas encore configuré.**  
> **Contexte :** laboratoire personnel TSSR simulant une entreprise entièrement fictive.

## 1. Objectif et architecture

Créer un premier serveur Windows pour préparer les services d'identité et d'infrastructure du siège d'ALPINA RETAIL.

```text
                   Internet
                       |
                VMware VMnet8 / NAT
                       |
               pfSense-GRE-SIEGE
                  WAN : DHCP
                  LAN : 10.10.10.1/24
                       |
               VMware VMnet1 / LAN
                       |
                  DC1-GRE-SIEGE
                  10.10.10.10/24
```

La liaison entre la VM Windows et pfSense est assurée par **VMnet1 (Host-only)**. Le WAN pfSense est raccordé au NAT de VMware. Cette architecture représente une maquette, pas un environnement de production.

## 2. Machine virtuelle

| Élément | Configuration observée |
|---|---|
| Hyperviseur | VMware Workstation Pro 17 |
| Hôte | Windows 11, 16 Go RAM physique |
| Nom de VM | `DC1-GRE-SIEGE` |
| Système | **Windows Server 2025 Standard Evaluation**, édition avec interface graphique (« expérience utilisateur ») |
| RAM | 4 Go |
| Processeur | 2 vCPU (1 processeur virtuel × 2 cœurs) |
| Disque virtuel | 80 Go, NVMe |
| Adaptateur réseau | Custom (`VMnet1`) |
| Lecteur virtuel | ISO d'installation de Windows Server 2025 sélectionné |
| Autres VM | `PC-TEST-GRE` arrêté durant l'installation ; pfSense démarré pour les tests réseau |

Le disque de **80 Go** correspond au récapitulatif final de VMware ; une taille de 60 Go avait été évoquée en préparation, mais elle n'est pas celle retenue dans la VM créée.

## 3. Installation et configuration réellement effectuées

1. Création de `DC1-GRE-SIEGE` dans VMware Workstation.
2. Sélection du système `Windows Server 2025` et association de son ISO.
3. Configuration de **4 Go RAM, 2 vCPU, 80 Go NVMe et réseau VMnet1**.
4. Démarrage de l'installateur en français.
5. Sélection explicite de **Windows Server 2025 Standard Evaluation (expérience utilisateur)**, plutôt que Server Core.
6. Installation terminée et première ouverture de session avec le compte local `Administrateur`. Le mot de passe n'est pas conservé dans le dépôt.
7. Vérification du Gestionnaire de serveur et de l'édition Windows.
8. Modification du nom **Windows** de la machine, distinct du nom de VM : `DC1-GRE-SIEGE`.
9. Redémarrage et confirmation du nom `DC1-GRE-SIEGE` dans « Serveur local ».
10. Configuration manuelle de l'interface `Ethernet0` en IPv4 statique.
11. Vérification des paramètres avec `ipconfig /all`.
12. Démarrage de pfSense, puis tests `ping` vers la passerelle et vers une destination extérieure, avec résultats complets consignés ci-dessous.
13. Lancement de **Gestionnaire de serveur → Gérer → Ajouter des rôles et fonctionnalités** ; sélection de l'installation basée sur un rôle et du serveur `DC1-GRE-SIEGE` (`10.10.10.10`).
14. Sélection du rôle **Services de domaine Active Directory (AD DS)** et des fonctionnalités d'administration associées, puis lancement de l'installation.
15. **Installation du rôle AD DS réussie**, attestée par la notification du Gestionnaire de serveur : « Configuration requise. Installation réussie sur DC1-GRE-SIEGE ». L'assistant propose alors **« Promouvoir ce serveur en contrôleur de domaine »**.
16. Lancement de l'assistant de promotion et sélection de **« Ajouter une nouvelle forêt »** ; domaine racine choisi : **`ironman.test`**, nom DNS de laboratoire distinct du nom de l'entreprise fictive.
17. Options choisies : **niveau fonctionnel de forêt et de domaine Windows Server 2025**, serveur DNS et catalogue global cochés, RODC décoché ; mot de passe DSRM défini par l'auteur, non publié.
18. Avertissement de non-création d'une délégation DNS dans la zone parente : attendu pour cette forêt de laboratoire indépendante, sans délégation parente configurée.
19. Nom NetBIOS confirmé : **`IRONMAN`**. Les paramètres et chemins d'accès ont été parcourus ; aucune valeur de chemin particulière n'est revendiquée faute de capture.
20. Contrôle des prérequis **réussi** : l'assistant indique que « toutes les vérifications de la configuration requise ont donné satisfaction » malgré l'avertissement DNS non bloquant.
21. Promotion lancée, puis **redémarrage de Windows Server**. L'écran de connexion affiche **`IRONMAN\Administrateur`** ; ouverture de session effectuée par l'auteur.
22. Dans **Gestionnaire de serveur → Serveur local**, observation du nom **`DC1-GRE-SIEGE`**, du **domaine `ironman.test`**, de l'adresse **`10.10.10.10`** et du profil de pare-feu **Domaine : actif**. Ces preuves confirment le rattachement à la nouvelle forêt après promotion, **sans valider encore l'ensemble des services AD DS et DNS**.

## 4. Configuration IPv4 confirmée depuis `ipconfig /all`

| Paramètre | Valeur observée |
|---|---|
| Nom de l'hôte | `DC1-GRE-SIEGE` |
| Interface | `Ethernet0` |
| DHCP | Désactivé |
| IPv4 | `10.10.10.10` |
| Masque | `255.255.255.0` (/24) |
| Passerelle | `10.10.10.1` |
| DNS préféré | `10.10.10.10` |
| DNS auxiliaire | Aucun indiqué |

**Interprétation :** l'adresse DNS préférée pointe volontairement vers le futur serveur DNS local. Le **service DNS n'est pas encore installé**, et aucune résolution de nom depuis DC1 n'est revendiquée à cette étape.

## 5. Tests réseau et résultats

| Test effectué depuis `DC1-GRE-SIEGE` | Paquets envoyés | Reçus | Perte | Mesures observées |
|---|---:|---:|---:|---|
| `ping 10.10.10.1` (pfSense LAN) | 4 | 4 | **0 %** | min 0 ms, max 1 ms, moyenne 0 ms |
| `ping 8.8.8.8` (destination externe) | 4 | 4 | **0 %** | min 20 ms, max 24 ms, moyenne 21 ms |

Les deux sorties de commande ont été transmises par l'auteur sous forme de captures d'écran.

**Conclusion limitée au test :** les réponses ICMP prouvent l'accès à la passerelle et la connectivité IPv4 vers `8.8.8.8` depuis la VM Windows, à travers pfSense. Elles ne prouvent pas à elles seules le fonctionnement du DNS, d'Active Directory ou de tous les protocoles applicatifs.

## 5 bis. Promotion en contrôleur de domaine : état observé

| Élément | Résultat |
|---|---|
| Nouvelle forêt DNS | `ironman.test` (nom saisi dans l'assistant) |
| Nom NetBIOS | `IRONMAN` (confirmé dans l'assistant et à l'écran de connexion) |
| Niveaux fonctionnels choisis | Windows Server 2025 (forêt et domaine) |
| DNS / Catalogue global | Options cochées pendant la promotion ; services à tester séparément |
| Prérequis de promotion | Contrôles préalables satisfaits ; avertissement de délégation DNS non bloquant |
| Redémarrage après promotion | Effectué ; session `IRONMAN\Administrateur` ouverte |
| Domaine visible dans Serveur local | **`ironman.test`** |
| Services AD DS / DNS | **Non encore contrôlés** par commandes de diagnostic ou tests de résolution |

## 6. Preuves visuelles à publier

Des captures authentiques ont été prises pendant les manipulations :
- récapitulatif de création de la VM ;
- notification de réussite d'installation du rôle AD DS ;
- options de promotion (nouvelle forêt `ironman.test`, DNS et catalogue global), vérification préalable satisfaisante et écran de connexion `IRONMAN\Administrateur` ;
- écran « Serveur local » après promotion affichant `ironman.test` ;
- premier démarrage et Gestionnaire de serveur ;
- renommage confirmé après redémarrage ;
- sortie `ipconfig /all` ;
- commandes de ping et statistiques.

**À faire :** déposer les captures sélectionnées, après vérification de confidentialité, dans un futur dossier `images/`, puis les intégrer en Markdown à proximité des vérifications qu'elles étayent. **Aucune image non déposée n'est présentée comme publiée.**

## 7. Étapes restantes

- [x] Créer la VM `DC1-GRE-SIEGE`.
- [x] Installer Windows Server 2025 Standard Evaluation avec interface graphique.
- [x] Renommer Windows et vérifier après redémarrage.
- [x] Configurer et vérifier l'adresse `10.10.10.10/24`.
- [x] Tester le ping vers la passerelle `10.10.10.1` avec 0 % de perte.
- [x] Tester le ping vers `8.8.8.8` avec 0 % de perte.
- [x] Installer le rôle **AD DS** : notification de réussite du Gestionnaire de serveur observée le 02/11/2026.
- [x] Lancer et achever la promotion de DC1 en premier contrôleur de domaine de la nouvelle forêt `ironman.test` : redémarrage et identité de domaine confirmés visuellement.
- [ ] Vérifier la santé des services AD DS, le rôle DNS et la résolution DNS après promotion (non encore validés).
- [ ] Vérifier la présence et l'intégrité des zones et enregistrements DNS AD, ainsi que les services d'annuaire.
- [ ] Configurer ensuite DHCP, conformément à l'architecture de laboratoire.
- [ ] Vérifier la jonction d'un poste Windows 11 au domaine, l'authentification et les politiques de groupe.
- [ ] Ajouter des captures authentiques contrôlées dans la documentation.

**Aucun test ou service non réalisé n'est présenté comme réussi.**

---

**Auteur :** Vincent Scannella — TSSR.  
[Revenir au dépôt du projet](../../README.md) · [Épisode 03 — pfSense](../episode-03/README.md)

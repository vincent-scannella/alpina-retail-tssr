# ALPINA RETAIL — Guide des captures d'écran et des publications

> **Règle éditoriale du projet :** les prochaines documentations GitHub et publications LinkedIn doivent être illustrées par de **véritables captures d'écran du laboratoire**, en complément des explications techniques. L'objectif est de permettre au lecteur, notamment à un recruteur, de distinguer ce qui a été réellement mis en œuvre et vérifié de ce qui reste à faire.

## 1. À chaque étape technique validée

1. **Prévoir la preuve dès le test**, avant de fermer la fenêtre ou de supprimer une règle temporaire.
2. Capturer l'écran pertinent : configuration, commande exécutée, sortie du test, état d'un service ou événement de journal.
3. Conserver le contexte permettant de comprendre la preuve (machine, outil, commande, source/destination, résultat), sans exposer de secret.
4. Vérifier que la capture correspond exactement au résultat décrit : **jamais de succès inventé**, jamais de capture illustrative présentée comme une preuve réelle.
5. Préciser la date et, si utile, les limites du test, notamment lorsqu'aucune trace de journalisation n'existe.

## 2. GitHub : documentation détaillée

- Créer lorsque nécessaire un dossier `docs/episode-XX/images/` et utiliser des noms explicites comme `pfsense-regles-lan.png` ou `win11-test-dns.png`.
- Intégrer les images en Markdown, près du paragraphe ou du tableau qu'elles étayent.
- Ajouter une légende courte : **objectif → manipulation → résultat observé**.
- Privilégier quelques captures réellement utiles plutôt que de nombreuses images redondantes.
- Conserver la documentation textuelle, les commandes et les conclusions : **une capture ne remplace pas une explication**.

Exemple d'intégration, après ajout effectif du fichier image :

```md
![Résultat du test DNS depuis Windows 11](images/win11-test-dns.png)

*PC-TEST-GRE — résolution DNS effectuée à travers le résolveur pfSense du LAN.*
```

## 3. LinkedIn : sélection pédagogique

- Prévoir une courte sélection de **2 à 4 captures marquantes**, suivant le format de la publication.
- Mettre en avant un récit lisible : **problème / solution / vérification / résultat**.
- Utiliser des annotations légères si elles améliorent la lisibilité (flèches, zones encadrées), sans altérer le résultat.
- Fournir le lien vers le dossier GitHub pour les détails et preuves complémentaires.
- Ne présenter comme réalisé que ce qui l'a réellement été.

## 4. Contrôle de sécurité avant publication

- **Masquer systématiquement** les mots de passe, tokens, clés, cookies, identifiants de session, contenus privés, noms ou coordonnées de personnes réelles et détails sensibles.
- Vérifier les onglets du navigateur, notifications, URL, lignes de commande, fenêtres en arrière-plan et métadonnées si nécessaire.
- Les adresses privées du laboratoire fictif peuvent être montrées si elles ne divulguent aucun autre environnement réel.
- Ne **jamais** placer un export de configuration pfSense complet dans le dépôt public : il peut contenir des données sensibles.

## 5. Application au projet

- **Épisodes 00, 01 et 02 — conception :** schémas explicatifs vectoriels, clairement identifiés comme *entreprise fictive* et *architecture cible*, sans les présenter comme des captures d'un système fonctionnel. Le dépôt comprend une vue multisite en épisode 00, l'organigramme et la répartition des effectifs en épisode 01, et deux schémas prévisionnels en épisode 02.
- **Épisode 03 — pfSense et Windows 11 :** choisir des captures authentiques de l'architecture VMware, des paramètres LAN, du poste client et des tests réseau/NAT/PAT, si elles sont disponibles. Les résultats ICMP avant/après et HTTPS ont été confirmés, mais **aucune preuve de log pour la règle de test n'a été produite** ; ne pas en inventer.
- **Épisodes suivants — Windows Server, AD DS, DNS, DHCP, dépannage :** préparer systématiquement les captures pendant chaque manipulation et chaque contrôle réussi ou échoué.

**Principe :** des captures réelles, contextualisées, lisibles et expurgées de toute information sensible renforcent la crédibilité d'un laboratoire professionnel.

## 6. Règle de suivi : captures et jalons LinkedIn

Cette règle s'applique **à chaque futur épisode**, y compris pendant les phases de dépannage :

1. Avant ou juste après chaque manipulation importante, **indiquer à l'auteur quelle capture réaliser** (écran de paramétrage, état initial, erreur, test, correction, test final).
2. Après une vérification réussie ou un diagnostic utile, **actualiser le README technique** avec la commande complète, la configuration observée et les limites du résultat.
3. **Vérifier la présence réelle du PNG dans GitHub avant d'ajouter son lien Markdown.** Si un fichier image n'est pas encore téléversé, signaler « capture en attente » et accompagner l'auteur pour son ajout, plutôt que d'annoncer son intégration.
4. Conserver, pour un incident, des captures **avant / après**, sans confondre une hypothèse de panne avec une cause démontrée.
5. **Signaler explicitement quand un nouveau jalon mérite une publication LinkedIn**, sans multiplier les posts pour des opérations intermédiaires. Le projet doit présenter des réalisations techniques démontrées, pas seulement une installation.
6. Avant toute publication, confronter son texte aux preuves réellement obtenues, joindre un carrousel de captures authentiques et vérifier la date déjà programmée pour éviter les doublons.

### Prochain jalon éditorial envisagé — Épisode 04

**Sujet :** Windows Server 2025, domaine Active Directory `ironman.test`, DNS et dépannage de la résolution inverse.

**Déjà vérifié le 2 novembre 2026 :** VM créée ; adressage IP statique ; connectivité pfSense et Internet en IPv4 ; promotion du domaine ; `dcdiag /test:Advertising` réussi ; enregistrement SRV LDAP retourné ; zone inversée et PTR créés ; disparition du message `Server: UnKnown` au contre-test ; `dcdiag /test:DNS` réussi dans les résultats visibles ; résolution du nom externe `www.microsoft.com` via DC1 réussie.

**Encore utile pour une publication de déploiement plus complète :** contrôler les partages `SYSVOL` et `NETLOGON`, puis idéalement déployer et vérifier le serveur DHCP et la jonction du poste `PC-TEST-GRE` au domaine, avec une connexion utilisateur de test. Si cette suite prend du temps, une publication autonome centrée sur **la création du domaine et le dépannage DNS documenté** peut déjà être justifiée après les contrôles AD complémentaires.

**Calendrier :** la publication pfSense/Windows 11 de l'épisode 03 est déjà programmée pour le **10 novembre 2026 à 12 h 15**. Pour l'épisode 04, ne fixer une nouvelle date que lorsque le contenu, les preuves visuelles et le diagnostic auront été validés ; éviter un chevauchement inutile avec la publication programmée.

**Images de l'épisode 04 :** **23 captures authentiques** vérifiées dans `docs/episode-04/images/` et toutes intégrées dans le README de l'épisode, dont les comparaisons DNS avant/après et la configuration de l'étendue DHCP. La prochaine preuve attendue est l'obtention d'un bail DHCP par `PC-TEST-GRE`, puis les tests de domaine côté client.

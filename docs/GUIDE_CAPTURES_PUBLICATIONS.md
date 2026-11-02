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

- **Épisode 03 — pfSense et Windows 11 :** choisir des captures authentiques de l'architecture VMware, des paramètres LAN, du poste client et des tests réseau/NAT/PAT, si elles sont disponibles. Les résultats ICMP avant/après et HTTPS ont été confirmés, mais **aucune preuve de log pour la règle de test n'a été produite** ; ne pas en inventer.
- **Épisodes suivants — Windows Server, AD DS, DNS, DHCP, dépannage :** préparer systématiquement les captures pendant chaque manipulation et chaque contrôle réussi ou échoué.

**Principe :** des captures réelles, contextualisées, lisibles et expurgées de toute information sensible renforcent la crédibilité d'un laboratoire professionnel.

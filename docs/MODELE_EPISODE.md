# Modèle de documentation — Nouvel épisode ALPINA RETAIL

> **Gabarit interne, non publié comme réalisation technique.** Copier sa structure dans `docs/episode-XX/README.md` pour chaque nouvel épisode. **Remplacer les champs entre crochets** par des observations réelles ; ne jamais présenter ce modèle comme un test effectué.  
> **Standard de référence :** [Guide des captures et des publications](GUIDE_CAPTURES_PUBLICATIONS.md).

---

# ALPINA RETAIL — Épisode XX : [Titre technique précis]

> **Date(s) des opérations :** [JJ mois AAAA]  
> **Statut :** [défini / en cours / vérifié en partie / terminé selon les tests]  
> **Périmètre :** laboratoire personnel TSSR, entreprise entièrement fictive.

## En bref

| Domaine / fonction | Résultat réellement observé | Limites ou tests restants |
|---|---|---|
| [Technologie] | [Fait observé, avec commande ou configuration] | [Non réalisé / à confirmer] |
| [Technologie] | [Fait observé] | [Limites explicites] |

**Sommaire :** insérer des liens vers les sections réellement présentes après vérification de leurs ancres sur GitHub.

**Navigation à adapter après copie :** ajouter des liens vers l'accueil (`../../README.md`), l'épisode précédent (`../episode-NN/README.md`) et l'épisode suivant uniquement après sa création. *Aucun lien de remplacement ne doit rester actif dans le gabarit.*

## 1. Besoin et objectif

- **Problème métier ou technique :** [besoin réel du scénario]
- **Objectif mesurable :** [fonctionnalité à configurer et vérifier]
- **Périmètre :** [machines et services concernés]
- **Hors périmètre :** [fonctionnalités non réalisées]

## 2. Architecture du laboratoire

Décrire la topologie **réellement installée** et les réseaux/liaisons connus. Ajouter un schéma explicatif si nécessaire, **étiqueté comme schéma**, et ne pas lui attribuer la valeur d'une capture de preuve.

| Composant | Interface / IP | Rôle | État vérifié |
|---|---|---|---|
| [Machine] | [Adresse / réseau] | [Fonction] | [Observation] |

## 3. Configuration et manipulations

Décrire les manipulations **chronologiquement** et sans inventer de commandes ou de résultats.

1. [Action effectuée et pourquoi]
2. [Configuration réellement retenue]
3. [Contrôle de réussite]

**Capture authentique :** intégrer le Markdown d'image **uniquement après** avoir vérifié la présence du fichier dans `images/` sur GitHub. Placer la capture juste après l'étape qu'elle illustre ; ajouter une légende indiquant **contexte → manipulation → résultat observé**.

## 4. Vérifications et résultats

| Test / commande | Résultat constaté | Validation |
|---|---|---|
| [Commande exacte] | [Sortie réelle ou résumé fidèle] | Vérifié / Partiel / À tester |

Préciser depuis quelle machine le test est exécuté, et distinguer **service configuré**, **service démarré** et **fonctionnement réellement testé depuis un client**.

## 5. Incident, diagnostic et correction (si applicable)

| Phase | Faits documentés |
|---|---|
| **Avant : symptôme** | [Message / panne constatée + capture si disponible] |
| **Hypothèse** | [Piste diagnostique, non présentée comme preuve] |
| **Diagnostic** | [Commande / écran et constat réel] |
| **Correction** | [Modification réellement effectuée] |
| **Après : contre-test** | [Même commande/test reproduit, sortie réelle, différence] |
| **Limites** | [Cause non prouvée, journaux indisponibles, autre test nécessaire] |

Un **avant/après** n'est présenté comme démontré que lorsque les deux observations existent réellement.

## 6. Preuves visuelles

Distinguer systématiquement :

- **Captures authentiques** : vrais écrans de VMware, pfSense, Windows, Linux, commandes, journaux ou résultats.
- **Schémas pédagogiques** : représentations explicatives, **jamais présentées comme preuves d'exécution**.
- **Images en attente** : fichiers reçus ou préparés, mais **non encore vérifiés sur GitHub**.

Ranger les captures dans `docs/episode-XX/images/` avec des noms explicites. Chaque lien Markdown doit pointer vers un fichier présent ; sa légende doit être fidèle au contenu visible. Ne pas introduire de captures redondantes ou sans intérêt probatoire.

## 7. Limites et état d'avancement

- [x] [Opération effectivement réalisée ET vérifiée selon son périmètre]
- [ ] [Test non encore effectué]
- [ ] [Poursuite du scénario]

Ne jamais cocher les étapes sur la seule base d'un assistant de configuration terminé si la fonction dépend d'un test client ou d'une restauration.

## 8. Compétences TSSR mobilisées

Préciser le lien entre les tâches réellement documentées et les compétences **installation → vérification → dépannage → documentation**, sans prétendre à une expérience professionnelle en production.

## 9. Références et navigation

- Accueil : utiliser le chemin `../../README.md` **après copie dans le dossier d'épisode**.
- Épisode précédent : lien Markdown uniquement si son README existe.
- Épisode suivant : lien Markdown uniquement si l'épisode est effectivement créé.
- Inventaire des captures : lier `images/README.md` lorsqu'il est publié.

---

**Avant le commit :** appliquer la liste de contrôle du [guide de publication](GUIDE_CAPTURES_PUBLICATIONS.md) : exactitude technique, statut, confidentialité, liens/ancres, captures réellement téléversées, lisibilité sur GitHub et vérification du résultat après mise à jour.

**Auteur : Vincent Scannella — TSSR.**

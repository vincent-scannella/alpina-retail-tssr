# ALPINA RETAIL — Épisode 03 : inventaire des visuels

Les fichiers de ce dossier distinguent **captures authentiques**, **schémas explicatifs** et **photos en attente de publication**. Aucun diagramme n'est présenté comme une capture pfSense.

## 5 captures authentiques — sauvegarde pfSense

| Fichier présent | Preuve réellement visible |
|---|---|
| `01-pfsense-parametres-sauvegarde.png` | Options de `Diagnostics → Backup & Restore` avant saisie du secret |
| `02-pfsense-chiffrement-active.png` | Option de chiffrement activée, champs de mot de passe vides |
| `03-sauvegarde-xml-vm.png` | Fichier de sauvegarde dans les téléchargements de la VM |
| `04-extension-xml-verifiee.png` | Extension `.xml` visible dans l'Explorateur |
| `05-copie-sauvegarde-hote.png` | Copie du fichier sur l'hôte Windows, taille apparente contrôlée |

Ces cinq captures sont **présentes dans GitHub** et insérées dans [le README de l'épisode 03](../README.md).

## 2 schémas de lecture technique déjà publiés

| Fichier présent | Utilisation |
|---|---|
| [`06-schema-nat-pat-observe.svg`](06-schema-nat-pat-observe.svg) | Traduction TCP HTTPS documentée entre `10.10.10.20:54138` et `10.50.10.128:26027` |
| [`07-schema-filtrage-icmp-avant-apres.svg`](07-schema-filtrage-icmp-avant-apres.svg) | Chronologie ping réussi → ping bloqué → ping rétabli ; absence de preuve par journal |

**Ces deux SVG sont des schémas rédigés à partir des observations déjà consignées. Ils ne constituent pas des captures d'écran ni une nouvelle mesure du laboratoire.**

## 3 captures authentiques supplémentaires — NAT/PAT et filtrage ICMP

Ces écrans proviennent des captures authentiques sélectionnées pour le carrousel LinkedIn de l'épisode 03 et sont intégrés au suivi technique sans modification de leurs résultats :

| Fichier publié | Limite de la preuve |
|---|---|
| `08-pfsense-diagnostics-states-nat-pat.png` | Vue réelle `Diagnostics → States` avec la connexion TCP et les deux ports source |
| `09-pfsense-regle-icmp-avant-application.png` | Règle `Block` visible sur le LAN, **avant `Apply Changes`** : ne prouve pas à elle seule son activation |
| `10-windows11-ping-icmp-bloque.png` | Invite Windows avec plusieurs expirations du ping `8.8.8.8` ; le compteur final de perte n'est pas visible sur ce recadrage |

**Ces trois PNG sont maintenant présents dans GitHub et intégrés dans le [README principal](../README.md), accompagnés de légendes adaptées à leurs limites.**

**État documentaire :** 8 captures PNG authentiques et 2 diagrammes SVG pédagogiques sont présents dans ce dossier et intégrés au [README de l'épisode 03](../README.md). Les images 09 et 10 documentent respectivement une règle avant son application et des expirations de ping, mais ne suffisent pas à établir une preuve par journal du pare-feu.

**Sécurité :** ne jamais publier la sauvegarde XML de pfSense, son mot de passe, des cookies, des secrets d'administration ou des données privées.

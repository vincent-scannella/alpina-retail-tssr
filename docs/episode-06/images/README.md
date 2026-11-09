# ALPINA RETAIL — Épisode 06 — Preuves visuelles de sécurisation SSH

**09 novembre 2026.** Deux captures authentiques transmises par l'auteur, liées au [compte rendu de l'épisode 06](../README.md).

| Capture | Ce qu'elle montre |
|---|---|
| [01 — Configuration initiale SSH](01-ssh-avant-durcissement.png) | `PermitRootLogin without-password` et `PasswordAuthentication yes` avant la modification |
| [02 — Configuration OpenSSH validée](02-ssh-parametres-valides.png) | `sshd -t` sans erreur, `PermitRootLogin no`, `PubkeyAuthentication yes`, `PasswordAuthentication no`, `KbdInteractiveAuthentication no` |

## Avant

![SSH avant le durcissement](01-ssh-avant-durcissement.png)

## Après

![Paramètres SSH après le durcissement](02-ssh-parametres-valides.png)

**Limites :** la connexion SSH par clé a été confirmée par l'auteur après rechargement, mais n'a pas fait l'objet d'une capture dédiée. Aucune clé privée ni passphrase n'est incluse. La deuxième capture est compressée pour le dépôt sans changement des valeurs affichées.

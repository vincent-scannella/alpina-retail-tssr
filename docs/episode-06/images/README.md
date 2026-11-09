# ALPINA RETAIL — Épisode 06 — Preuves visuelles SSH, Samba, pare-feu et Active Directory

**09 novembre 2026.** Huit captures authentiques transmises par l'auteur, liées au [compte rendu de l'épisode 06](../README.md).

| Capture | Ce qu'elle montre |
|---|---|
| [01 — Configuration initiale SSH](01-ssh-avant-durcissement.png) | `PermitRootLogin without-password` et `PasswordAuthentication yes` avant la modification |
| [02 — Configuration OpenSSH validée](02-ssh-parametres-valides.png) | `sshd -t` sans erreur, `PermitRootLogin no`, `PubkeyAuthentication yes`, `PasswordAuthentication no`, `KbdInteractiveAuthentication no` |
| [03 — Chiffrement Samba requis](03-samba-partage-chiffrement-obligatoire.png) | Section `[COMMUN]` avec `server smb encrypt = required` |
| [04 — Signature serveur Samba requise](04-samba-signature-obligatoire.png) | Section `[global]` avec `server signing = required` ; capture **antérieure** à la correction `usershare allow guests = no` |
| [05 — Chiffrement SMB3 observé côté Windows](05-client-smb3-chiffre.png) | `Get-SmbConnection` : dialecte `3.1.1`, `Encrypted=True`, `Signed=False` cohérent avec le chiffrement actif |
| [06 — Politique AD initiale](06-ad-policy-initial.png) | Longueur minimale 7 et seuil de verrouillage 0 avant durcissement |
| [07 — Politique AD renforcée](07-ad-policy-renforcee.png) | Longueur minimale 14, complexité activée, verrouillage 10 tentatives / 15 minutes |
| [08 — Pare-feu DC1 profil Domaine](08-dc1-firewall-domaine.png) | État actif ; politique `BlockInbound,AllowOutbound` |

## Avant

![SSH avant le durcissement](01-ssh-avant-durcissement.png)

## Après

![Paramètres SSH après le durcissement](02-ssh-parametres-valides.png)

## Sécurisation et validation Samba/SMB

![Section COMMUN : chiffrement requis](03-samba-partage-chiffrement-obligatoire.png)

![Section globale : signature requise avant correction des shares invités](04-samba-signature-obligatoire.png)

![Windows 11 : connexion chiffrée SMB 3.1.1](05-client-smb3-chiffre.png)

## Contrôles Windows Server et Active Directory

![Politique initiale de mots de passe AD](06-ad-policy-initial.png)

![Politique AD renforcée et contrôlée](07-ad-policy-renforcee.png)

![Pare-feu du contrôleur de domaine actif](08-dc1-firewall-domaine.png)

**Limites :** la connexion SSH par clé a été confirmée par l'auteur après rechargement, mais n'a pas fait l'objet d'une capture dédiée. Aucune clé privée ni passphrase n'est incluse. La deuxième capture est compressée pour le dépôt sans changement des valeurs affichées. La capture 04 précède la dernière modification de la configuration des partages invités. Les six captures SMB/AD/pare-feu ajoutées proviennent des séances authentiques et ont été compressées pour le dépôt.

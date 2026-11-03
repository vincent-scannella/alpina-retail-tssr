# ALPINA RETAIL — Épisode 05 : FS1, serveur de fichiers Debian Linux

> **Date du premier jalon :** 3 novembre 2026  
> **Statut :** Debian 12 installé, démarrage et connexion locale confirmés ; configuration réseau, SSH, Samba et intégration AD **non encore vérifiés**.  
> **Périmètre :** laboratoire TSSR personnel, siège fictif de Grenoble. La société et ses utilisateurs sont simulés.

## Objectif métier

Mettre en place un serveur de fichiers Linux pour le siège d'ALPINA RETAIL, accessible à terme depuis des postes Windows via SMB/Samba, avec des droits organisés à l'aide de groupes du domaine Active Directory `ironman.test`. Cette configuration est **l'objectif**, pas un déploiement déjà fonctionnel.

**Évolution du cahier des charges :** le scénario initial de l'[épisode 02](../episode-02/README.md) envisageait un `FS1` sous Windows avec permissions NTFS. Le laboratoire met désormais en œuvre **Debian Linux + Samba** pour démontrer l'administration Linux et l'interopérabilité avec Active Directory. La conception des permissions et ACL sera adaptée et testée avant toute validation.

## 1. Paramètres de laboratoire

| Élément | Valeur / état |
|---|---|
| VM / nom d'hôte | `FS1-GRE-SIEGE` / `fs1-gre-siege` |
| Système observé | Debian GNU/Linux 12 (bookworm) |
| Noyau observé | `6.1.0-54-amd64` |
| Architecture observée | `x86-64` |
| Hyperviseur indiqué par Linux | VMware |
| Connexion locale | Compte de test local `administrateur`, connexion console réussie |
| Ressources ciblées lors de la création | 2 vCPU, 2 Go de RAM, disque virtuel de 40 Go — à recontrôler sur la VM recréée |
| Domaine DNS renseigné pendant l'installation | `ironman.test` (ne constitue **pas** une jonction au domaine Active Directory) |
| Réseau de destination | `VMnet1`, LAN derrière pfSense `10.10.10.1/24` — **non encore vérifié** sur FS1 |
| Réseau d'installation annoncé | VMnet8 (NAT), à remplacer par VMnet1 après préparation |
| Configuration IPv4 / DNS | Non encore relevée |
| SSH | Option d'installation prévue, fonctionnement non encore testé |
| Samba / intégration AD | Non installés ou non testés à ce stade |

Les mots de passe et les identifiants de machine ne sont pas publiés.

## 2. Journal des manipulations validées

1. Première tentative d'installation de Debian 12 : une session GNOME a été observée. Cette VM a été supprimée à la demande de l'auteur pour reprendre de zéro.
2. Recréation de `FS1-GRE-SIEGE`, puis installation de Debian 12 en mode console. La sélection de logiciels demandée était **SSH + utilitaires usuels**, sans environnement de bureau. Le détail final des paquets installés reste à vérifier.
3. Démarrage de l'OS confirmé par la console `tty1` : `Debian GNU/Linux 12 fs1-gre-siege`.
4. Connexion locale confirmée : invite `administrateur@fs1-gre-siege:~$`.
5. Exécution de `hostnamectl` ; informations visibles dans la capture transmise :
   - `Static hostname: fs1-gre-siege`
   - `Operating System: Debian GNU/Linux 12 (bookworm)`
   - `Kernel: Linux 6.1.0-54-amd64`
   - `Architecture: x86-64`
   - `Virtualization: vmware`

**Preuve disponible :** capture de `hostnamectl` fournie dans la conversation le 03/11/2026 ; **cette image n'est pas encore déposée dans le dépôt GitHub**. Le présent journal documente l'observation et sa provenance.

## 3. Prochains tests (non réalisés)

- [ ] Relever l'adresse et le nom des interfaces avec `ip -br address`.
- [ ] Vérifier la route par défaut et le résolveur DNS, puis les mises à jour.
- [ ] Vérifier les ressources réelles de la VM après sa recréation.
- [ ] Raccorder FS1 au réseau LAN `VMnet1` et lui attribuer un adressage adapté, sans conflit avec DC1 ni la plage DHCP.
- [ ] Tester la connectivité vers pfSense et le DNS/contrôleur AD `DC1-GRE-SIEGE`.
- [ ] Vérifier et sécuriser le service SSH.
- [ ] Installer et configurer Samba ; concevoir les partages et les ACL.
- [ ] Intégrer le serveur Linux au domaine `ironman.test`, puis valider l'authentification et les accès depuis Windows 11.
- [ ] Documenter les captures, résultats de commandes et incidents avant de valoriser cette réalisation.

## Méthode

**Besoin → configuration → vérification → diagnostic → preuves → documentation.**

Aucun partage SMB ni accès AD n'est annoncé comme opérationnel à ce stade.

[Retour au README principal](../../README.md) · [Cahier des charges initial](../episode-02/README.md) · [Épisode 04 — Windows Server et AD](../episode-04/README.md)

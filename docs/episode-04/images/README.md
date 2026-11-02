# Preuves visuelles — ALPINA RETAIL, épisode 04

## 10 captures déjà téléversées et insérées dans le README

Ces fichiers existent dans le dépôt et sont illustrés dans [l'épisode 04](../README.md).

| Fichier | Preuve |
|---|---|
| `01-vmware-configuration-dc1.png` | Configuration matérielle de DC1 |
| `02-windows-server-renommage.png` | Renommage du serveur |
| `03-ipconfig-ipv4-statique.png` | IP statique et DNS |
| `04-ping-pfsense-internet.png` | Connectivité pfSense / Internet |
| `05-role-ad-ds-installe.png` | Installation du rôle AD DS |
| `06-promotion-prerequis-reussis.png` | Contrôles de promotion |
| `07-serveur-domaine-ironman.png` | Domaine `ironman.test` visible |
| `08-dcdiag-advertising.png` | Diagnostic Advertising réussi |
| `09-dns-srv-ldap.png` | Enregistrement SRV LDAP présent |
| `10-dns-nslookup-avertissement.png` | Anomalie `nslookup` initiale |

## 13 captures complémentaires préparées, NON encore téléversées

Ces captures réelles ont été sélectionnées lors du laboratoire du **2 novembre 2026**. L'archive locale à déposer sur GitHub contient les PNG suivants :

| Fichier à ajouter | Preuve observée |
|---|---|
| `11-net-share-sysvol-netlogon.png` | Partages essentiels à AD DS |
| `12-dcdiag-services-reussi.png` | Services et connectivité réussis |
| `13-dns-zone-inversee-absente.png` | Zone de recherche inversée initialement absente |
| `14-dns-zone-inversee-avant-ptr.png` | Zone inversée créée, sans PTR |
| `15-dns-ptr-enregistre.png` | Enregistrement PTR créé |
| `16-dns-nslookup-inverse-reussi.png` | Résolution inverse réussie |
| `17-dns-nslookup-direct-apres-correction.png` | Test initial répété sans message d'erreur |
| `18-dcdiag-dns-reussi.png` | Tests DNS ciblés réussis |
| `19-dns-externe-microsoft-reussi.png` | Nom public résolu par le DNS interne |
| `20-dhcp-serveur-autorise-ad.png` | Menu « Interdire » : DHCP autorisé |
| `21-dhcp-etendue-active.png` | Étendue du siège active |
| `22-dhcp-options-passerelle-dns-domaine.png` | Options 003, 006, 015 |
| `23-dhcp-plage-100-199.png` | Plage IPv4 contrôlée |

**Procédure de dépôt :** décompresser l'archive `ALPINA_RETAIL_Episode04_13_Captures_A_Ajouter_GitHub.zip`, ouvrir le dossier `docs/episode-04/images/` sur GitHub, sélectionner **Add file → Upload files**, ajouter les **13 PNG uniquement** et valider **Commit changes**. Après vérification de la présence des fichiers, intégrer les liens d'images et leurs légendes dans le README principal.

**Important :** ce tableau est un inventaire de travaux et ne prouve pas que les fichiers 11 à 23 soient déjà téléversés. Ne pas insérer de liens Markdown d'images inexistantes.

Ne pas publier de mots de passe, secrets, configuration pfSense complète ni données personnelles.

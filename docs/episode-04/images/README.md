# Preuves visuelles — ALPINA RETAIL, épisode 04

## Captures 01 à 10 — Déploiement initial

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

## Captures 11 à 23 — Vérifications et dépannage DNS / DHCP

Ces **13 captures complémentaires sont désormais téléversées et intégrées avec des légendes** dans [l'épisode 04](../README.md). Elles ont été réalisées lors du laboratoire du **2 novembre 2026** :

| Fichier publié | Preuve observée |
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

**Statut vérifié :** les 23 images PNG ci-dessus sont présentes dans ce dossier GitHub et sont toutes intégrées au README principal. Leurs légendes précisent les résultats observés et leurs limites. Le bail DHCP depuis un poste client et la jonction au domaine restent à vérifier.

Ne pas publier de mots de passe, secrets, configuration pfSense complète ni données personnelles.

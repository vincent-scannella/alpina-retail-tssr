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

## Captures 24 à 40 — Validation côté client et première GPO (3 novembre 2026)

Ces **17 captures authentiques** prolongent la séance du 2 novembre : bail réel, résolutions DNS sur le client, jonction au domaine, comptes, OU et réception de la stratégie ordinateur. Elles sont commentées dans [l'épisode 04](../README.md).

| Fichier | Preuve observée |
|---|---|
| [`24-dhcp-bail-client-ipconfig.png`](24-dhcp-bail-client-ipconfig.png) | Bail 10.10.10.100, DNS, passerelle et durée de huit jours |
| [`25-dns-client-nslookup-domaine.png`](25-dns-client-nslookup-domaine.png) | Résolution du nom ironman.test depuis Windows 11 |
| [`26-dns-client-srv-ldap.png`](26-dns-client-srv-ldap.png) | DNS SRV LDAP de découverte du DC, port 389 |
| [`27-ad-jonction-domaine-reussie.png`](27-ad-jonction-domaine-reussie.png) | Message de bienvenue au domaine ironman.test |
| [`28-ad-ecran-connexion-domaine.png`](28-ad-ecran-connexion-domaine.png) | Écran Windows proposant la connexion à IRONMAN |
| [`29-ad-authentification-administrateur.png`](29-ad-authentification-administrateur.png) | whoami : session de l'administrateur du domaine |
| [`30-ad-objet-ordinateur-computers.png`](30-ad-objet-ordinateur-computers.png) | Objet PC-TEST-GRE visible dans Computers |
| [`31-ad-ordinateur-deplace-ou-postes.png`](31-ad-ordinateur-deplace-ou-postes.png) | Objet PC-TEST-GRE déplacé dans l'OU POSTES |
| [`32-ad-ou-postes-utilisateurs.png`](32-ad-ou-postes-utilisateurs.png) | OU POSTES et UTILISATEURS sous GRE-SIEGE |
| [`33-ad-compte-test-grenoble.png`](33-ad-compte-test-grenoble.png) | Compte fictif Test Grenoble créé dans son OU |
| [`34-ad-authentification-utilisateur.png`](34-ad-authentification-utilisateur.png) | whoami : session IRONMAN test.gre |
| [`35-ad-groupes-utilisateur-standard.png`](35-ad-groupes-utilisateur-standard.png) | whoami /groups : Utilisateurs et intégrité moyenne |
| [`36-gpo-lien-ou-postes.png`](36-gpo-lien-ou-postes.png) | Stratégie de verrouillage liée à POSTES |
| [`37-gpo-inactivite-900-secondes.png`](37-gpo-inactivite-900-secondes.png) | Paramètre d'inactivité défini à 900 secondes |
| [`38-gpo-gpupdate-reussi.png`](38-gpo-gpupdate-reussi.png) | gpupdate /force : traitements sans erreur |
| [`39-gpo-registre-inactivitytimeoutsecs.png`](39-gpo-registre-inactivitytimeoutsecs.png) | Registre InactivityTimeoutSecs = 0x384 (900 s) |
| [`40-gpo-gpresult-ordinateur.png`](40-gpo-gpresult-ordinateur.png) | gpresult ordinateur : GPO ciblée appliquée |

**Bilan : 40 captures publiées**. La distribution DHCP, les connexions AD et la réception du paramètre GPO sont démontrées sur `PC-TEST-GRE`. **Le verrouillage automatique a ensuite été observé selon l'auteur (03/11/2026)**, mais aucune capture de ce comportement ni mesure chronométrée précise n'ont été fournies. Les captures 36 à 40 prouvent la configuration et l'application du paramètre à 900 s.



Ne pas publier de mots de passe, secrets, configuration pfSense complète ni données personnelles.

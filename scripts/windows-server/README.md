# Commandes PowerShell de la partie C

Ces fichiers regroupent les commandes exécutées dans le lab pour la [partie C](../../docs/partie-c-windows-server.md), dans l'ordre. Elles ont été lancées **une à une** dans une console PowerShell en administrateur, avec une vérification après chaque étape. Ces fichiers servent de référence : ils n'ont pas été rejoués d'un seul bloc.

| Fichier | Machine | Contenu |
|---|---|---|
| [`01-dc01-adressage.ps1`](01-dc01-adressage.ps1) | DC01 | Adresse fixe, DNS, renommage |
| [`02-dc01-promotion-ad.ps1`](02-dc01-promotion-ad.ps1) | DC01 | Rôle AD DS, forêt `lab.internal`, redirecteur DNS |
| [`03-dc01-dhcp.ps1`](03-dc01-dhcp.ps1) | DC01 | Étendue LAB-LAN, options, réservation de Zabbix |
| [`04-dc01-annuaire-partage-gpo.ps1`](04-dc01-annuaire-partage-gpo.ps1) | DC01 | OU, groupes, utilisateurs, partage RH, politique de mot de passe, GPO |
| [`05-client01-jonction-domaine.ps1`](05-client01-jonction-domaine.ps1) | CLIENT01 | Test du port LDAP et jonction au domaine |

**Aucun mot de passe n'est écrit dans ces fichiers** : ils sont toujours demandés par une invite masquée (`Read-Host -AsSecureString` ou `-Credential`).

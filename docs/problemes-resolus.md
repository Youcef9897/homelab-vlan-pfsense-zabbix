# Problèmes rencontrés et résolus

**Navigation :** [Accueil](../README.md) · [Partie A](partie-a-vlan.md) · [Partie B](partie-b-pfsense-zabbix.md) · [Partie C](partie-c-windows-server.md) · [Adressage](plan-adressage.md) · [Règles pfSense](regles-pfsense.md) · [Tests et supervision](tests-et-supervision.md) · Problèmes résolus · [Feuille de route](feuille-de-route.md)

> Garder une trace des erreurs fait partie des objectifs du projet. Voici les problèmes rencontrés, avec le symptôme, la démarche de diagnostic et la solution.

## 1. Un trunk mal configuré sur le switch (partie A)

**Symptôme.** Une fois la configuration terminée, plus aucun ping ne passait, même entre un PC et sa propre passerelle.

**Diagnostic.** Vérification avec `show vlan brief` et `show interfaces trunk`. Le trunk était configuré sur le port Fa0/4, alors que le câble vers le routeur était branché sur Gi0/1.

**Solution.** Configurer le trunk sur le bon port, Gi0/1. Tout est rentré dans l'ordre.

**À retenir.** Avant de configurer un trunk, vérifier sur quel port le câble est réellement branché.

## 2. Un problème réseau pendant l'installation de pfSense (partie B)

**Symptôme.** L'installation échouait systématiquement, faute d'accès à Internet pour télécharger l'image du système.

**Diagnostic.** Un `ping 8.8.8.8` depuis le terminal de l'installeur a montré que c'était la passerelle NAT de VirtualBox elle-même qui renvoyait une erreur.

**Solution.** Passer l'interface WAN du mode NAT au mode Bridge, directement sur la carte Wi-Fi.

**À retenir.** Un test de ping simple depuis l'installeur permet de savoir si le problème vient de la machine ou du réseau.

## 3. Une règle de blocage sans effet (pfSense)

**Symptôme.** La règle bloquant le ping avait un compteur à 0/0 B. **Cause.** Elle était placée sous « Default allow LAN to any », évaluée en premier. **Solution.** La remonter au-dessus. **À retenir.** Ordre des règles = première correspondance gagnante.

## 4. Le blocage du ping coupait la supervision (pfSense / Zabbix)

**Symptôme.** Alerte « Unavailable by ICMP ping » juste après le blocage de l'ICMP. **Cause probable** (déduite de la chronologie, le journal n'a pas gardé de trace de ces paquets). La règle bloquait aussi le ping de Zabbix vers pfSense. **Solution.** Ajouter au-dessus une règle autorisant l'echo request vers « This Firewall ». L'alerte s'est résolue seule.

## 5. SNMP « timed out » après changement de communauté (Zabbix)

**Symptôme.** Hôte rouge après remplacement de la chaîne communautaire. **Cause.** Valeur de la macro différente de celle de pfSense, et interface de l'hôte encore sur `public`. **Solution.** Interface sur `{$SNMP_COMMUNITY}` et valeur copiée-collée depuis pfSense.

## 6. « Cannot update host » dans Zabbix

**Symptôme.** Erreur « Cannot inherit item with key zabbix[host,snmp,available]… already inherited from template Generic by SNMP ». **Cause.** Deux modèles liés à l'hôte, dont l'un embarque déjà l'autre. **Solution.** Ne garder que « PFSense by SNMP ».

![Erreur Zabbix](img/26-zabbix-erreur-template.jpg)

## 7. Câbles de PC1 et PC2 inversés (Packet Tracer)

**Symptôme.** PC1 (VLAN 20) obtenait une adresse du VLAN 30. **Cause.** Mauvais ports du switch. **Solution.** Recâbler (PC1 sur Fa0/2, PC2 sur Fa0/3) puis `ipconfig /renew`.

## 8. Mauvais modèle de switch (Packet Tracer)

**Symptôme.** « Invalid interface type and number » puis commandes `switchport` rejetées. **Cause.** Le switch initial n'avait pas de ports Fa0/x. **Solution.** Remplacement par un 2960-24TT et recopie de la configuration.

![Erreurs de saisie](img/27-pt-erreurs-cli-switch.jpg)

## 9. Réseau Host-Only et DHCP de la VM Zabbix (VirtualBox)

**Constat.** L'appliance Zabbix prend 192.168.56.104 par DHCP (serveur .100) ; la plage DHCP du réseau Host-Only (.101 à .254) englobe l'adresse de pfSense (.254), et `VBoxManage list dhcpservers` indique « Enabled: No ». pfSense a aussi son propre serveur DHCP sur le LAN (plage .100 à .150), qui recouvre l'adresse .100 de celui de VirtualBox et l'adresse .104 de Zabbix. **À améliorer.** Créer une réservation DHCP pour la VM Zabbix (le tableau « Static Mappings » est vide) et ne garder qu'un serveur DHCP actif. **Résolu dans la version finale.** Le DHCP est désormais fourni par DC01, avec une réservation de 192.168.56.104 pour Zabbix ; seul ce serveur est actif ([partie C](partie-c-windows-server.md)).

![DHCP Host-Only](img/28-vbox-dhcp-host-only.jpg)

## 10. Ping de Zabbix vers Internet sans réponse (non résolu)

**Constat.** Zabbix perd 100 % des pings vers 8.8.8.8 et 1.1.1.1, alors que pfSense atteint 8.8.8.8 et que HTTP vers 1.1.1.1 répond. Une capture de paquets sur le WAN montre des requêtes ICMP sans réponse. **Cause non confirmée**, à investiguer. Ce constat date d'avant la règle de blocage ICMP : depuis, ce ping est bloqué volontairement, et le retester demande de désactiver temporairement la règle.

## 11. Le client ne pouvait pas joindre le domaine : profil réseau de DC01 en « Private » (partie C)

**Symptôme.** Depuis CLIENT01, le DHCP et le DNS fonctionnaient (`dc01.lab.internal` résolu en 192.168.56.10), mais `Test-NetConnection 192.168.56.10 -Port 389` renvoyait `TcpTestSucceeded : False`.

**Diagnostic.** Sur DC01, avec des commandes en lecture seule : services NTDS, DNS, Netlogon et DHCPServer démarrés, port 389 en écoute (`Get-NetTCPConnection`), mais `Get-NetConnectionProfile` affichait `NetworkCategory : Private` au lieu de `DomainAuthenticated`.

**Cause probable.** Après le redémarrage de DC01, la carte a été classée avant que l'Active Directory soit prêt : le pare-feu appliquait le profil « Privé » au lieu du profil « Domaine ».

**Solution.** `Restart-Service NlaSvc -Force` a expiré, mais `Restart-NetAdapter -Name "Ethernet"` a reclassé la carte en `DomainAuthenticated`. Le port 389 a répondu et la jonction au domaine a réussi.

**À retenir.** Quand un service est en écoute mais injoignable, vérifier le profil réseau et le pare-feu de la machine. Le problème peut revenir après un redémarrage de DC01 : une solution durable reste à étudier.

![Port 389 fermé vu du client](img/40-pb-client-ldap-bloque.jpg)

![Profil Private sur DC01](img/41-pb-dc01-profil-private.jpg)

![Profil DomainAuthenticated après correction](img/42-pb-dc01-profil-domainauthenticated.jpg)

## 12. Unités d'organisation « déjà utilisées » (partie C)

**Symptôme.** En relançant la création des OU : « An attempt was made to add an object to the directory with a name that is already in use ». **Cause.** La première exécution avait réussi. **Solution.** Vérifier l'état réel avec `Get-ADOrganizationalUnit` avant de relancer. **À retenir.** Écrire des scripts qui testent l'existence d'un objet avant de le créer (fait dans [`scripts/windows-server/`](../scripts/windows-server/)).

## 13. Fautes de frappe dans les commandes PowerShell (partie C)

**Symptôme.** Commandes rejetées : `Set-NetIPAddress` au lieu de `New-NetIPAddress`, `Install-ADDForest` (S manquant), `Add-DhcpServerLnDC`, `(Name` au lieu de `-Name`, `/gant` au lieu de `/grant` dans `icacls`, `dc01!lab!internal` sur un clavier en disposition anglaise, et des cmdlets PowerShell tapées dans `cmd`. **Cause.** Commandes recopiées à la main, sans presse-papiers partagé avec les VM, et disposition de clavier différente du clavier physique. **À retenir.** Installer les Additions invité de VirtualBox, vérifier la disposition du clavier avant de saisir un mot de passe, et travailler à partir de scripts `.ps1` relus.

## 14. Windows 10 Entreprise n'est plus proposé en évaluation (partie C)

**Symptôme.** La page d'évaluation de Windows 10 Entreprise renvoyait vers l'annonce de fin de support (14 octobre 2025). **Solution.** Utiliser Windows 11 Entreprise en évaluation (90 jours). **Conséquence.** La VM doit avoir EFI, TPM 2.0 et Secure Boot, activés avant le premier démarrage.

## 15. Installation du client Windows 11 (partie C)

- **Carte réseau en NAT** par défaut : le client n'aurait jamais reçu d'adresse de DC01. Passage en réseau privé hôte avant le premier démarrage.
- **« Press any key to boot from CD or DVD »** passé trop vite : « No bootable option ». Réinitialisation de la VM et appui immédiat sur une touche.
- **Compte Microsoft exigé** par l'assistant : l'option « Sign-in options > Domain join instead » crée un compte local, sans compte Microsoft ni Internet.

## Autres points de la version finale

- **Ctrl+Alt+Suppr** est intercepté par le PC hôte : utiliser le menu VirtualBox Entrée > Clavier > Insérer Ctrl-Alt-Suppr.
- **Écran noir** après le renommage de DC01 : une réinitialisation de la VM a suffi.
- **VM « Avortée »** après l'arrêt du PC : relancer avec « Démarrer », sans restaurer d'instantané (ce qui annulerait le travail fait depuis).

## Aller plus loin

Le déroulé détaillé, avec toutes les captures, se trouve dans le [rapport PDF final](../rapport/rapport-homelab-final.pdf).

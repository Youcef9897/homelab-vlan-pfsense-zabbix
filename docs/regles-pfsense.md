# Règles de filtrage pfSense

**Navigation :** [Accueil](../README.md) · [Partie A](partie-a-vlan.md) · [Partie B](partie-b-pfsense-zabbix.md) · [Adressage](plan-adressage.md) · Règles pfSense · [Tests et supervision](tests-et-supervision.md) · [Problèmes résolus](problemes-resolus.md) · [Feuille de route](feuille-de-route.md)

## Règle en place

| # | Interface | Action | Protocole | Source | Destination | Objectif | Statut |
|---|---|---|---|---|---|---|---|
| 1 | LAN | Bloquer | ICMP | Tous | Tous | Règle de test pour valider le fonctionnement du filtrage | Appliquée (voir la capture « Règle de pare-feu créée sur pfSense » dans la page Partie B) |

**À documenter** : le résultat du test, c'est-à-dire un `ping` depuis une machine du LAN avant l'application de la règle (réponse reçue) et après (aucune réponse). Une capture de chaque cas suffit.

## Règles prévues

Ce tableau est une liste de pistes à tester, pas un état des lieux. Chaque ligne devient une règle réelle une fois créée, testée et documentée.

| # | Interface | Action | Protocole | Source | Destination | Objectif | Test à réaliser | Statut |
|---|---|---|---|---|---|---|---|---|
| 2 | LAN | Autoriser | TCP/UDP | Réseau LAN | Internet | Laisser les machines du LAN sortir | Ouvrir une page web depuis une machine du LAN | À faire |
| 3 | LAN | Autoriser | UDP/TCP 53 | Réseau LAN | pfSense (DNS) | Permettre la résolution de noms | `nslookup` depuis une machine du LAN | À faire |
| 4 | LAN | Autoriser | UDP 161 | Zabbix (192.168.56.104) | pfSense (LAN) | Maintenir la supervision SNMP une fois le filtrage durci | Vérifier que l'hôte reste en vert dans Zabbix | À faire |
| 5 | WAN | Bloquer | Tous | Tous | Réseau LAN | Vérifier le comportement par défaut du WAN | Test de connexion depuis l'extérieur du lab | À faire |

## Bonnes pratiques à documenter

- Ordre des règles : pfSense les évalue de haut en bas et applique la première qui correspond. Noter pourquoi chaque règle est à sa place.
- Journalisation : indiquer les règles dont les blocages sont journalisés, et où consulter ces journaux.
- Sauvegarde : exporter la configuration de pfSense (Diagnostics > Backup & Restore) avant de modifier les règles, et ne jamais publier cet export tel quel dans un dépôt public, car il peut contenir des secrets.

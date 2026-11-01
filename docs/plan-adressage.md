# Plan d'adressage et interfaces

Ce document détaille l'adressage IP des deux parties du lab. Les cellules marquées **À compléter** attendent une valeur que seul le lab permet de relever.

## Partie A — VLAN (Packet Tracer)

Matériel simulé : switch Cisco 2960-24TT (SW-CNNA2) et routeur Cisco 2911 (R-CNNA2). Le switch est relié au routeur par un lien trunk 802.1Q sur le port Gi0/1. Le routeur assure le routage inter-VLAN avec une sous-interface par VLAN (router-on-a-stick).

| VLAN | Nom | Réseau | Passerelle (sous-interface du routeur) | DHCP | Plage distribuée |
|---|---|---|---|---|---|
| 10 | ADMIN | 192.168.10.0/24 | 192.168.10.1 | Oui | **À compléter** |
| 20 | RH | 192.168.20.0/24 | 192.168.20.1 | Oui | **À compléter** |
| 30 | INVITES | 192.168.30.0/24 | 192.168.30.1 | Oui | **À compléter** |

Politique de sécurité : une ACL empêche le VLAN 30 (INVITES) de communiquer avec le VLAN 10 (ADMIN).

Pour compléter les plages DHCP, relever la configuration du routeur avec `show running-config` et reprendre les lignes `ip dhcp pool` et `ip dhcp excluded-address`.

## Partie B — pfSense et Zabbix (VirtualBox)

| Machine | Interface | Adresse | Mode VirtualBox | Rôle |
|---|---|---|---|---|
| pfSense | WAN | Obtenue en DHCP | Bridge sur la carte Wi-Fi | Sortie vers Internet |
| pfSense | LAN | 192.168.56.254/24 | Réseau privé hôte (Host-Only) | Passerelle du lab, serveur DHCP |
| Zabbix | LAN | 192.168.56.104 | Réseau privé hôte (Host-Only) | Supervision de pfSense via SNMP |
| PC hôte | Host-Only | 192.168.56.x | Réseau privé hôte (Host-Only) | Administration (interface web de pfSense sur http://192.168.56.254) |

Plage DHCP du LAN pfSense : **À compléter** (Services > DHCP Server > LAN).

## Interface WAN de pfSense

Le WAN est en mode Bridge sur la carte Wi-Fi de l'hôte et reçoit son adresse par DHCP depuis la box. Le mode NAT de VirtualBox avait été essayé en premier : l'installation de pfSense échouait faute d'accès à Internet, et un `ping 8.8.8.8` depuis l'installeur a montré que la passerelle NAT renvoyait elle-même une erreur. Le passage en Bridge a réglé le problème.

> Ne publie pas l'adresse WAN réelle dans ce dépôt public : elle vient de ton réseau domestique. Masque-la sur les captures d'écran qui l'affichent.

## Interface LAN de pfSense

Le LAN est aligné sur le réseau Host-Only de VirtualBox (192.168.56.0/24), pour que le PC hôte et la VM Zabbix soient dans le même réseau que pfSense. Le serveur DHCP de pfSense est actif sur cette interface.

## À compléter

- [ ] Plages DHCP des trois VLAN (partie A)
- [ ] Plage DHCP du LAN pfSense (partie B)
- [ ] Schéma unique regroupant les deux parties

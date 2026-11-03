# Plan d'adressage et interfaces

**Navigation :** [Accueil](../README.md) · [Partie A](partie-a-vlan.md) · [Partie B](partie-b-pfsense-zabbix.md) · [Partie C](partie-c-windows-server.md) · Adressage · [Règles pfSense](regles-pfsense.md) · [Tests et supervision](tests-et-supervision.md) · [Problèmes résolus](problemes-resolus.md) · [Feuille de route](feuille-de-route.md)

Ce document détaille l'adressage IP du lab. Les valeurs viennent des configurations réelles du lab (voir [`configs/`](../configs/)).

## Partie A — VLAN (Packet Tracer)

Matériel simulé : switch Cisco 2960-24TT (SW-CNNA2) et routeur Cisco 2901 (R-CNNA2). Le switch est relié au routeur par un lien trunk 802.1Q sur le port Gi0/1. Le routeur assure le routage inter-VLAN avec une sous-interface par VLAN (router-on-a-stick).

| VLAN | Nom | Réseau | Passerelle (sous-interface du routeur) | DHCP | Plage distribuée |
|---|---|---|---|---|---|
| 10 | ADMIN | 192.168.10.0/24 | 192.168.10.1 | Oui | 192.168.10.21 à .254 (.1 à .20 exclues) |
| 20 | RH | 192.168.20.0/24 | 192.168.20.1 | Oui | 192.168.20.21 à .254 (.1 à .20 exclues) |
| 30 | INVITES | 192.168.30.0/24 | 192.168.30.1 | Oui | 192.168.30.21 à .254 (.1 à .20 exclues) |
| 99 | NATIF | (aucun) | (aucune) | Non | VLAN natif du trunk et ports inutilisés |

Politique de sécurité : une ACL empêche le VLAN 30 (INVITES) de communiquer avec le VLAN 10 (ADMIN).

Le switch est administrable sur 192.168.10.2 (interface Vlan10, passerelle 192.168.10.1). Les configurations complètes, sans secret, sont dans [`configs/`](../configs/). Le serveur DNS distribué est 8.8.8.8.

## Parties B et C — réseau VirtualBox

| Machine | Interface | Adresse | Mode VirtualBox | Rôle |
|---|---|---|---|---|
| pfSense | WAN | Obtenue en DHCP | Bridge sur la carte Wi-Fi | Sortie vers Internet |
| pfSense | LAN | 192.168.56.254/24 | Réseau privé hôte (Host-Only) | Passerelle du lab, relais DNS |
| DC01 (Windows Server 2022) | LAN | 192.168.56.10/24 (fixe) | Réseau privé hôte (Host-Only) | Contrôleur de domaine `lab.internal` : AD DS, DNS, DHCP |
| Zabbix | LAN | 192.168.56.104 (réservation DHCP) | Réseau privé hôte (Host-Only) | Supervision de pfSense via SNMP |
| CLIENT01 (Windows 11) | LAN | DHCP (192.168.56.100 observé) | Réseau privé hôte (Host-Only) | Poste client membre du domaine |
| PC hôte | Host-Only | 192.168.56.x | Réseau privé hôte (Host-Only) | Administration (interface web de pfSense sur http://192.168.56.254) |

**Dans la version finale, le DHCP du LAN est fourni par DC01** : étendue **LAB-LAN**, plage **192.168.56.100 à 192.168.56.150**, passerelle 192.168.56.254, DNS 192.168.56.10, domaine `lab.internal`, bail de 2 heures. L'adresse 192.168.56.104 est **réservée** pour Zabbix. Le serveur DHCP de pfSense et celui du réseau Host-Only de VirtualBox sont désactivés : un seul serveur DHCP est actif.

En version 1, c'était pfSense qui distribuait cette même plage, avec la passerelle et le DNS en 192.168.56.254, et l'adresse de Zabbix n'était qu'un bail sans réservation.

## Interface WAN de pfSense

Le WAN est en mode Bridge sur la carte Wi-Fi de l'hôte et reçoit son adresse par DHCP depuis la box. Le mode NAT de VirtualBox avait été essayé en premier : l'installation de pfSense échouait faute d'accès à Internet, et un `ping 8.8.8.8` depuis l'installeur a montré que la passerelle NAT renvoyait elle-même une erreur. Le passage en Bridge a réglé le problème.

> Ne publie pas l'adresse WAN réelle dans ce dépôt public : elle vient de ton réseau domestique. Masque-la sur les captures d'écran qui l'affichent.

## Interface LAN de pfSense

Le LAN est aligné sur le réseau Host-Only de VirtualBox (192.168.56.0/24), pour que le PC hôte et les VM soient dans le même réseau que pfSense. Le serveur DHCP de pfSense est désactivé sur cette interface depuis la bascule vers DC01.

## À compléter

- [x] Plages DHCP des trois VLAN (partie A)
- [x] Plage DHCP du LAN pfSense (partie B)
- [x] Réserver l'adresse de Zabbix (réservation sur le DHCP de DC01)
- [x] Schéma d'ensemble (`docs/img/schema-homelab-final.png`)

# Partie B — pfSense et Zabbix (VirtualBox)

**Navigation :** [Accueil](../README.md) · [Partie A](partie-a-vlan.md) · Partie B · [Adressage](plan-adressage.md) · [Règles pfSense](regles-pfsense.md) · [Tests et supervision](tests-et-supervision.md) · [Problèmes résolus](problemes-resolus.md) · [Feuille de route](feuille-de-route.md)

> **En bref** : un pare-feu pfSense installé et sécurisé dans une VM VirtualBox, avec une première règle de filtrage, et un serveur Zabbix qui le supervise en temps réel via SNMP.

## Topologie

Mon PC et les deux VM partagent un réseau privé hôte en 192.168.56.0/24 :

```
PC hôte ── Host-Only 192.168.56.0/24 ── pfSense (LAN : 192.168.56.254)
pfSense (WAN) ── mode Bridge sur la carte Wi-Fi ── Internet
Zabbix (192.168.56.104) ── supervise pfSense via SNMP
```

Le détail des interfaces et des adresses est dans la page [Adressage](plan-adressage.md).

## Étapes réalisées

1. **Installer pfSense CE 2.9.0** dans une VM VirtualBox. L'interface WAN est en mode Bridge sur la carte Wi-Fi, car le mode NAT empêchait l'installation (voir [Problèmes résolus](problemes-resolus.md)).
2. **Configurer l'interface LAN** en 192.168.56.254/24, alignée sur le réseau Host-Only de VirtualBox, avec le serveur DHCP actif.
3. **Accéder à l'interface web** de pfSense sur http://192.168.56.254 depuis le PC hôte, et changer le mot de passe administrateur par défaut.
4. **Créer une première règle de pare-feu** : une règle de test qui bloque l'ICMP sur le LAN, appliquée avec succès. Voir [Règles pfSense](regles-pfsense.md).
5. **Déployer Zabbix 7.0 LTS** sous forme d'appliance préconfigurée VirtualBox, sur le même réseau Host-Only, en 192.168.56.104.
6. **Superviser pfSense via SNMP** : l'hôte apparaît disponible dans Zabbix et ses métriques remontent en direct.

## Captures d'écran

**Interface pfSense — tableau de bord** — vue d'ensemble du pare-feu une fois installé et configuré (interfaces WAN/LAN, état du système) :

<img width="1370" height="1614" alt="Tableau de bord pfSense avec les interfaces WAN et LAN et l'état du système" src="https://github.com/user-attachments/assets/3ca5becd-1257-41ed-a440-bcb91925c085" />

**Règle de pare-feu créée sur pfSense** — règle de test bloquant le trafic ICMP sur l'interface LAN, appliquée avec succès :

<img width="1334" height="1476" alt="Règle pfSense de test bloquant le trafic ICMP sur l'interface LAN" src="https://github.com/user-attachments/assets/b176a4ce-ee0c-43d1-8557-62c2de301eab" />

**Supervision Zabbix — état de l'hôte pfSense** — pfSense apparaît disponible en SNMP (statut vert), confirmant que la supervision fonctionne :

<img width="2798" height="1598" alt="Zabbix : l'hôte pfSense est disponible en SNMP (statut vert)" src="https://github.com/user-attachments/assets/0f2f6024-39af-412d-8ece-4791066c1ea9" />

**Supervision Zabbix — métriques en temps réel** — données remontées automatiquement par Zabbix (disponibilité, temps de réponse, durée de fonctionnement), preuve que la supervision collecte des données réelles :

<img width="2792" height="1606" alt="Zabbix : métriques de pfSense remontées en temps réel (disponibilité, temps de réponse, durée de fonctionnement)" src="https://github.com/user-attachments/assets/08c3a14c-6e92-4799-b355-80e3a2eb0fc9" />

## Pour aller plus loin

- Les tests réalisés et ceux à faire sont dans [Tests et supervision](tests-et-supervision.md), avec le plan des graphiques et des alertes Zabbix.
- Cette partie n'est pas encore reliée à la [Partie A](partie-a-vlan.md) : c'est un objectif de l'étape 1 de la [feuille de route](feuille-de-route.md).

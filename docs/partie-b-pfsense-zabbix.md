# Partie B — pfSense et Zabbix (VirtualBox)

**Navigation :** [Accueil](../README.md) · [Partie A](partie-a-vlan.md) · Partie B · [Partie C](partie-c-windows-server.md) · [Adressage](plan-adressage.md) · [Règles pfSense](regles-pfsense.md) · [Tests et supervision](tests-et-supervision.md) · [Problèmes résolus](problemes-resolus.md) · [Feuille de route](feuille-de-route.md)

> **En bref** : un pare-feu pfSense installé et sécurisé dans une VM VirtualBox, avec des règles de filtrage testées et journalisées, et un serveur Zabbix qui le supervise via SNMP (tableau de bord et alerte de disponibilité).

## Topologie

Mon PC et les deux VM partagent un réseau privé hôte en 192.168.56.0/24 :

```
PC hôte ── Host-Only 192.168.56.0/24 ── pfSense (LAN : 192.168.56.254)
pfSense (WAN) ── mode Bridge sur la carte Wi-Fi ── Internet
Zabbix (192.168.56.104) ── supervise pfSense via SNMP
```

Le détail des interfaces et des adresses est dans la page [Adressage](plan-adressage.md).

> Dans la version finale, le contrôleur de domaine DC01 (192.168.56.10) a rejoint ce réseau et fournit le DHCP du LAN à la place de pfSense. Voir la [partie C](partie-c-windows-server.md).

## Étapes réalisées

1. **Installer pfSense CE 2.9.0** dans une VM VirtualBox. L'interface WAN est en mode Bridge sur la carte Wi-Fi, car le mode NAT empêchait l'installation (voir [Problèmes résolus](problemes-resolus.md)).
2. **Configurer l'interface LAN** en 192.168.56.254/24, alignée sur le réseau Host-Only de VirtualBox, avec le serveur DHCP actif.
3. **Accéder à l'interface web** de pfSense sur http://192.168.56.254 depuis le PC hôte, et changer le mot de passe administrateur par défaut.
4. **Écrire les règles de pare-feu** : blocage de Telnet et SMTP sortants, ping encadré, journalisation. Voir [Règles pfSense](regles-pfsense.md).
5. **Déployer Zabbix 7.0 LTS** sous forme d'appliance préconfigurée VirtualBox, sur le même réseau Host-Only, en 192.168.56.104.
6. **Superviser pfSense via SNMP** : l'hôte apparaît disponible dans Zabbix et ses métriques remontent en direct.
7. **Durcir le SNMP** : chaîne communautaire personnalisée (macro Zabbix en texte secret), écoute limitée au LAN.
8. **Valider** : tableau de bord, alerte de disponibilité, tests de blocage. Voir [Tests et supervision](tests-et-supervision.md).

## Captures d'écran

**Interface pfSense — tableau de bord** — vue d'ensemble du pare-feu une fois installé et configuré (interfaces WAN/LAN, état du système) :

<img width="1370" height="1614" alt="Tableau de bord pfSense avec les interfaces WAN et LAN et l'état du système" src="https://github.com/user-attachments/assets/3ca5becd-1257-41ed-a440-bcb91925c085" />

**Règles de pare-feu** — les règles finales du LAN (Telnet/SMTP bloqués, ping encadré) sont détaillées, avec leurs tests, dans [Règles pfSense](regles-pfsense.md).

**Supervision Zabbix — état de l'hôte pfSense** — pfSense apparaît disponible en SNMP (statut vert), confirmant que la supervision fonctionne :

<img width="2798" height="1598" alt="Zabbix : l'hôte pfSense est disponible en SNMP (statut vert)" src="https://github.com/user-attachments/assets/0f2f6024-39af-412d-8ece-4791066c1ea9" />

**Supervision Zabbix — métriques en temps réel** — données remontées automatiquement par Zabbix (disponibilité, temps de réponse, durée de fonctionnement), preuve que la supervision collecte des données réelles :

<img width="2792" height="1606" alt="Zabbix : métriques de pfSense remontées en temps réel (disponibilité, temps de réponse, durée de fonctionnement)" src="https://github.com/user-attachments/assets/08c3a14c-6e92-4799-b355-80e3a2eb0fc9" />

## Pour aller plus loin

- Les tests réalisés et ceux à faire sont dans [Tests et supervision](tests-et-supervision.md), avec le tableau de bord et l'alerte Zabbix.
- Cette partie n'est pas encore reliée à la [Partie A](partie-a-vlan.md) : c'est un objectif de l'étape 1 de la [feuille de route](feuille-de-route.md).

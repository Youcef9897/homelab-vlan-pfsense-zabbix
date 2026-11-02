# Feuille de route

**Navigation :** [Accueil](../README.md) · [Partie A](partie-a-vlan.md) · [Partie B](partie-b-pfsense-zabbix.md) · [Adressage](plan-adressage.md) · [Règles pfSense](regles-pfsense.md) · [Tests et supervision](tests-et-supervision.md) · [Problèmes résolus](problemes-resolus.md) · Feuille de route

Le projet suit un fil conducteur : **réseaux, puis systèmes, puis supervision, puis sécurité**. Chaque étape a un livrable et un critère de fin, pour savoir quand passer à la suivante. Les cases cochées sont faites.

## Étape 1 — Finaliser l'infrastructure réseau (en cours)

**Livrable** : une première version documentée de l'infrastructure.

- [x] VLAN, routage inter-VLAN, DHCP et ACL (partie A)
- [x] pfSense installé et sécurisé
- [x] Zabbix installé, pfSense supervisé via SNMP
- [x] Réaliser un schéma réseau unique
- [x] Compléter le [plan d'adressage](plan-adressage.md) (plages DHCP des trois VLAN et du LAN pfSense)
- [x] Créer, tester et documenter les [règles pfSense](regles-pfsense.md)
- [x] Réaliser les tests de connectivité côté pfSense, voir [Tests et supervision](tests-et-supervision.md) (ping Zabbix vers Internet à investiguer)
- [x] Ajouter un tableau de bord et une alerte de disponibilité dans Zabbix (alerte CPU : amélioration ultérieure)
- [x] Exporter les configurations (sans aucun secret) dans le dépôt, voir [`configs/`](../configs/)
- [ ] Relier la [partie A](partie-a-vlan.md) et la [partie B](partie-b-pfsense-zabbix.md), par exemple en reproduisant les VLAN derrière pfSense dans GNS3

**Étape terminée quand** : toutes les cases sont cochées et le rapport PDF est à jour.

## Étape 2 — Ajouter des systèmes

**Livrable** : un petit parc de machines qui communiquent correctement derrière pfSense.

- [ ] Déployer un serveur Windows Server
- [ ] Mettre en place Active Directory : domaine, comptes, groupes, permissions
- [ ] Déployer un client Windows et le joindre au domaine
- [ ] Déployer un serveur Linux et documenter son administration
- [ ] Placer toutes les machines derrière pfSense
- [ ] Ajouter ces machines à la supervision Zabbix
- [ ] Documenter l'ensemble

**Étape terminée quand** : les machines communiquent entre elles, passent par pfSense et sont supervisées.

## Étape 3 — Ajouter une dimension cybersécurité

**Livrable** : des scénarios de sécurité observés et documentés.

- [ ] Déployer un outil de collecte et d'analyse des événements de sécurité, comme Wazuh
- [ ] Installer des agents sur les machines Windows et Linux
- [ ] Réaliser des scénarios de test dans le lab (par exemple des tentatives de connexion échouées ou un scan de ports)
- [ ] Observer les événements collectés
- [ ] Documenter les résultats

**Étape terminée quand** : plusieurs scénarios sont reproductibles et documentés avec leurs résultats.

## Pistes optionnelles

- [ ] Un système de détection d'intrusion (Suricata ou Snort) sur pfSense
- [ ] Un accès distant sécurisé via VPN (OpenVPN)

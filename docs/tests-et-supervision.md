# Tests de connectivité et supervision

## Tests réalisés

### Partie A — VLAN (Packet Tracer)

| Test | Commande ou action | Résultat attendu | Résultat obtenu | Statut |
|---|---|---|---|---|
| Affectation des ports aux VLAN | `show vlan brief` | Chaque port dans son VLAN | Conforme (capture du README) | Réalisé |
| Transport des VLAN sur le trunk | `show interfaces trunk` | Les trois VLAN transportés vers le routeur | Conforme (capture du README) | Réalisé |
| Routage inter-VLAN | `ping` entre deux PC de VLAN différents | Réponse reçue | Ping réussi (capture du README) | Réalisé |
| Table de routage | `show ip route` sur le routeur | Trois réseaux directement connectés (code C) | Conforme (capture du README) | Réalisé |
| ACL Invités vers Admin | `ping` du VLAN 30 vers le VLAN 10 | Pas de réponse | « Destination host unreachable » (capture du README) | Réalisé |

### Partie B — pfSense et Zabbix (VirtualBox)

| Test | Commande ou action | Résultat attendu | Résultat obtenu | Statut |
|---|---|---|---|---|
| Accès à l'interface web de pfSense | Ouvrir http://192.168.56.254 depuis le PC hôte | Page de connexion | Accessible | Réalisé |
| Supervision SNMP | Hôte pfSense dans Zabbix | Disponibilité en vert | En vert, métriques en direct (captures du README) | Réalisé |
| Règle de blocage ICMP | `ping` depuis le LAN avant puis après la règle | Réponse avant, aucune réponse après | **À documenter** | À faire |
| Sortie vers Internet | Page web ou `ping 8.8.8.8` depuis une machine du LAN | Accès fonctionnel | **À documenter** | À faire |
| Résolution DNS | `nslookup` depuis une machine du LAN | Nom résolu | **À documenter** | À faire |

## Supervision Zabbix

### Situation actuelle

pfSense est supervisé par l'appliance Zabbix 7.0 LTS via SNMP. L'hôte apparaît disponible, avec les métriques de disponibilité, de temps de réponse et de durée de fonctionnement.

### À ajouter

1. **Graphiques** : au moins le processeur, la mémoire et le trafic des interfaces WAN et LAN de pfSense.
2. **Alerte « pfSense injoignable »** : un déclencheur (trigger) qui passe en problème quand l'hôte ne répond plus.
3. **Alerte « processeur élevé »** : un déclencheur sur l'utilisation du processeur avec un seuil que tu choisis et que tu justifies.
4. **Test des alertes** : éteindre la VM pfSense, vérifier que l'alerte apparaît dans Zabbix, la capturer, puis rallumer la VM et vérifier le retour à la normale.

### Bonne pratique

La communauté SNMP par défaut est connue de tout le monde. Même dans un lab, utilise une valeur personnalisée et ne la publie pas dans ce dépôt public.

## À compléter

- [ ] Résultats des trois tests marqués « À documenter »
- [ ] Captures des graphiques Zabbix
- [ ] Capture de l'alerte déclenchée puis résolue

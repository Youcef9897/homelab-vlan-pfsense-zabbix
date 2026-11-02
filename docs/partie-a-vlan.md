# Partie A — VLAN et routage inter-VLAN (Packet Tracer)

**Navigation :** [Accueil](../README.md) · Partie A · [Partie B](partie-b-pfsense-zabbix.md) · [Adressage](plan-adressage.md) · [Règles pfSense](regles-pfsense.md) · [Tests et supervision](tests-et-supervision.md) · [Problèmes résolus](problemes-resolus.md) · [Feuille de route](feuille-de-route.md)

> **En bref** : trois VLAN sur un switch Cisco 2960-24TT, un routage inter-VLAN assuré par un routeur 2901 (router-on-a-stick), un serveur DHCP par VLAN, et une ACL qui isole le VLAN Invités du VLAN Admin.

## Topologie

Trois PC sont connectés à un switch, chacun sur un VLAN différent. Le switch est relié au routeur par un lien trunk en 802.1Q, et c'est le routeur qui gère le routage entre les trois réseaux :

```
PC0 (VLAN 10, ADMIN) ──┐
PC1 (VLAN 20, RH)    ──┼── Switch SW-CNNA2 ── trunk 802.1Q ── Routeur R-CNNA2
PC2 (VLAN 30, INVITES)─┘
```

Les adresses de chaque VLAN sont dans la page [Adressage](plan-adressage.md).

**Topologie réseau complète** — 3 PC répartis sur 3 VLAN, reliés à un switch, lui-même connecté au routeur via un lien trunk :

<img width="2880" height="1702" alt="Topologie Packet Tracer : trois PC sur trois VLAN reliés à un switch, lui-même relié au routeur par un lien trunk" src="https://github.com/user-attachments/assets/b5a9f1d0-9ef4-4227-ba1a-1c7e39eb1404" />

## Étapes réalisées

1. **Créer les trois VLAN** sur le switch Cisco 2960-24TT (10 ADMIN, 20 RH, 30 INVITES) et affecter les ports des PC.
2. **Configurer le lien trunk 802.1Q** vers le routeur, sur le port Gi0/1.
3. **Configurer le routage inter-VLAN** sur le routeur 2901, avec une sous-interface par VLAN. Chaque sous-interface sert de passerelle à son VLAN.
4. **Ajouter un serveur DHCP** pour chacun des trois VLAN.
5. **Ajouter une ACL** pour empêcher le VLAN Invités de communiquer avec le VLAN Admin.
6. **Valider l'ensemble** avec les vérifications ci-dessous.

## Vérifications

**Vérification des VLAN et du trunk** — commandes `show vlan brief` et `show interfaces trunk` confirmant que chaque port est bien assigné à son VLAN, et que le lien vers le routeur transporte bien les 3 VLAN :

<img width="1400" height="1398" alt="Sortie des commandes show vlan brief et show interfaces trunk sur le switch" src="https://github.com/user-attachments/assets/5c94b34f-740e-4675-adce-9528750336bc" />

**Test de connectivité inter-VLAN** — ping réussi entre deux PC de VLAN différents, preuve que le routage inter-VLAN fonctionne correctement :

<img width="2880" height="1700" alt="Ping réussi entre deux PC situés dans des VLAN différents" src="https://github.com/user-attachments/assets/725812a8-b96c-4abb-b70c-6b58d69c6ee6" />

**Table de routage du routeur** — commande `show ip route`, les 3 réseaux apparaissent comme directement connectés (code C), confirmant que le routeur gère bien les 3 VLAN :

<img width="2774" height="668" alt="Sortie de show ip route : les trois réseaux VLAN apparaissent comme directement connectés" src="https://github.com/user-attachments/assets/a7ea6472-c1b3-48c0-8239-4fb9c1e4d437" />

**Vérification de l'ACL de sécurité** — le PC du VLAN Invités ne peut plus joindre le PC du VLAN Admin ("Destination host unreachable"), preuve que l'ACL fonctionne comme prévu :

<img width="2878" height="872" alt="Ping depuis le VLAN Invités vers le VLAN Admin bloqué par l'ACL : Destination host unreachable" src="https://github.com/user-attachments/assets/3d63bd49-95fe-4261-ad49-f1c278969761" />

## Durcissement de l'administration

- **SSH version 2 uniquement**, avec compte local ; Telnet désactivé (`transport input ssh`).
- **Accès restreint au VLAN 10** : `access-list 10` appliquée sur les lignes vty. Un PC du VLAN 20 voit sa connexion SSH refusée (« Connection refused by remote host »).
- **Ports inutilisés** du switch placés en VLAN 99 (natif) et coupés (`shutdown`) ; le trunk Gi0/1 autorise uniquement les VLAN 10, 20, 30 et 99.

![PC0 : ping vers le VLAN 20 réussi, SSH vers le routeur accepté](img/00-pt-pc0-ping-ssh.jpg)

![PC1 (VLAN 20) : SSH refusé](img/23-pt-pc1-ssh-refuse.jpg)

## Pour aller plus loin

- La configuration complète est dans le [rapport PDF](https://github.com/user-attachments/files/32176285/Rapport-Projet-Homelab-VLAN.pdf).
- Un problème de trunk rencontré pendant cette partie est détaillé dans [Problèmes résolus](problemes-resolus.md).
- Les configurations du switch et du routeur (sans secret) sont dans [`configs/`](../configs/).
- Les problèmes rencontrés (câbles inversés, mauvais modèle de switch…) sont dans [Problèmes résolus](problemes-resolus.md).

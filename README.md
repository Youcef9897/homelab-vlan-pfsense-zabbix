# 1 Homelab Réseau — VLAN, pfSense & Zabbix :

Ce dépôt regroupe un projet personnel que j'ai commencé en parallèle de ma formation CCNA2. L'idée de départ était simple : ne pas me contenter de la théorie et des quiz, mais construire un vrai petit réseau de A à Z, avec ses VLAN, son pare-feu et sa supervision, pour mieux comprendre comment tout ça s'articule en pratique.

## 2 Contexte et objectifs :

Je suis étudiant en cycle ingénieur, actuellement en CCNA2, avec l'ambition de continuer vers le CCNA3 puis CompTIA Security+. Ce homelab est pensé pour grandir avec ma formation, et pour me donner un vrai projet concret à présenter en entretien plutôt qu'une simple liste de certifications.

Ce que je voulais accomplir avec cette première phase :

- Mettre en pratique la segmentation réseau avec des VLAN
- Configurer un routage inter-VLAN (router-on-a-stick) sur un routeur Cisco
- Ajouter un pare-feu réel pour sécuriser le réseau (pfSense)
- Mettre en place une supervision pour surveiller l'infrastructure (Zabbix)
- Garder une trace précise de chaque étape, y compris des erreurs rencontrées en cours de route

## 3 Ce qui a été utilisé

- Cisco Packet Tracer, pour la partie VLAN, routage inter-VLAN, DHCP et ACL
- VirtualBox, comme hyperviseur pour pfSense et Zabbix
- pfSense CE 2.9.0, en tant que pare-feu et routeur de bordure
- Zabbix 7.0 LTS, pour la supervision réseau via SNMP
- GNS3, installé et fonctionnel, prévu pour une prochaine extension du lab

## 4 Topologie

**Partie VLAN, sous Packet Tracer**

Trois PC sont connectés à un switch, chacun sur un VLAN différent. Le switch est relié au routeur par un lien trunk en 802.1Q, et c'est le routeur qui gère le routage entre les trois réseaux :

PC0 (VLAN 10, ADMIN) → Switch SW-CNNA2
PC1 (VLAN 20, RH) → Switch SW-CNNA2
PC2 (VLAN 30, INVITES) → Switch SW-CNNA2
Switch SW-CNNA2 → trunk 802.1Q → Routeur R-CNNA2

Le VLAN 10 (ADMIN) utilise le réseau 192.168.10.0/24, avec 192.168.10.1 comme passerelle. Le VLAN 20 (RH) est sur 192.168.20.0/24, passerelle 192.168.20.1. Le VLAN 30 (INVITES) est sur 192.168.30.0/24, passerelle 192.168.30.1.

**Partie pfSense et Zabbix, sous VirtualBox**

Mon PC et les deux VM partagent un réseau privé hôte en 192.168.56.0/24 :

PC hôte → réseau Host-Only 192.168.56.0/24 → pfSense (LAN : 192.168.56.254)
pfSense (WAN) → mode bridge sur Wi-Fi → accès Internet
Zabbix (192.168.56.104) → supervise pfSense via SNMP

## 5 Ce qui a été réalisé

J'ai créé et configuré trois VLAN sur un switch Cisco 2960-24TT, avec le routage inter-VLAN correspondant sur un routeur 2911, en passant par des sous-interfaces. J'ai ensuite ajouté un serveur DHCP pour chacun des trois VLAN, puis une liste de contrôle d'accès pour empêcher le VLAN Invités de communiquer avec le VLAN Admin.

Côté sécurité et supervision, j'ai installé et sécurisé un pare-feu pfSense, avec une première règle de filtrage fonctionnelle, puis déployé Zabbix pour superviser pfSense en temps réel via SNMP. L'ensemble du processus est documenté dans le rapport complet, disponible dans le dossier `/docs`.

## Deux problèmes rencontrés, et comment je les ai résolus

**Un trunk mal configuré sur le switch.** Une fois ma configuration terminée, plus aucun ping ne passait, même entre un PC et sa propre passerelle. En vérifiant avec `show vlan brief` et `show interfaces trunk`, j'ai réalisé que j'avais configuré le trunk sur le port Fa0/4, alors que le câble vers le routeur était en réalité branché sur Gi0/1. Une fois le bon port configuré, tout est rentré dans l'ordre.

**Un problème réseau pendant l'installation de pfSense.** L'installation échouait systématiquement, faute d'accès à Internet pour télécharger l'image du système. En testant un `ping 8.8.8.8` depuis le terminal de l'installeur, j'ai vu que c'était la passerelle NAT de VirtualBox elle-même qui renvoyait une erreur. Le problème s'est résolu en passant l'interface WAN du mode NAT au mode Bridge, directement sur ma carte Wi-Fi.

Le détail complet de ces deux diagnostics se trouve dans le [rapport complet](docs/Rapport-Projet-Homelab-VLAN.pdf).

## 6 Captures d'écran : Les captures ci-dessous illustrent chacune de ces étapes, de la configuration initiale jusqu'aux tests de validation.

**Topologie réseau complète** — 3 PC répartis sur 3 VLAN, reliés à un switch, lui-même connecté au routeur via un lien trunk :
<img width="2880" height="1702" alt="Capture d&#39;écran 2026-09-14 002829" src="https://github.com/user-attachments/assets/b5a9f1d0-9ef4-4227-ba1a-1c7e39eb1404" />



**Vérification des VLAN et du trunk** — commandes `show vlan brief` et `show interfaces trunk` confirmant que chaque port est bien assigné à son VLAN, et que le lien vers le routeur transporte bien les 3 VLAN :
<img width="1400" height="1398" alt="Capture d&#39;écran 2026-09-14 003623" src="https://github.com/user-attachments/assets/5c94b34f-740e-4675-adce-9528750336bc" />


**Test de connectivité inter-VLAN** — ping réussi entre deux PC de VLAN différents, preuve que le routage inter-VLAN fonctionne correctement : 
<img width="2880" height="1700" alt="Capture d&#39;écran 2026-09-14 023131" src="https://github.com/user-attachments/assets/725812a8-b96c-4abb-b70c-6b58d69c6ee6" />


**Table de routage du routeur** — commande `show ip route`, les 3 réseaux apparaissent comme directement connectés (code C), confirmant que le routeur gère bien les 3 VLAN :
<img width="2774" height="668" alt="Capture d&#39;écran 2026-09-14 023244" src="https://github.com/user-attachments/assets/a7ea6472-c1b3-48c0-8239-4fb9c1e4d437" />


**Vérification de l'ACL de sécurité** — le PC du VLAN Invités ne peut plus joindre le PC du VLAN Admin ("Destination host unreachable"), preuve que la règle de pare-feu fonctionne comme prévu :
<img width="2878" height="872" alt="Capture d&#39;écran 2026-09-14 025100" src="https://github.com/user-attachments/assets/3d63bd49-95fe-4261-ad49-f1c278969761" />



**Interface pfSense — Dashboard** — vue d'ensemble du pare-feu une fois installé et configuré (interfaces WAN/LAN, état du système) :
<img width="1370" height="1614" alt="Capture d&#39;écran 2026-09-13 200406" src="https://github.com/user-attachments/assets/3ca5becd-1257-41ed-a440-bcb91925c085" />


**Règle de pare-feu créée sur pfSense** — règle de test bloquant le trafic ICMP sur l'interface LAN, appliquée avec succès :
<img width="1334" height="1476" alt="Capture d&#39;écran 2026-09-13 205807" src="https://github.com/user-attachments/assets/b176a4ce-ee0c-43d1-8557-62c2de301eab" />



**Supervision Zabbix — état de l'hôte pfSense** — pfSense apparaît disponible en SNMP (statut vert), confirmant que la supervision fonctionne :
<img width="2798" height="1598" alt="Capture d&#39;écran 2026-09-13 231356" src="https://github.com/user-attachments/assets/0f2f6024-39af-412d-8ece-4791066c1ea9" />


**Supervision Zabbix — métriques en temps réel** — données remontées automatiquement par Zabbix (disponibilité, temps de réponse, uptime), preuve que le monitoring collecte des données réelles :
<img width="2792" height="1606" alt="Capture d&#39;écran 2026-09-13 231734" src="https://github.com/user-attachments/assets/08c3a14c-6e92-4799-b355-80e3a2eb0fc9" />




## 7 Documentation complète

Le rapport détaillé, avec le contexte, les configurations complètes, les tests de validation et le déroulé du troubleshooting, est disponible ici :
[Rapport-Projet-Homelab-VLAN.pdf](docs/Rapport-Projet-Homelab-VLAN.pdf)

## 8 Prochaines étapes

Je compte continuer ce projet dans les prochains mois, avec notamment :

- Un système de détection d'intrusion (Suricata ou Snort) sur pfSense
- Un accès distant sécurisé via VPN (OpenVPN)
- Un dashboard Zabbix personnalisé avec des alertes automatiques
- L'intégration d'un serveur Windows avec Active Directory, en lien avec la suite de ma formation CCNA3



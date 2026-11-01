# Problèmes rencontrés et résolus

**Navigation :** [Accueil](../README.md) · [Partie A](partie-a-vlan.md) · [Partie B](partie-b-pfsense-zabbix.md) · [Adressage](plan-adressage.md) · [Règles pfSense](regles-pfsense.md) · [Tests et supervision](tests-et-supervision.md) · Problèmes résolus · [Feuille de route](feuille-de-route.md)

> Garder une trace des erreurs fait partie des objectifs du projet. Voici deux problèmes, avec le symptôme, la démarche de diagnostic et la solution.

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

## Aller plus loin

Le déroulé complet de ces deux diagnostics se trouve dans le [rapport PDF](https://github.com/user-attachments/files/32176285/Rapport-Projet-Homelab-VLAN.pdf).

# CLIENT01 — vérification réseau et jonction au domaine lab.internal
# À lancer dans PowerShell (et non dans cmd) en administrateur, sur CLIENT01.

ipconfig                                       # adresse .100 à .150, passerelle .254, suffixe lab.internal
Test-NetConnection 192.168.56.10 -Port 389     # TcpTestSucceeded doit être True

# Le mot de passe de LAB\Administrator est demandé dans une fenêtre : il n'est pas écrit ici.
Add-Computer -DomainName lab.internal -Credential LAB\Administrator -Restart

# Si le port 389 ne répond pas alors que DC01 fonctionne, vérifier sur DC01 :
#   Get-NetConnectionProfile          -> NetworkCategory doit être DomainAuthenticated
#   Restart-NetAdapter -Name "Ethernet"   (reclasse la carte si elle est en Private)

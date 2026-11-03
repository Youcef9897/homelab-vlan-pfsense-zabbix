# DC01 — promotion en contrôleur de domaine de la forêt lab.internal
# Le mot de passe DSRM est demandé dans une invite masquée : il n'apparaît ni à l'écran ni dans l'historique.

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Install-ADDSForest -DomainName "lab.internal" -DomainNetbiosName "LAB" -InstallDns `
    -SafeModeAdministratorPassword (Read-Host -AsSecureString "Mot de passe DSRM")

# Après le redémarrage (connexion LAB\Administrator) : redirecteur DNS vers pfSense
Set-DnsServerForwarder -IPAddress 192.168.56.254

# Vérification
Get-ADDomain | Select-Object DNSRoot, NetBIOSName, DomainMode

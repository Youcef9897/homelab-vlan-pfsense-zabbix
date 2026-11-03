# DC01 — adresse fixe, DNS et nom de la machine
# À lancer dans PowerShell en administrateur, sur DC01.

Set-NetIPInterface -InterfaceAlias "Ethernet" -Dhcp Disabled
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.56.10 -PrefixLength 24 -DefaultGateway 192.168.56.254
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 192.168.56.10

# Vérification : pfSense et Zabbix doivent répondre
ping 192.168.56.254
ping 192.168.56.104

Rename-Computer -NewName DC01 -Restart

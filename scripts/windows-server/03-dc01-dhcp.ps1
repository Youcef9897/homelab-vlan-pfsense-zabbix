# DC01 — bascule du DHCP de pfSense vers DC01
# Ordre : étendue créée inactive -> options -> réservation -> DHCP de pfSense désactivé -> étendue activée.

Install-WindowsFeature DHCP -IncludeManagementTools
Add-DhcpServerInDC -DnsName DC01.lab.internal -IPAddress 192.168.56.10

Add-DhcpServerv4Scope -Name "LAB-LAN" -StartRange 192.168.56.100 -EndRange 192.168.56.150 `
    -SubnetMask 255.255.255.0 -LeaseDuration 02:00:00 -State InActive
Set-DhcpServerv4OptionValue -ScopeId 192.168.56.0 -Router 192.168.56.254 -DnsServer 192.168.56.10 -DnsDomain lab.internal

# Réservation de l'adresse de Zabbix (adresse MAC de sa carte virtuelle)
Add-DhcpServerv4Reservation -ScopeId 192.168.56.0 -IPAddress 192.168.56.104 -ClientId "08-00-27-bb-8b-a1" `
    -Name "zabbix" -Description "Zabbix appliance"

# >>> Désactiver ici le serveur DHCP de pfSense : Services > DHCP Server > LAN (case « Enable » décochée) <<<

Set-DhcpServerv4Scope -ScopeId 192.168.56.0 -State Active

# Vérification après redémarrage de Zabbix : bail .104 à l'état ActiveReservation
Get-DhcpServerv4Lease -ScopeId 192.168.56.0 | Select-Object IPAddress, ClientId, HostName, AddressState

# DC01 — unités d'organisation, groupes, utilisateurs de test, partage RH et stratégies de groupe
# Forme regroupée (boucles) des commandes exécutées une à une dans le lab.

$base = "DC=lab,DC=internal"

# OU et groupes globaux de sécurité.
# Les tests d'existence (if -not ...) ont été ajoutés après coup, pour pouvoir relancer sans erreur
# (voir le problème des OU « déjà utilisées » dans docs/problemes-resolus.md).
foreach ($ou in "ADMIN","RH","INVITES") {
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ou'" -SearchBase $base -SearchScope OneLevel)) {
        New-ADOrganizationalUnit -Name $ou -Path $base -ProtectedFromAccidentalDeletion $true
    }
    if (-not (Get-ADGroup -Filter "Name -eq 'GG_$ou'")) {
        New-ADGroup -Name "GG_$ou" -GroupScope Global -GroupCategory Security -Path "OU=$ou,$base"
    }
}

# Utilisateurs de test (mot de passe saisi dans une invite masquée, jamais écrit)
$pw = Read-Host -AsSecureString "Mot de passe des comptes de test"
foreach ($u in @(@("adm01","ADMIN"), @("rh01","RH"), @("inv01","INVITES"))) {
    New-ADUser -Name $u[0] -SamAccountName $u[0] -UserPrincipalName "$($u[0])@lab.internal" `
        -Path "OU=$($u[1]),$base" -AccountPassword $pw -Enabled $true
    Add-ADGroupMember -Identity "GG_$($u[1])" -Members $u[0]
}

# Partage RH : SMB + NTFS, héritage supprimé (moindre privilège)
New-Item -Path C:\Partages\RH -ItemType Directory
New-SmbShare -Name RH -Path C:\Partages\RH -FullAccess "LAB\GG_ADMIN" -ChangeAccess "LAB\GG_RH"
icacls C:\Partages\RH /inheritance:r /grant "LAB\GG_ADMIN:(OI)(CI)F" "LAB\GG_RH:(OI)(CI)M" `
    "BUILTIN\Administrators:(OI)(CI)F" "SYSTEM:(OI)(CI)F"

# Politique de mot de passe du domaine
Set-ADDefaultDomainPasswordPolicy -Identity lab.internal -MinPasswordLength 10 -ComplexityEnabled $true `
    -LockoutThreshold 5 -LockoutDuration 00:15:00 -LockoutObservationWindow 00:15:00

# GPO des invités : Panneau de configuration bloqué
New-GPO -Name "GPO_INVITES_Panneau"
Set-GPRegistryValue -Name "GPO_INVITES_Panneau" `
    -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
    -ValueName NoControlPanel -Type DWord -Value 1
New-GPLink -Name "GPO_INVITES_Panneau" -Target "OU=INVITES,$base"

# GPO des RH : lecteur R: -> \\DC01\RH
# Créée dans la console GPMC (Préférences utilisateur > Paramètres Windows > Mappages de lecteurs),
# nommée GPO_RH_Lecteur_R et liée à l'OU RH : action « Create », lettre R:, reconnexion cochée.

#References: http://technet.microsoft.com/en-us/library/hh472162.aspx
            https://docs.microsoft.com/en-us/powershell/module/addsdeployment/install-addsforest?view=win10-ps
#DomainMode / ForestMode - Server 2003: 2 or Win2003 / Server 2008: 3 or Win2008 / Server 2008 R2: 4 or Win2008R2 / Server 2012: 5 or Win2012 / Server 2012 R2: 6 or Win2012R2 / Server 2016: 7 or WinThreshold

$DomainName = "testlab.com"
$NetBIOSName = "testlab"
$DomainMode = "WinThreshold"
$ForestMode = "WinThreshold"
$SafeModeAdministratorPassword = ConvertTo-SecureString "secdev12!" -AsPlaintext -Force

Write-Host "Windows Server 2019 - Active Directory Installation"

Write-Host " - Installing AD-Domain-Services..."
Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools

Write-Host " - Creating new AD-Domain-Services Forest..."
Import-Module ADDSDeployment
Install-ADDSForest -CreateDNSDelegation:$False -SafeModeAdministratorPassword $SafeModeAdministratorPassword -DomainName $DomainName -DomainMode $DomainMode -ForestMode $ForestMode -DomainNetBiosName $NetBIOSName -InstallDNS:$True -Confirm:$False

Write-Host " - Done.`n"

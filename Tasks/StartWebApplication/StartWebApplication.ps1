param (
	[string]$environmentName,
	[string]$adminUserName,
	[string]$adminPassword,
	[string]$winrmProtocol,
	[string]$testCertificate,
	[string]$resourceFilteringMethod,
	[string]$machineFilter,
	[string]$websiteName,
	[string]$applicationPoolName,
	[string]$deployInParallel
)

Write-Output "Entering script StartWebApplication.ps1"
Write-Output "environmentName = $environmentName"
Write-Output "adminUserName = $adminUserName"
Write-Output "winrm protocol to connect to machine  = $winrmProtocol"
Write-Output "testCertificate = $testCertificate"
Write-Output "resourceFilteringMethod = $resourceFilteringMethod"
Write-Output "machineFilter = $machineFilter"
Write-Output "deployInParallel = $deployInParallel"

Write-Output "websiteName = $websiteName"
Write-Output "applicationPoolName = $applicationPoolName"

import-module "Microsoft.TeamFoundation.DistributedTask.Task.Internal"
import-module "Microsoft.TeamFoundation.DistributedTask.Task.Common"
import-module "Microsoft.TeamFoundation.DistributedTask.Task.DevTestLabs"
Import-Module "Microsoft.TeamFoundation.DistributedTask.Task.Deployment.Internal"
Import-Module "Microsoft.TeamFoundation.DistributedTask.Task.Deployment.RemoteDeployment"

$websiteName = $websiteName.Trim('"', ' ')
$applicationPoolName = $applicationPoolName.Trim('"', ' ')

$scriptContent = Get-Content  ./StartWebApplicationOnTargetMachines.ps1 | Out-String
$scriptArgs += " -WebsiteName `"$websiteName`""
$scriptArgs += " -ApplicationPoolName `"$applicationPoolName`""

Write-Verbose "Script Arguments : $scriptArgs" -Verbose

$errorMessage = [string]::Empty

if($resourceFilteringMethod -eq "tags")
{
    $errorMessage = Invoke-RemoteDeployment -environmentName $environmentName -tags $machineFilter -scriptBlockContent $scriptContent -scriptArguments $scriptArgs -runPowershellInParallel $deployInParallel -adminUserName $adminUserName -adminPassword $adminPassword -protocol $winrmProtocol -testCertificate $testCertificate
}
else
{
    $errorMessage = Invoke-RemoteDeployment -environmentName $environmentName -machineNames $machineFilter -scriptBlockContent $scriptContent -scriptArguments $scriptArgs -runPowershellInParallel $deployInParallel -adminUserName $adminUserName -adminPassword $adminPassword -protocol $winrmProtocol -testCertificate $testCertificate
}

if(-not [string]::IsNullOrEmpty($errorMessage))
{
    throw "$errorMessage"
}

Write-Output "Successfully started Web Application"
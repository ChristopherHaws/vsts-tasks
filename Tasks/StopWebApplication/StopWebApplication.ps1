param (
	[string]$environmentName,
	[string]$adminUserName,
	[string]$adminPassword,
	[string]$winrmProtocol,
	[string]$testCertificate,
	[string]$resourceFilteringMethod,
	[string]$machineFilter,
	[string]$webSiteName,
	[string]$applicationPoolName,
	[string]$deployInParallel
)

Write-Output "Entering script StopWebApplication.ps1"
Write-Output "environmentName = $environmentName"
Write-Output "adminUserName = $adminUserName"
Write-Output "winrm protocol to connect to machine  = $winrmProtocol"
Write-Output "testCertificate = $testCertificate"
Write-Output "resourceFilteringMethod = $resourceFilteringMethod"
Write-Output "machineFilter = $machineFilter"
Write-Output "deployInParallel = $deployInParallel"

Write-Output "webSiteName = $webSiteName"
Write-Output "applicationPoolName = $applicationPoolName"

import-module "Microsoft.TeamFoundation.DistributedTask.Task.Internal"
import-module "Microsoft.TeamFoundation.DistributedTask.Task.Common"
import-module "Microsoft.TeamFoundation.DistributedTask.Task.DevTestLabs"
Import-Module "Microsoft.TeamFoundation.DistributedTask.Task.Deployment.Internal"
Import-Module "Microsoft.TeamFoundation.DistributedTask.Task.Deployment.RemoteDeployment"

$webSiteName = $webSiteName.Trim('"', ' ')
$applicationPoolName = $applicationPoolName.Trim('"', ' ')

$scriptContent = Get-Content  ./StopWebApplicationOnTargetMachines.ps1 | Out-String
$scriptArgs += " -WebSiteName `"$webSiteName`""
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

Write-Output "Successfully stopped Web Application"
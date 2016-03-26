param (
	[string]$environmentName,
	[string]$adminUserName,
	[string]$adminPassword,
	[string]$winrmProtocol,
	[string]$testCertificate,
	[string]$resourceFilteringMethod,
	[string]$machineFilter,
	[string]$applicationPoolName,
	[string]$deployInParallel
)

Write-Verbose "Entering script StopApplicationPool.ps1" -Verbose
Write-Verbose "environmentName = $environmentName" -Verbose
Write-Verbose "adminUserName = $adminUserName" -Verbose
Write-Verbose "winrm protocol to connect to machine  = $winrmProtocol" -Verbose
Write-Verbose "testCertificate = $testCertificate" -Verbose
Write-Verbose "resourceFilteringMethod = $resourceFilteringMethod" -Verbose
Write-Verbose "machineFilter = $machineFilter" -Verbose
Write-Verbose "deployInParallel = $deployInParallel" -Verbose

Write-Verbose "applicationPoolName = $applicationPoolName" -Verbose

import-module "Microsoft.TeamFoundation.DistributedTask.Task.Internal"
import-module "Microsoft.TeamFoundation.DistributedTask.Task.Common"
import-module "Microsoft.TeamFoundation.DistributedTask.Task.DevTestLabs"
Import-Module "Microsoft.TeamFoundation.DistributedTask.Task.Deployment.Internal"
Import-Module "Microsoft.TeamFoundation.DistributedTask.Task.Deployment.RemoteDeployment"

$applicationPoolName = $applicationPoolName.Trim('"', ' ')

$scriptContent = Get-Content  ./StopApplicationPoolOnTargetMachines.ps1 | Out-String
$scriptArgs = " -ApplicationPoolName `"$applicationPoolName`""

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

Write-Output "Successfully stopped IIS Application Pool : $applicationPoolName"
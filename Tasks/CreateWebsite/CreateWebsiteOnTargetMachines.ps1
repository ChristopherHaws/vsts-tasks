param (
	[string]$webSiteName,
	[string]$applicationPool,
	[string]$hostName,
	[string]$ipAddress,
	[string]$physicalPath,
	[uint32]$port,
	[switch]$ssl
)

Write-Verbose "Entering script CreateWebsiteOnTargetMachines.ps1" -Verbose
Write-Verbose "WebSiteName = $webSiteName" -Verbose
Write-Verbose "ApplicationPool = $applicationPool" -Verbose
Write-Verbose "HostName = $hostName" -Verbose
Write-Verbose "IpAddress = $ipAddress" -Verbose
Write-Verbose "PhysicalPath = $physicalPath" -Verbose
Write-Verbose "Port = $port" -Verbose
Write-Verbose "Ssl = $ssl" -Verbose

$webSiteName = $webSiteName.Trim('"', ' ')
$applicationPool = $applicationPool.Trim('"', ' ')
$hostName = $hostName.Trim('"', ' ')
$ipAddress = $ipAddress.Trim('"', ' ')
$physicalPath = $physicalPath.Trim('"', ' ')

function Import-WebAdministration {
	$ModuleName = "WebAdministration"
	$ModuleLoaded = $false
	$LoadAsSnapin = $false

	if ($PSVersionTable.PSVersion.Major -ge 2) {
		if ((Get-Module -ListAvailable | ForEach-Object {$_.Name}) -contains $ModuleName) {
			Import-Module $ModuleName

			if ((Get-Module | ForEach-Object {$_.Name}) -contains $ModuleName) {
				$ModuleLoaded = $true
			} else {
				$LoadAsSnapin = $true
			}
		} elseif ((Get-Module | ForEach-Object {$_.Name}) -contains $ModuleName) {
			$ModuleLoaded = $true
		} else {
			$LoadAsSnapin = $true
		}
	} else {
		$LoadAsSnapin = $true
	}
	
	if ($LoadAsSnapin) {
		try {
			if ((Get-PSSnapin -Registered | ForEach-Object {$_.Name}) -contains $ModuleName) {
				if ((Get-PSSnapin -Name $ModuleName -ErrorAction SilentlyContinue) -eq $null) {
					Add-PSSnapin $ModuleName
				}

				if ((Get-PSSnapin | ForEach-Object {$_.Name}) -contains $ModuleName) {
					$ModuleLoaded = $true
				}
			} elseif ((Get-PSSnapin | ForEach-Object {$_.Name}) -contains $ModuleName) {
				$ModuleLoaded = $true
			}
		} catch {
			Write-Error "`t`t$($MyInvocation.InvocationName): $_"
			Exit
		}
	}
}

Import-WebAdministration

$site = Get-Website -Name $webSiteName

if ($site) {
	Write-Verbose "Website already exists." -Verbose
	
	Write-Verbose "Stopping website..." -Verbose
	$site.Stop()
	
	Write-Verbose "Removing website..." -Verbose
	Remove-Website -Name $webSiteName
	
	
}

Write-Verbose "Creating website..." -Verbose
if ($ssl) {
	New-Website -Name $webSiteName -ApplicationPool $applicationPool -HostHeader $hostName -IPAddress $ipAddress -PhysicalPath $physicalPath -Port $port -Ssl	
} else {
	New-Website -Name $webSiteName -ApplicationPool $applicationPool -HostHeader $hostName -IPAddress $ipAddress -PhysicalPath $physicalPath -Port $port
}
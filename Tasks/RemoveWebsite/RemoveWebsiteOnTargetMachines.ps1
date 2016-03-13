param (
	[string]$webSiteName
)

Write-Verbose "WebSiteName = $webSiteName" -Verbose

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
	Write-Verbose -Object "Stopping website..." -Verbose
	$site.Stop()
	
	Write-Verbose -Object "Removing website..." -Verbose
	Remove-Website -Name $webSiteName
} else {
	Write-Warning -Object "Website does not exist."
}
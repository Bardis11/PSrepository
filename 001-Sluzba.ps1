param(
	[string]$VPN = "Xbox Live Auth Manager"  # Název VPN služby k přepnutí
)

# Kontrola admin práv
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Host "Restartuji jako Admin..." -ForegroundColor Yellow
	$arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
	Start-Process powershell.exe -Verb RunAs -ArgumentList $arguments
	exit
}

Write-Host "=== PŘEPÍNAČ VPN SLUŽBY ===" -ForegroundColor Cyan

# Zkontroluj službu
try {
	$sluzba = Get-Service -Name $VPN -ErrorAction Stop
	Write-Host "Aktuální stav: $($sluzba.Status)" -ForegroundColor White

	if ($sluzba.Status -eq "Running") {
		Stop-Service -Name $VPN -Force
		Write-Host "✓ '$VPN' VYPNUTÁ!" -ForegroundColor Red
	}
	else {
		Start-Service -Name $VPN
		Write-Host "✓ '$VPN' ZAPNUTÁ!" -ForegroundColor Green
	}
}
catch {
	Write-Host "CHYBA: $($_.Exception.Message)" -ForegroundColor Red
}

# Finální stav
Start-Sleep 2
Get-Service -Name $VPN | Format-Table Name, Status, StartType -AutoSize
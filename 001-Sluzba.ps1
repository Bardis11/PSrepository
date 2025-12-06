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











Test02 


param(
	[string]$VPN = "Xbox Live Auth Manager"  # ← Tvůj název služby
)

# === JEDNORÁZOVÝ SETUP (spusť 1x jako ADMIN) ===
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Host "1x SETUP potřebuje ADMIN. Po setupu funguje bez admin." -ForegroundColor Yellow
	Write-Host "Chceš vytvořit Scheduled Task? (Y/N)" -ForegroundColor Cyan
	$choice = Read-Host
	if ($choice -eq "Y") {
		# VYTVŘÍ TASK PRO SYSTEM
		$scriptContent = @"
param(`$VPN = "$VPN")
if (Get-Service -Name `$VPN -ErrorAction SilentlyContinue).Status -eq "Running") {
    Stop-Service -Name `$VPN -Force
    Write-Host "VYPNUTÁ: `$VPN"
} else {
    Start-Service -Name `$VPN
    Write-Host "ZAPNUTÁ: `$VPN"
}
"@
		$scriptContent | Out-File "$env:TEMP\vpn-toggle.ps1" -Force
		schtasks /create /tn "VPN-$VPN" /tr "powershell -NoProfile -ExecutionPolicy Bypass -File `"$env:TEMP\vpn-toggle.ps1`"" /sc ondemand /ru SYSTEM /f
		Write-Host "✅ SETUP DOKONČEN! Teď funguje bez admin:" -ForegroundColor Green
		Write-Host "powershell -c `"schtasks /run /tn 'VPN-$VPN' /f`"" -ForegroundColor White
	}
	exit
}

# === Hlavní logika (běží jako ADMIN) ===
Write-Host "=== PŘEPÍNAČ VPN SLUŽBY: $VPN ===" -ForegroundColor Cyan
$sluzba = Get-Service -Name $VPN -ErrorAction SilentlyContinue

if (-not $sluzba) {
    Write-Host "❌ Služba '$VPN' neexistuje!" -ForegroundColor Red
    exit
}

Write-Host "Před: $($sluzba.Status)" -ForegroundColor White

if ($sluzba.Status -eq "Running") {
    Stop-Service -Name $VPN -Force
    Write-Host "✓ '$VPN' VYPNUTÁ!" -ForegroundColor Red
} else {
    Start-Service -Name $VPN
    Write-Host "✓ '$VPN' ZAPNUTÁ!" -ForegroundColor Green
}

Start-Sleep 1
Get-Service -Name $VPN | Format-Table Name, Status, StartType -AutoSize

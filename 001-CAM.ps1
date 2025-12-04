# Zkontroluj zda Camera app běží
>> $cameraProcess = Get-Process "WindowsCamera" -ErrorAction SilentlyContinue
>>
>> if ($cameraProcess) {
>>     Write-Host "Camera app běží -> ukončuji..." -ForegroundColor Yellow
>>     Stop-Process -Name "WindowsCamera" -Force
>>     Start-Sleep -Seconds 2
>>     Write-Host "Camera app ukončena!" -ForegroundColor Red
>> }
>>
>> # Spusť Camera app znovu
>> Write-Host "Spouštím Camera app..." -ForegroundColor Green
>> Start-Process "ms-windows-camera:"
>>
>> Write-Host "Camera app restartována! Otevřete ji a otestujte kameru." -ForegroundColor Green
>>
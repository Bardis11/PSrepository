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



Pokus 2 bat skript

@echo off
title Kamera-Restart-Loop
color 0A
set cas=15

:loop
cls
echo [%date% %time%] === RESTART KAMERA APLIKACE ===
echo.

echo Zabijim Kamera app procesy...
taskkill /IM WindowsCamera.exe /F >nul 2>&1
taskkill /IM Video.UI.exe /F >nul 2>&1
taskkill /IM ApplicationFrameHost.exe /F >nul 2>&1
timeout /t 3 /nobreak >nul

echo Spoustim Kamera aplikaci...
start microsoft.windows.camera:

echo [%date% %time%]  RESTART DOKONCEN 
echo Cekam %cas%...
timeout /t %cas% /nobreak >nul
goto loop






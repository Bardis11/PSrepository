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
title Kamera-Restart-%random%-%time:~0,2%%time:~3,2%
color 0A

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

echo [%date% %time%] === RESTART DOKONCEN ===
echo Cekam 6 hodin (skryte)...
echo.

REM SKRYPANI CMD - nevidi se 6 hodin
start /min cmd /c "timeout /t 21600 /nobreak >nul & taskkill /FI "WINDOWTITLE eq Kamera-Restart-*%random%" /F >nul 2>&1"

REM Ukonci TOTO CMD okno
taskkill /FI "WINDOWTITLE eq Kamera-Restart-%random%-%time:~0,2%%time:~3,2%" /F >nul 2>&1
exit


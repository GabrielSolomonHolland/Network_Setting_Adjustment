Set-ExecutionPolicy -ExecutionPolicy bypass
powershell -NoProfile -windowstyle hidden -Command "Start-Process -Verb RunAs powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File .\NetworkSettingsScrapTablets.ps1 -_vLUF %_vLUF%'"
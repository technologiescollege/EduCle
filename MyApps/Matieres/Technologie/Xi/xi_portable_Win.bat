@echo off
break ON
rem fichiers BAT et fork créés par Sébastien CANET
cls
SET currentpath=%~dp1
cd %currentpath%
start .\nodejs\node.exe xiserver.js ard null 0 COM24 1234
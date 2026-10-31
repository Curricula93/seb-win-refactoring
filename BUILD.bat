@echo off
echo ========================================
echo  Building Safe Exam Browser
echo ========================================
echo.

echo Step 1: Downloading NuGet.exe if needed...
if not exist nuget.exe (
    echo Downloading NuGet...
    powershell -Command "Invoke-WebRequest -Uri 'https://dist.nuget.org/win-x86-commandline/latest/nuget.exe' -OutFile 'nuget.exe'"
)

echo.
echo Step 2: Restoring NuGet packages...
nuget.exe restore SafeExamBrowser.sln

echo.
echo Step 3: Building the solution...
"C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\amd64\MSBuild.exe" SafeExamBrowser.sln /p:Configuration=Release /p:Platform=x64 /t:Rebuild /m /v:minimal

echo.
echo ========================================
echo Build complete!
echo Executable: SafeExamBrowser.Runtime\bin\x64\Release\SafeExamBrowser.exe
echo ========================================
pause

# Register .seb file association for modified SafeExamBrowser
# This script will request Administrator privileges

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Requesting Administrator privileges..." -ForegroundColor Yellow
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$INSTALL_DIR = Join-Path $PSScriptRoot "SafeExamBrowser.Runtime\bin\x64\Release"
$EXE_PATH = Join-Path $INSTALL_DIR "SafeExamBrowser.exe"

Write-Host "Registering .seb file association..." -ForegroundColor Green
Write-Host "Install directory: $INSTALL_DIR"
Write-Host "Executable: $EXE_PATH"

if (-not (Test-Path $EXE_PATH)) {
    Write-Host "ERROR: SafeExamBrowser.exe not found at: $EXE_PATH" -ForegroundColor Red
    Write-Host "Please build the solution first." -ForegroundColor Red
    pause
    exit 1
}

try {
    # Register file extension
    New-Item -Path "Registry::HKEY_CLASSES_ROOT\.seb" -Force | Out-Null
    Set-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\.seb" -Name "(Default)" -Value "SafeExamBrowser.Config"
    Set-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\.seb" -Name "Content Type" -Value "application/seb"
    
    # Register application
    New-Item -Path "Registry::HKEY_CLASSES_ROOT\SafeExamBrowser.Config" -Force | Out-Null
    Set-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\SafeExamBrowser.Config" -Name "(Default)" -Value "Safe Exam Browser Configuration"
    
    New-Item -Path "Registry::HKEY_CLASSES_ROOT\SafeExamBrowser.Config\DefaultIcon" -Force | Out-Null
    Set-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\SafeExamBrowser.Config\DefaultIcon" -Name "(Default)" -Value "`"$EXE_PATH`",0"
    
    New-Item -Path "Registry::HKEY_CLASSES_ROOT\SafeExamBrowser.Config\shell\open\command" -Force | Out-Null
    Set-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\SafeExamBrowser.Config\shell\open\command" -Name "(Default)" -Value "`"$EXE_PATH`" `"%1`""
    
    Write-Host ""
    Write-Host "✓ Registration complete!" -ForegroundColor Green
    Write-Host "✓ .seb files will now open with your modified SafeExamBrowser" -ForegroundColor Green
    Write-Host "✓ Windows will be resizable regardless of .seb config" -ForegroundColor Green
    Write-Host ""
    Write-Host "You may need to refresh Windows Explorer (press F5) to see the icon change." -ForegroundColor Yellow
    Write-Host ""
} catch {
    Write-Host "ERROR: Failed to register file association" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

pause

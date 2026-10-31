# Quick Testing Guide

## Step 1: Build the Project

You need to install .NET Framework 4.8 Developer Pack first:
https://dotnet.microsoft.com/download/dotnet-framework/net48

Then build using **Visual Studio** (recommended):

1. Open `SafeExamBrowser.sln` in Visual Studio
2. Select **Release** configuration and **x64** platform
3. Right-click solution → **Rebuild Solution**
4. Wait for build to complete

**Alternative - Command Line** (if you have .NET Framework 4.8 SDK installed):
```powershell
$msbuild = "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\amd64\MSBuild.exe"
& $msbuild SafeExamBrowser.sln /p:Configuration=Release /p:Platform=x64 /t:Rebuild
```

Build output will be in:
- `SafeExamBrowser.Runtime\bin\x64\Release\SafeExamBrowser.exe`

## Step 2: Quick Test (No .seb file needed)

The fastest way to verify the changes work:

```powershell
cd SafeExamBrowser.Runtime\bin\x64\Release
.\SafeExamBrowser.exe
```

**What to verify:**
✅ Window opens with normal borders and title bar  
✅ You can resize the window by dragging edges  
✅ Minimize/maximize buttons work  
✅ You can drag the window by title bar  

## Step 3: Test With Configuration (Optional)

### Option A: Use SebWindowsConfig Tool (Included)

1. Navigate to: `SebWindowsConfig\bin\x64\Release\`
2. Run `SebWindowsConfig.exe`
3. Configure these settings:
   - Go to **"Config File"** tab → Set a password (optional but recommended)
   - Go to **"Browser"** tab → **"Browser Window"** section
   - Enable **"Enter Fullscreen Mode"** (this is what we're overriding!)
   - Save as `test-fullscreen.seb`

### Option B: Download a Sample Config

You can download test configs from:
- https://safeexambrowser.org/demo_en.html

### Option C: Use This Quick Test Config

Save this as `test.seb` (it's a minimal config with fullscreen enabled):

```xml
<?xml version="1.0" encoding="utf-8"?>
<plist version="1.0">
  <dict>
    <key>browserWindowAllowReload</key>
    <true/>
    <key>browserViewMode</key>
    <integer>0</integer>
    <key>mainBrowserWindowWidth</key>
    <string>100%</string>
    <key>mainBrowserWindowHeight</key>
    <string>100%</string>
    <key>enableBrowserWindowToolbar</key>
    <true/>
    <key>startURL</key>
    <string>https://www.example.com</string>
  </dict>
</plist>
```

## Step 3: Run and Test

```powershell
# Navigate to the build directory
cd SafeExamBrowser.Runtime\bin\x64\Release

# Run with your test config
.\SafeExamBrowser.exe "C:\path\to\test.seb"

# Or run without a config (uses defaults)
.\SafeExamBrowser.exe
```

## Step 4: Verify the Override Works

**What to check:**

✅ **Window has a border** (not borderless fullscreen)
✅ **Window has minimize/maximize buttons** in the title bar
✅ **You can resize the window** by dragging the edges
✅ **You can drag the window** by the title bar
✅ **Window can be minimized and restored**

**Before our changes:**
- Window would be borderless and locked (no resize, no title bar)
- Would be truly fullscreen without window controls

**After our changes:**
- Window has normal window frame
- Fully resizable despite the config saying otherwise

## Step 5: Verify Other Settings Still Work

While SEB is running, test that:
- You can still browse the configured URL
- Other security features work (if configured)
- The app functions normally except for the resize override

## Quick One-Line Test

If you just want to test quickly without a .seb file:

```powershell
cd SafeExamBrowser.Runtime\bin\x64\Release
.\SafeExamBrowser.exe
```

The window should be resizable by default, but you can verify the code is working.

## Troubleshooting

**Build fails:**
- Make sure you have .NET Framework 4.8 SDK installed
- Open `SafeExamBrowser.sln` in Visual Studio and build from there

**Can't find MSBuild:**
- Install Visual Studio Build Tools 2019 or later
- Or use Visual Studio IDE (File → Open → Project/Solution)

**App crashes on start:**
- Make sure Visual C++ Redistributable is installed
- Check `SafeExamBrowser.Runtime\bin\x64\Release\Logs` for error logs

**Need help with .seb files:**
- Use the SebWindowsConfig tool to create/edit configs
- The tool is built as part of the solution

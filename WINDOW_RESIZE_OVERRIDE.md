# Window Resize Override Modification

## Overview
This modification forces the Safe Exam Browser to always allow window resizing, regardless of what the .seb configuration file specifies. The .seb file remains unchanged and its hash/signature stays valid.

## Changes Made

### Files Modified:
1. `SafeExamBrowser.UserInterface.Desktop/Windows/BrowserWindow.xaml.cs`
2. `SafeExamBrowser.UserInterface.Mobile/Windows/BrowserWindow.xaml.cs`

### What Was Changed:
The `InitializeBounds()` method in both BrowserWindow implementations now hard-codes the window resize behavior:

**Before:**
- When `FullScreenMode` was true: `ResizeMode = ResizeMode.NoResize` and `WindowStyle = WindowStyle.None`
- When maximized (100% width/height): No explicit ResizeMode set
- Other cases: No explicit ResizeMode set

**After:**
- When `FullScreenMode` is true: `ResizeMode = ResizeMode.CanResize` and `WindowStyle = WindowStyle.SingleBorderWindow`
- When maximized (100% width/height): `ResizeMode = ResizeMode.CanResize`
- Other cases: `ResizeMode = ResizeMode.CanResize`

### How It Works:
1. The configuration is still read from the .seb file normally
2. All other settings are applied as configured
3. Only the window resize restrictions are overridden at the UI level
4. The window will always be resizable with a normal border, even if the .seb file says otherwise

## Impact:
- ✅ Configuration file (.seb) remains unchanged
- ✅ Configuration hash/signature remains valid
- ✅ All other settings are still respected
- ✅ Window can always be resized, minimized, maximized
- ✅ Works for both Desktop and Mobile UI modes

## Verification That All Code Was Modified:
✅ **Desktop UI**: `SafeExamBrowser.UserInterface.Desktop/Windows/BrowserWindow.xaml.cs` - `InitializeBounds()` method modified
✅ **Mobile UI**: `SafeExamBrowser.UserInterface.Mobile/Windows/BrowserWindow.xaml.cs` - `InitializeBounds()` method modified  
✅ **XAML Files**: No ResizeMode or WindowStyle defined in XAML (defaults to resizable, which is what we want)
✅ **Only Location**: `InitializeBounds()` is the ONLY place in both UI implementations where ResizeMode and WindowStyle are set

The "Mobile" UI is not a separate mobile app - it's a touch-optimized UI mode for Windows tablets/touch devices.

## How to Test:

### Prerequisites:
1. Build the solution in Visual Studio
2. Get or create a `.seb` configuration file with restrictive window settings

### Test 1: With a Fullscreen .seb File
```bash
# Build the solution
msbuild SafeExamBrowser.sln /p:Configuration=Release /p:Platform=x64

# Run with a .seb file that has FullScreenMode enabled
.\bin\Release\x64\SafeExamBrowser.exe "path\to\fullscreen-config.seb"
```

**Expected Result:**
- Window starts full-screen sized BUT with window borders
- You can resize the window by dragging edges
- You can minimize/maximize using window controls
- Title bar is visible (not hidden)

### Test 2: Verify .seb File Integrity
```bash
# Get the hash of your .seb file BEFORE using it
CertUtil -hashfile "path\to\config.seb" SHA256

# Run SEB with the file
# ... use the app ...

# Get the hash AFTER
CertUtil -hashfile "path\to\config.seb" SHA256
```

**Expected Result:**
- The hash should be IDENTICAL before and after
- This confirms the .seb file was never modified

### Test 3: Check Other Settings Still Work
While running SEB with a .seb config:
- Check if URL restrictions still work (if configured)
- Check if allowed applications are still enforced (if configured)
- Check if keyboard shortcuts are blocked (if configured)

**Expected Result:**
- All OTHER settings from the .seb should still be enforced
- ONLY the window resize restriction is bypassed

### Test 4: Create Your Own Test .seb File

If you need to create a test file, use the SEB Config Tool:
1. Open `SebWindowsConfig.exe` (in the build output)
2. Go to Browser settings
3. Enable "Browser Window" → "Enter Fullscreen Mode"
4. Or set specific window dimensions
5. Save as test.seb
6. Run: `SafeExamBrowser.exe test.seb`
7. Verify the window is still resizable despite the config

### Test 5: Different Window Configurations

Test with .seb files having:
- ✅ FullScreenMode = true
- ✅ Width/Height = 100% (maximized)
- ✅ Fixed dimensions (e.g., 800x600)
- ✅ Positioned windows (left/center/right)

**All should be resizable in every case.**

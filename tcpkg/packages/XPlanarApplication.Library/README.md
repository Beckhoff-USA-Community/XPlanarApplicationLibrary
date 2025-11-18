# EventVideoPlayback PLC Library Package

## Package Type
PLC Library Package

## Prerequisites
Before building this package, you must compile the PLC library and ensure the library files are in the bin directory.

### Step 1: Compile the PLC Library
Compile your PLC library in TwinCAT XAE to generate the library files in the bin directory.

### Step 2: Copy Library Files to Package
Ensure the compiled library files (.library, .compiled-library) are in:
```bash
C:\GitHub\EventVideoPlayback\tcpkg\packages\EventVideoPlayback.Library\bin\
```

### Step 3: Add an Icon (Optional)
The package already includes TF1000-Base.png as the icon. To use a different icon, replace this file.

### Step 4: Pack the Package
```bash
tcpkg pack EventVideoPlayback.Library.nuspec -o ../packages
```

Or using the full path:
```bash
tcpkg pack "C:\GitHub\EventVideoPlayback\tcpkg\packages\EventVideoPlayback.Library\EventVideoPlayback.Library.nuspec" -o "C:\GitHub\EventVideoPlayback\tcpkg\packages"
```

## Installation
Once packed, install the package with:
```bash
tcpkg install Beckhoff-USA-Community.XAE.PLC.Lib.EventVideoPlayback
```

This will:
- Use RepTool.exe to install the library to the TwinCAT PLC Library Repository
- Make the library available for use in TwinCAT XAE projects
- Register the library under the correct PLC profile

## Important Note for Version Updates

**CRITICAL:** When updating the package version in the `.nuspec` file, you must also manually update the version number in the uninstall script.

The file `tools\chocolateyuninstall.ps1` contains a hardcoded version string on line 9:
```powershell
$RepToolArgs = "--uninstallLib `"Event Video Playback, 1.1.1 (Beckhoff Automation LLC)`""
```

Update "1.1.1" to match your new version number to ensure proper uninstallation.

## Uninstallation
```bash
tcpkg uninstall Beckhoff-USA-Community.XAE.PLC.Lib.EventVideoPlayback
```

This will:
- Use RepTool.exe to uninstall the library from the TwinCAT PLC Library Repository
- Remove the library from the TwinCAT XAE environment

## Customization
Before building, update the `.nuspec` file with:
- Your company name in `<authors>`
- Your project URL in `<projectUrl>`
- Your copyright information
- The correct version number

## Dependencies
This package has the following dependencies:
- TwinCAT.Standard.XAE (any version)
- TF7xxx.Vision.XAE (any version)

These dependencies will be automatically installed by tcpkg if not already present.

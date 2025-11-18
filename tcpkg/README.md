# TwinCAT Package Manager - EventVideoPlayback

This directory contains the automated build system for all TwinCAT packages in the EventVideoPlayback project.

## Directory Structure

```
tcpkg/
├── packages/              # Package source directories
│   ├── EventVideoPlayback.Library/
│   ├── EventVideoPlayback.XAE/
├── release/               # Built .nupkg files and checksums.md
├── scripts/               # Build scripts and documentation
│   ├── Build-TcPackages.ps1
│   ├── Build-All-Packages.bat
│   ├── BUILD_INSTRUCTIONS.md
│   └── QUICK_REFERENCE.txt
├── Build.ps1              # Convenience wrapper (run from here)
└── Build.bat              # Convenience wrapper (double-click)
```

## Quick Start

### Build TwinCAT Packages

#### Option 1: PowerShell (Recommended)
```powershell
.\Build.ps1 -CleanBuild
```

#### Option 2: Batch File
Double-click `Build.bat`

#### Option 3: From Scripts Directory
```powershell
cd scripts
.\Build-TcPackages.ps1 -CleanBuild
```

## Adding New Packages

To add a new package to the build:

1. Create a new directory under `packages/`
2. Add your `.nuspec` file and source files
3. Run the build script - it will automatically discover and build your package!

**Example:**
```
packages/
└── MyNewPackage/
    ├── MyNewPackage.nuspec
    ├── bin/              # Files to install (optional)
    └── tools/            # Chocolatey scripts (optional)
```

## Output

All built packages are output to:
- **Location**: `release/`
- **Files**: All `.nupkg` files
- **Checksums**: `release/checksums.md` with SHA256 hashes

## Package Verification

Packages that contain a `bin/` directory will automatically get a `VERIFICATION.md` file generated in their `tools/` directory with SHA256 checksums of all installation files.


## Requirements

### For Building TwinCAT Packages
- TwinCAT tcpkg tool (installed with TwinCAT XAE)
- PowerShell 5.1 or higher
- Windows 10/11

## Support

For issues or questions, review the documentation in the `scripts/` directory or check the console output for specific error messages.

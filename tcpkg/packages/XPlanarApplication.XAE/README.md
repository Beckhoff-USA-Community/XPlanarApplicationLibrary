# Event Video Playback XAE Workload Package

## Package Type
TwinCAT XAE Workload Package (Engineering Station Meta-Package)

## What is a Workload Package?
A workload package is a meta-package that installs multiple related components together as a single unit. This XAE workload is designed for TwinCAT engineering stations and includes all necessary components for developing Event Video Playback applications.

## Prerequisites
None - all dependencies are handled automatically by tcpkg during installation.

## Building the Package

### Step 1: Pack the Package
```bash
tcpkg pack EventVideoPlayback.XAE.Workload.nuspec -o ../packages
```

Or using the full path:
```bash
tcpkg pack "C:\GitHub\EventVideoPlayback\tcpkg\packages\EventVideoPlayback.XAE\EventVideoPlayback.XAE.Workload.nuspec" -o "C:\GitHub\EventVideoPlayback\tcpkg\packages"
```

## Installation
Once packed, install the package with:
```bash
tcpkg install Beckhoff-USA-Community.XAE.EventVideoPlayback
```

This will automatically install all required components for engineering:
- HMI Control for TwinCAT HMI projects
- PLC Library for TwinCAT XAE projects
- Comprehensive documentation
- All necessary dependencies

## Included Dependencies
This workload package installs the following components:
- **Beckhoff-USA-Community.XAE.HMI.EventVisionControl** (1.1.3) - HMI controls for Event Vision
- **Beckhoff-USA-Community.XAE.PLC.Lib.EventVideoPlayback** (1.1.1) - PLC library for video playback events
- **Beckhoff-USA-Community.XAE.Documentation.EventVideoPlayback** (2.0.0) - Complete system documentation

## Uninstallation
```bash
tcpkg uninstall Beckhoff-USA-Community.XAE.EventVideoPlayback
```

This will:
- Remove all installed component packages
- Uninstall the PLC library from the TwinCAT repository
- Remove HMI controls and documentation
- Clean up all related installation directories

## Customization
Before building, update the `.nuspec` file with:
- Your company name in `<authors>`
- Your project URL in `<projectUrl>`
- Your copyright information
- The correct version number
- Dependency versions if needed

**Note:** Do not modify the `<packageTypes>` section - this defines the package as a workload.

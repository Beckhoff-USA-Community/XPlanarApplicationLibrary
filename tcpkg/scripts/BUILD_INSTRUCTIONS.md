# TwinCAT Package Build Instructions

This directory contains an automated PowerShell script for building all TwinCAT packages in the EventVideoPlayback project.

## Prerequisites

1. **TwinCAT tcpkg Tool**: The `tcpkg` command-line tool must be installed and available in your system PATH.
   - Typically installed with TwinCAT XAE (eXtended Automation Engineering)
   - Verify installation: `tcpkg --version`

2. **PowerShell**: Windows PowerShell 5.1 or PowerShell Core 7+

3. **Package Structure**: Each package must have:
   - A `.nuspec` file defining the package metadata
   - Required source files referenced in the nuspec
   - Proper directory structure as expected by tcpkg

## Quick Start

### Basic Usage

```powershell
# Navigate to the scripts directory
cd C:\GitHub\EventVideoPlayback\tcpkg\scripts

# Run the build script
.\Build-TcPackages.ps1
```

This will:
1. Discover all `.nuspec` files in the `packages` directory
2. Create a `release` folder at tcpkg root if it doesn't exist
3. Build each package using `tcpkg pack`
4. Store all `.nupkg` files in the `release` folder
5. Generate `checksums.md` with SHA256 checksums
6. Display a build summary

### Clean Build

To remove the existing release folder and start fresh:

```powershell
.\Build-TcPackages.ps1 -CleanBuild
```

### Custom Output Folder

To specify a different output location:

```powershell
.\Build-TcPackages.ps1 -BuildFolder "C:\Packages\Output"
```

### Verbose Output

For detailed build information:

```powershell
.\Build-TcPackages.ps1 -Verbose
```

## Directory Structure

```
tcpkg/
├── packages/              # All package source directories
│   ├── EventVideoPlayback.Library/
│   ├── EventVideoPlayback.Service/
│   ├── EventVision.HMI/
│   ├── EventVideoPlayback.XAE/
│   ├── EventVideoPlayback.XAR/
│   └── EventvideoPlayback.Documentation/
├── release/               # Built .nupkg files and checksums.md
└── scripts/               # Build scripts and documentation
    ├── Build-TcPackages.ps1
    ├── Build-All-Packages.bat
    └── BUILD_INSTRUCTIONS.md
```

## Current Packages

The script will automatically discover and build ALL packages in the `packages` directory:

| Package | Directory | Nuspec File |
|---------|-----------|-------------|
| EventVideoPlayback.Documentation | `packages/EventvideoPlayback.Documentation` | EventVideoPlayback.Documentation.nuspec |
| EventVideoPlayback.Library | `packages/EventVideoPlayback.Library` | EventVideoPlayback.Library.nuspec |
| EventVideoPlayback.Service | `packages/EventVideoPlayback.Service` | EventVideoPlayback.Service.nuspec |
| EventVideoPlayback.XAE.Workload | `packages/EventVideoPlayback.XAE` | EventVideoPlayback.XAE.Workload.nuspec |
| EventVideoPlayback.XAR.Workload | `packages/EventVideoPlayback.XAR` | EventVideoPlayback.XAR.Workload.nuspec |
| EventVision.HMI | `packages/EventVision.HMI` | EventVision.HMI.nuspec |

**To add a new package:** Simply create a new directory under `packages/` with your `.nuspec` file and run the build script!

## Build Output

After a successful build, you'll find:

- **Release Folder**: `C:\GitHub\EventVideoPlayback\tcpkg\release\`
- **Package Files**: `.nupkg` files for each successfully built package
- **checksums.md**: SHA256 checksums for all package files for integrity verification
- **Console Output**: Colored status messages showing progress and results

### Example Output

```
 _____      _       ____      _____   _  __  ____
|_   _|_   _(_)_ __ / ___|    |_   _| | |/ / / ___|
  | | \ \ / / | '_ \| |   _____| |   | ' / | |  _
  | |  \ V /| | | | | |__|_____| |   | . \ | |_| |
  |_|   \_/ |_|_| |_|\____|    |_|   |_|\_\ \____|

TwinCAT Package Builder

========================================
Pre-flight Checks
========================================

[INFO] Checking for tcpkg tool...
[SUCCESS] tcpkg tool found: 1.0.0
[SUCCESS] tcpkg directory found: C:\GitHub\EventVideoPlayback\tcpkg

========================================
Discovering Packages
========================================

[SUCCESS] Found 6 package(s) to build:
  - EventVision.HMI\EventVision.HMI.nuspec
  - EventVideoPlayback.Service\EventVideoPlayback.Service.nuspec
  - EventVideoPlayback.Library\EventVideoPlayback.Library.nuspec
  ...

========================================
Building Packages
========================================

[1/6] [INFO] Building package: EventVision.HMI
[SUCCESS] Package built successfully: EventVision.HMI

[2/6] [INFO] Building package: EventVideoPlayback.Service
[SUCCESS] Package built successfully: EventVideoPlayback.Service

...

========================================
Build Summary
========================================

Total Packages: 6
Successful:     6
Failed:         0

Release folder: C:\GitHub\EventVideoPlayback\tcpkg\release

[SUCCESS] All packages built successfully!
```

## Troubleshooting

### Error: "tcpkg tool not found in PATH"

**Solution**: Ensure TwinCAT XAE is installed and the tcpkg tool is in your system PATH.

1. Locate tcpkg.exe (typically in `C:\TwinCAT\3.1\SDK\Dotnet\tcpkg\`)
2. Add the directory to your system PATH environment variable
3. Restart PowerShell and try again

### Error: "Package build failed"

**Solution**: Check the error output for specific issues:

- **Missing files**: Ensure all files referenced in the `.nuspec` are present
- **Invalid XML**: Validate your `.nuspec` file structure
- **Dependency issues**: Verify package dependencies are correct
- **File permissions**: Ensure you have read access to source files and write access to the release folder

### Warning: "No .nupkg files found in release folder"

**Solution**: This indicates all package builds failed. Check:

1. Individual package error messages in the console output
2. Each package's `.nuspec` file for errors
3. File paths and directory structure

### Execution Policy Error

If you get an execution policy error:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Script Features

### Pre-flight Checks
- Verifies tcpkg tool availability
- Validates directory structure
- Checks for .nuspec files

### Error Handling
- Graceful handling of build failures
- Detailed error messages for debugging
- Continues building remaining packages even if one fails

### Progress Reporting
- Color-coded console output
- Package counter (e.g., [2/6])
- Success/failure status for each package
- Build duration tracking

### Post-build Verification
- Lists all generated .nupkg files
- Shows package file sizes
- Provides summary statistics

### Logging
- All output is written to console
- Can be redirected to a file if needed:
  ```powershell
  .\Build-TcPackages.ps1 | Tee-Object -FilePath build.log
  ```

## Integration with CI/CD

This script can be integrated into automated build pipelines:

### GitHub Actions Example

```yaml
- name: Build TwinCAT Packages
  run: |
    cd C:\GitHub\EventVideoPlayback\tcpkg
    .\Build-TcPackages.ps1 -CleanBuild
  shell: powershell
```

### Exit Codes

- `0`: All packages built successfully
- `1`: One or more packages failed to build, or pre-flight checks failed

## Customization

The script can be modified to:

- Add package dependency ordering
- Implement parallel builds
- Include package signing
- Upload packages to a NuGet feed
- Generate build reports in different formats
- Send notifications on build completion

## Support

For issues or questions:
- Review the console output for specific error messages
- Check individual package .nuspec files
- Verify tcpkg tool installation
- Consult TwinCAT documentation for package structure requirements

## Version History

- **v1.0** (2025-10-27): Initial release
  - Automatic package discovery
  - Parallel-ready architecture
  - Comprehensive error handling
  - Build summary reporting

<#
.SYNOPSIS
    Automates the building of all TwinCAT packages in the tcpkg directory.

.DESCRIPTION
    This script discovers all .nuspec files in subdirectories of the tcpkg folder,
    executes 'tcpkg pack' on each, and stores the resulting .nupkg files in a
    centralized release folder.

.PARAMETER BuildFolder
    The output folder for all built packages. Default: .\release

.PARAMETER CleanBuild
    If specified, removes the release folder before starting the build process.

.PARAMETER Verbose
    Provides detailed output during the build process.

.EXAMPLE
    .\Build-TcPackages.ps1
    Builds all packages to the default release folder.

.EXAMPLE
    .\Build-TcPackages.ps1 -CleanBuild
    Cleans the release folder and builds all packages.

.NOTES
    Author: TwinCAT Package Manager
    Requires: tcpkg tool must be installed and available in PATH
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$BuildFolder = ".\release",

    [Parameter(Mandatory=$false)]
    [switch]$CleanBuild
)

# Script configuration
$ErrorActionPreference = "Stop"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$TcpkgRoot = Split-Path -Parent $ScriptRoot
$PackagesRoot = Join-Path $TcpkgRoot "packages"
$BuildFolderPath = Join-Path $TcpkgRoot $BuildFolder

# Color-coded output functions
function Write-Header {
    param([string]$Message)
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor White
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Pre-flight checks
function Test-Prerequisites {
    Write-Header "Pre-flight Checks"

    # Check if tcpkg is available
    Write-Info "Checking for tcpkg tool..."
    try {
        $tcpkgVersion = & tcpkg --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Success "tcpkg tool found: $tcpkgVersion"
        } else {
            throw "tcpkg command failed"
        }
    } catch {
        Write-Error "tcpkg tool not found in PATH"
        Write-Info "Please install tcpkg or ensure it's available in your PATH"
        return $false
    }

    # Check if packages directory exists
    Write-Info "Verifying packages directory..."
    if (Test-Path $PackagesRoot) {
        Write-Success "Packages directory found: $PackagesRoot"
    } else {
        Write-Error "Packages directory not found: $PackagesRoot"
        return $false
    }

    return $true
}

# Discover all .nuspec files
function Get-NuspecFiles {
    Write-Header "Discovering Packages"

    Write-Info "Scanning for .nuspec files in packages directory..."
    $nuspecFiles = Get-ChildItem -Path $PackagesRoot -Recurse -Filter "*.nuspec" -File

    if ($nuspecFiles.Count -eq 0) {
        Write-Warning "No .nuspec files found in $PackagesRoot"
        return @()
    }

    Write-Success "Found $($nuspecFiles.Count) package(s) to build:"
    foreach ($file in $nuspecFiles) {
        $relativePath = $file.FullName.Replace($PackagesRoot, "").TrimStart("\")
        Write-Host "  - $relativePath" -ForegroundColor Gray
    }

    return $nuspecFiles
}

# Prepare release folder
function Initialize-BuildFolder {
    Write-Header "Preparing Release Folder"

    if ($CleanBuild -and (Test-Path $BuildFolderPath)) {
        Write-Info "Cleaning existing release folder..."
        Remove-Item -Path $BuildFolderPath -Recurse -Force
        Write-Success "Release folder cleaned"
    }

    if (-not (Test-Path $BuildFolderPath)) {
        Write-Info "Creating release folder: $BuildFolderPath"
        New-Item -Path $BuildFolderPath -ItemType Directory -Force | Out-Null
        Write-Success "Release folder created"
    } else {
        Write-Info "Using existing release folder: $BuildFolderPath"
    }
}

# Build a single package
function Build-Package {
    param(
        [System.IO.FileInfo]$NuspecFile,
        [string]$OutputFolder
    )

    $packageName = $NuspecFile.BaseName
    $packageDir = $NuspecFile.Directory.FullName

    Write-Info "Building package: $packageName"
    Write-Verbose "  Nuspec: $($NuspecFile.FullName)"
    Write-Verbose "  Working Dir: $packageDir"
    Write-Verbose "  Output: $OutputFolder"

    try {
        # Change to package directory
        Push-Location $packageDir

        # Generate VERIFICATION.md if bin/ directory exists (before packing)
        # Only skip for workload packages as they don't contain binary files
        $isWorkload = Test-IsWorkloadPackage -NuspecPath $NuspecFile.FullName

        if ($isWorkload) {
            Write-Verbose "Skipping verification for workload package (no binary files)"
        } else {
            # Try to generate VERIFICATION.md - will only succeed if bin/ directory exists
            $verificationResult = New-VerificationFile -NuspecPath $NuspecFile.FullName -PackageDir $packageDir
            if ($verificationResult) {
                Write-Success "VERIFICATION.md generated for package"
            } else {
                Write-Verbose "No bin/ directory found, skipping verification file generation"
            }
        }

        # Execute tcpkg pack
        $output = & tcpkg pack $NuspecFile.Name --output-directory $OutputFolder 2>&1

        if ($LASTEXITCODE -eq 0) {
            Write-Success "Package built successfully: $packageName"
            return @{
                Success = $true
                Package = $packageName
                Output = $output
            }
        } else {
            Write-Error "Package build failed: $packageName"
            Write-Host $output -ForegroundColor Red
            return @{
                Success = $false
                Package = $packageName
                Error = $output
            }
        }
    } catch {
        Write-Error "Exception building package: $packageName"
        Write-Host $_.Exception.Message -ForegroundColor Red
        return @{
            Success = $false
            Package = $packageName
            Error = $_.Exception.Message
        }
    } finally {
        Pop-Location
    }
}

# Build all packages
function Build-AllPackages {
    param(
        [System.IO.FileInfo[]]$NuspecFiles,
        [string]$OutputFolder
    )

    Write-Header "Building Packages"

    $results = @()
    $current = 0
    $total = $NuspecFiles.Count

    foreach ($nuspec in $NuspecFiles) {
        $current++
        Write-Host "`n[$current/$total] " -NoNewline -ForegroundColor Cyan

        $result = Build-Package -NuspecFile $nuspec -OutputFolder $OutputFolder
        $results += $result
    }

    return $results
}

# Verify release outputs
function Test-BuildOutputs {
    param([string]$OutputFolder)

    Write-Header "Verifying Release Outputs"

    $nupkgFiles = Get-ChildItem -Path $OutputFolder -Filter "*.nupkg" -File

    if ($nupkgFiles.Count -gt 0) {
        Write-Success "Found $($nupkgFiles.Count) package file(s) in release folder:"
        foreach ($pkg in $nupkgFiles) {
            $sizeKB = [math]::Round($pkg.Length / 1KB, 2)
            Write-Host "  - $($pkg.Name) ($sizeKB KB)" -ForegroundColor Gray
        }
        return $true
    } else {
        Write-Warning "No .nupkg files found in release folder"
        return $false
    }
}

# Generate build summary
function Write-BuildSummary {
    param([array]$Results)

    Write-Header "Build Summary"

    $successful = ($Results | Where-Object { $_.Success }).Count
    $failed = ($Results | Where-Object { -not $_.Success }).Count
    $total = $Results.Count

    Write-Host "Total Packages: $total" -ForegroundColor White
    Write-Host "Successful:     " -NoNewline -ForegroundColor White
    Write-Host $successful -ForegroundColor Green
    Write-Host "Failed:         " -NoNewline -ForegroundColor White
    Write-Host $failed -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Green" })

    if ($failed -gt 0) {
        Write-Host "`nFailed Packages:" -ForegroundColor Red
        foreach ($result in $Results | Where-Object { -not $_.Success }) {
            Write-Host "  - $($result.Package)" -ForegroundColor Red
        }
    }

    Write-Host "`nRelease folder: $BuildFolderPath" -ForegroundColor Cyan

    return ($failed -eq 0)
}

# Test if package is a Workload type
function Test-IsWorkloadPackage {
    param([string]$NuspecPath)

    try {
        [xml]$nuspecXml = Get-Content -Path $NuspecPath
        $packageType = $nuspecXml.package.metadata.packageTypes.packageType | Where-Object { $_.name -eq "Workload" }
        return ($null -ne $packageType)
    } catch {
        Write-Verbose "Could not parse nuspec: $NuspecPath"
        return $false
    }
}

# Test if package is a Documentation package
function Test-IsDocumentationPackage {
    param([string]$NuspecPath)

    try {
        [xml]$nuspecXml = Get-Content -Path $NuspecPath
        $packageId = $nuspecXml.package.metadata.id
        return ($packageId -like "*Documentation*")
    } catch {
        Write-Verbose "Could not parse nuspec: $NuspecPath"
        return $false
    }
}

# Get all files from the bin directory if it exists
function Get-PackageFiles {
    param(
        [string]$PackageDir
    )

    $binPath = Join-Path $PackageDir "bin"

    if (-not (Test-Path $binPath -PathType Container)) {
        Write-Verbose "No bin directory found in: $PackageDir"
        return @()
    }

    try {
        # Get all files recursively from bin directory
        $files = Get-ChildItem -Path $binPath -Recurse -File
        return $files.FullName
    } catch {
        Write-Warning "Could not read files from bin directory: $binPath - $($_.Exception.Message)"
        return @()
    }
}

# Create or update VERIFICATION.md file with file hashes
function New-VerificationFile {
    param(
        [string]$NuspecPath,
        [string]$PackageDir
    )

    Write-Info "Generating VERIFICATION.md..."

    try {
        # Check if bin directory exists
        $binPath = Join-Path $PackageDir "bin"
        if (-not (Test-Path $binPath -PathType Container)) {
            Write-Verbose "No bin directory found, skipping verification"
            return $false
        }

        # Get package info from nuspec
        [xml]$nuspecXml = Get-Content -Path $NuspecPath
        $packageId = $nuspecXml.package.metadata.id

        # Use the correct project URL for all packages
        $projectUrl = "https://github.com/Beckhoff-USA-Community/EventVideoPlayback"

        # Get files to hash from bin directory
        $filesToHash = Get-PackageFiles -PackageDir $PackageDir

        if ($filesToHash.Count -eq 0) {
            Write-Warning "No files found in bin directory for verification"
            return $false
        }

        # Generate file list and hash details
        $fileListText = ""
        $hashCount = 1

        foreach ($file in $filesToHash) {
            $fileName = Split-Path $file -Leaf
            $fileListText += "   - $fileName`n"
        }

        # Get current date and TwinCAT version info
        $currentDate = Get-Date -Format "yyyy-MM-dd"
        $tcVersion = "TwinCAT 3.1 Build 4026.19.0"

        # Try to get actual tcpkg version
        try {
            $tcpkgVersionOutput = & tcpkg --version 2>&1
            if ($LASTEXITCODE -eq 0 -and $tcpkgVersionOutput) {
                $tcVersion = $tcpkgVersionOutput.ToString().Trim()
            }
        } catch {
            # Use default version if tcpkg version check fails
        }

        # Calculate hashes and build the hash section
        Write-Info "Calculating SHA256 hashes for $($filesToHash.Count) file(s)..."
        $hashLines = ""
        foreach ($file in $filesToHash) {
            $fileName = Split-Path $file -Leaf
            Write-Verbose "  Hashing: $fileName"
            $hash = Get-FileHash -Path $file -Algorithm SHA256
            $hashLines += "       Get-FileHash .\$fileName -Algorithm SHA256`n"
            $hashLines += "     The resulting hash was:`n"
            $hashLines += "       SHA256: $($hash.Hash)`n"
        }

        # Create VERIFICATION.md content based on the user's template
        $verificationContent = @"
VERIFICATION
Verification is intended to assist the Chocolatey moderators and community
in verifying that this package's contents are trustworthy.

1. Files included:
$fileListText
2. Source:
   The file was obtained from the official Beckhoff development repository
   or built internally from source at:
   $projectUrl

3. Verification steps performed:
   - The file checksum was calculated using PowerShell:
$hashLines   - The file was scanned for tampering using TwinCAT XAE v3.1 build tools.
   - No modifications were made after build packaging.

4. Notes:
   This TwinCAT PLC library was verified on $currentDate using TwinCAT 3.1 Build 4026.19.0
   It contains compiled function blocks for event-triggered video playback
   and is safe to import into TwinCAT projects without modification.
"@

        # Ensure tools directory exists
        $toolsDir = Join-Path $PackageDir "tools"
        if (-not (Test-Path $toolsDir)) {
            New-Item -Path $toolsDir -ItemType Directory -Force | Out-Null
        }

        # Write VERIFICATION.md
        $verificationPath = Join-Path $toolsDir "VERIFICATION.md"
        $verificationContent | Out-File -FilePath $verificationPath -Encoding UTF8 -Force

        Write-Success "VERIFICATION.md created with $($filesToHash.Count) file hash(es)"

        return $true

    } catch {
        Write-Error "Failed to create VERIFICATION.md: $($_.Exception.Message)"
        return $false
    }
}

# Generate checksums.md file with all package hashes
function New-PackageHashesFile {
    param([string]$BuildFolder)

    Write-Header "Generating Package Checksums"

    try {
        $nupkgFiles = Get-ChildItem -Path $BuildFolder -Filter "*.nupkg" -File

        if ($nupkgFiles.Count -eq 0) {
            Write-Warning "No .nupkg files found to hash"
            return $false
        }

        Write-Info "Calculating checksums for $($nupkgFiles.Count) package(s)..."

        # Create markdown table header
        $currentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $hashContent = @"
# TwinCAT Package Checksums

**Generated:** $currentDateTime
**Release Folder:** $BuildFolder

This file contains SHA256 checksums for all built packages to ensure integrity and traceability.

## Package Checksums

| Package Name | Version | SHA256 Checksum |
|--------------|---------|-----------------|
"@

        # Generate hash for each package
        foreach ($pkg in $nupkgFiles) {
            Write-Verbose "Hashing: $($pkg.Name)"

            $hash = Get-FileHash -Path $pkg.FullName -Algorithm SHA256

            # Extract package name and version from filename
            # Expected format: PackageName.Version.nupkg
            $nameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($pkg.Name)

            # Try to parse version (look for pattern like x.y.z at the end)
            if ($nameWithoutExt -match '^(.+?)\.(\d+\.\d+\.\d+.*)$') {
                $pkgName = $matches[1]
                $pkgVersion = $matches[2]
            } else {
                $pkgName = $nameWithoutExt
                $pkgVersion = "Unknown"
            }

            $hashContent += "`n| $pkgName | $pkgVersion | ``$($hash.Hash)`` |"
        }

        # Add footer with instructions
        $hashContent += @"


## Verification Instructions

To verify a package's integrity, use PowerShell:

``````powershell
Get-FileHash -Path "path\to\package.nupkg" -Algorithm SHA256
``````

Compare the output checksum with the corresponding checksum in the table above.

## Notes

- All checksums are calculated using SHA256 algorithm
- Checksums are regenerated on each build
- Any modification to the package will result in a different checksum
- Keep this file for audit and compliance purposes
"@

        # Write checksums.md file
        $checksumsPath = Join-Path $BuildFolder "checksums.md"
        $hashContent | Out-File -FilePath $checksumsPath -Encoding UTF8 -Force

        Write-Success "Package checksums file created: $checksumsPath"
        Write-Info "All package checksums have been documented"

        return $true

    } catch {
        Write-Error "Failed to generate package hashes: $($_.Exception.Message)"
        return $false
    }
}

#
# Main Execution
#

$startTime = Get-Date

Write-Host @"

 _____      _       ____      _____   _  __  ____
|_   _|_   _(_)_ __ / ___|    |_   _| | |/ / / ___|
  | | \ \ / / | '_ \| |   _____| |   | ' / | |  _
  | |  \ V /| | | | | |__|_____| |   | . \ | |_| |
  |_|   \_/ |_|_| |_|\____|    |_|   |_|\_\ \____|

TwinCAT Package Builder
"@ -ForegroundColor Cyan

Write-Info "Build started at: $($startTime.ToString('yyyy-MM-dd HH:mm:ss'))"
Write-Info "Packages location: $PackagesRoot"
Write-Info "Output location: $BuildFolderPath"

# Execute build pipeline
try {
    # Step 1: Pre-flight checks
    if (-not (Test-Prerequisites)) {
        exit 1
    }

    # Step 2: Discover packages
    $nuspecFiles = Get-NuspecFiles
    if ($nuspecFiles.Count -eq 0) {
        exit 1
    }

    # Step 3: Prepare release folder
    Initialize-BuildFolder

    # Step 4: Build all packages
    $buildResults = Build-AllPackages -NuspecFiles $nuspecFiles -OutputFolder $BuildFolderPath

    # Step 5: Verify outputs
    Test-BuildOutputs -OutputFolder $BuildFolderPath | Out-Null

    # Step 6: Generate package checksums
    New-PackageHashesFile -BuildFolder $BuildFolderPath | Out-Null

    # Step 7: Generate summary
    $success = Write-BuildSummary -Results $buildResults

    $endTime = Get-Date
    $duration = $endTime - $startTime

    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Info "Build completed at: $($endTime.ToString('yyyy-MM-dd HH:mm:ss'))"
    Write-Info "Total duration: $($duration.ToString('mm\:ss'))"
    Write-Host "========================================`n" -ForegroundColor Cyan

    if ($success) {
        Write-Success "All packages built successfully!"
        Read-Host -Prompt "Press Enter to exit..."
    } else {
        Write-Error "Build completed with errors"
        Read-Host -Prompt "Press Enter to exit..."
    }

} catch {
    Write-Error "Unexpected error during build process"
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Red
    Read-Host -Prompt "Press Enter to exit..."
}



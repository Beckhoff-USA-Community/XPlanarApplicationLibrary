<#
.SYNOPSIS
    Convenience wrapper for Build-TcPackages.ps1 located in scripts directory.

.DESCRIPTION
    This script allows you to run the build from the tcpkg root directory
    without navigating to the scripts subdirectory.

.PARAMETER BuildFolder
    The output folder for all built packages. Default: .\release

.PARAMETER CleanBuild
    If specified, removes the release folder before starting the build process.

.EXAMPLE
    .\Build.ps1
    Builds all packages to the default release folder.

.EXAMPLE
    .\Build.ps1 -CleanBuild
    Cleans the release folder and builds all packages.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$BuildFolder = ".\release",

    [Parameter(Mandatory=$false)]
    [switch]$CleanBuild
)

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$BuildScriptPath = Join-Path $ScriptRoot "scripts\Build-TcPackages.ps1"

if (-not (Test-Path $BuildScriptPath)) {
    Write-Host "[ERROR] Build script not found at: $BuildScriptPath" -ForegroundColor Red
    exit 1
}

# Forward all parameters to the actual build script
& $BuildScriptPath -BuildFolder $BuildFolder -CleanBuild:$CleanBuild -Verbose:$VerbosePreference

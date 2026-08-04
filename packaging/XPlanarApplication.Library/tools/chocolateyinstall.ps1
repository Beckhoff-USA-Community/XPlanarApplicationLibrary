$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$libraryFile = Join-Path $toolsDir 'XPlanarApplication.library'

# The library version this package carries. Keep this line in step with the
# package version; the release check compares the two.
$libraryVersion = '2.0.7.1'

# RepTool ships with every 4026 engineering installation and installs a
# library into the library repository the same way the Library Repository
# dialog does.
$repTools = @(Join-Path 'C:\Program Files (x86)\Beckhoff\TwinCAT\3.1\Components\Plc\Build_4026.*\' 'Common\RepTool.exe' -Resolve -ErrorAction SilentlyContinue)
if ($repTools.Length -eq 0) {
    throw 'No TwinCAT XAE 4026 installation with RepTool.exe was found. This package needs an engineering system.'
}

# Wildcard resolution sorts alphabetically, which puts Build_4026.9 after
# Build_4026.14, so the build number is compared numerically instead
$repTool = $repTools | Sort-Object { [version]((Split-Path (Split-Path (Split-Path $_ -Parent) -Parent) -Leaf) -replace '^Build_', '') } | Select-Object -Last 1
$buildName = Split-Path (Split-Path (Split-Path $repTool -Parent) -Parent) -Leaf
$repToolArgs = "--profile=`"TwinCAT PLC Control_$buildName`"", "--installLib `"$libraryFile`""
$proc = Start-Process $repTool -ArgumentList $repToolArgs -Wait -WindowStyle Hidden -PassThru
if ($proc.ExitCode -ne 0) {
    Write-Warning "RepTool returned code $($proc.ExitCode)."
}

# RepTool exit codes are not documented, so the outcome is checked directly:
# the library must exist in the repository after the install
$repoEntry = Join-Path $env:ALLUSERSPROFILE "Beckhoff\TwinCAT\PlcEngineering\Managed Libraries\Beckhoff Automation LLC\XPlanarApplication\$libraryVersion"
if (-not (Test-Path $repoEntry)) {
    throw "The library did not appear in the library repository under $repoEntry. Close XAE and install the package again."
}

Write-Host 'The XPlanarApplication library is installed in the XAE library repository.'

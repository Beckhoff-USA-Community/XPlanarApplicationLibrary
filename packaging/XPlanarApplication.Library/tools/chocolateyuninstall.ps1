$ErrorActionPreference = 'Stop'

# The identity format is "Name, Version (Company)". Version and company must
# match the installed library, so keep this line in step with the package.
$libraryVersion = '2.0.7.1'
$libraryIdentity = "XPlanarApplication, $libraryVersion (Beckhoff Automation LLC)"

# A missing engineering installation is fine here: with no RepTool there is
# no library repository to remove the library from.
$repTools = @(Join-Path 'C:\Program Files (x86)\Beckhoff\TwinCAT\3.1\Components\Plc\Build_4026.*\' 'Common\RepTool.exe' -Resolve -ErrorAction SilentlyContinue)
if ($repTools.Length -gt 0) {
    # Wildcard resolution sorts alphabetically, which puts Build_4026.9 after
    # Build_4026.14, so the build number is compared numerically instead
    $repTool = $repTools | Sort-Object { [version]((Split-Path (Split-Path (Split-Path $_ -Parent) -Parent) -Leaf) -replace '^Build_', '') } | Select-Object -Last 1
    $buildName = Split-Path (Split-Path (Split-Path $repTool -Parent) -Parent) -Leaf
    $repToolArgs = "--profile=`"TwinCAT PLC Control_$buildName`"", "--uninstallLib `"$libraryIdentity`""
    $proc = Start-Process $repTool -ArgumentList $repToolArgs -Wait -WindowStyle Hidden -PassThru
    if ($proc.ExitCode -ne 0) {
        Write-Warning "RepTool returned code $($proc.ExitCode)."
    }
}

# RepTool exit codes are not documented, so the outcome is checked directly
$repoEntry = Join-Path $env:ALLUSERSPROFILE "Beckhoff\TwinCAT\PlcEngineering\Managed Libraries\Beckhoff Automation LLC\XPlanarApplication\$libraryVersion"
if (Test-Path $repoEntry) {
    Write-Warning "The library is still in the library repository under $repoEntry. Close XAE and uninstall the package again."
} else {
    Write-Host 'The XPlanarApplication library was removed.'
}

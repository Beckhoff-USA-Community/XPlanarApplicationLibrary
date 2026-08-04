# XAE caches the content of the library repository. A stale cache after a
# library change causes confusing errors, so it is cleared here.
$manLibDir = Join-Path $env:ALLUSERSPROFILE 'Beckhoff\TwinCAT\PlcEngineering\Managed Libraries'
if (Test-Path $manLibDir) {
    try {
        Get-ChildItem -Path $manLibDir -Filter 'cache*' -Force | Remove-Item -Recurse -Force
    } catch {
        throw "A library repository cache file could not be removed, usually because XAE is open. Close XAE and run the operation again. $_"
    }
}

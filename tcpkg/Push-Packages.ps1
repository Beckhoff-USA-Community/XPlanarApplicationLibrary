# Push-Packages.ps1
# Pushes all .nupkg files in the release directory to a specified package server

# Set the working directory to the script's location
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

# Prompt for server URL
$serverUrl = Read-Host "Enter the package server URL (e.g., https://packages.beckhoff-usa-community.com/api/v2/package)"

# Prompt for API key
Write-Host "Enter the API key (input will be visible):" -ForegroundColor Yellow
$apiKey = Read-Host

# Validate inputs
if ([string]::IsNullOrWhiteSpace($serverUrl)) {
    Write-Host "Error: Server URL cannot be empty" -ForegroundColor Red
    exit 1
}

if ([string]::IsNullOrWhiteSpace($apiKey)) {
    Write-Host "Error: API key cannot be empty" -ForegroundColor Red
    exit 1
}

# Find all .nupkg files in the release directory
$packagesPath = Join-Path $ScriptDir "release"
$packages = Get-ChildItem -Path $packagesPath -Filter "*.nupkg" -File

if ($packages.Count -eq 0) {
    Write-Host "No .nupkg files found in $packagesPath" -ForegroundColor Yellow
    exit 0
}

Write-Host "`nFound $($packages.Count) package(s) to push:" -ForegroundColor Green
$packages | ForEach-Object { Write-Host "  - $($_.Name)" }

# Ask for confirmation
$confirmation = Read-Host "`nDo you want to push these packages? (Y/N)"
if ($confirmation -ne 'Y' -and $confirmation -ne 'y') {
    Write-Host "Operation cancelled" -ForegroundColor Yellow
    exit 0
}

# Push each package
Write-Host "`nPushing packages..." -ForegroundColor Green
$successCount = 0
$failCount = 0

foreach ($package in $packages) {
    Write-Host "`nPushing $($package.Name)..." -ForegroundColor Cyan

    # Change to the release directory to push the package
    Push-Location $packagesPath

    try {
        & tcpkg push $package.Name -s="$serverUrl" -k="$apiKey"

        if ($LASTEXITCODE -eq 0) {
            Write-Host "  Successfully pushed $($package.Name)" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "  Failed to push $($package.Name) (exit code: $LASTEXITCODE)" -ForegroundColor Red
            $failCount++
        }
    } catch {
        Write-Host "  Error pushing $($package.Name): $($_.Exception.Message)" -ForegroundColor Red
        $failCount++
    } finally {
        Pop-Location
    }
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Push Summary:" -ForegroundColor Cyan
Write-Host "  Total packages: $($packages.Count)" -ForegroundColor White
Write-Host "  Successfully pushed: $successCount" -ForegroundColor Green
Write-Host "  Failed: $failCount" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "White" })
Write-Host "========================================" -ForegroundColor Cyan

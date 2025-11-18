@echo off
REM ============================================================================
REM TwinCAT Package Builder - Batch Wrapper
REM ============================================================================
REM This batch file runs the PowerShell build script with default settings.
REM Double-click this file to build all TwinCAT packages.
REM ============================================================================

echo.
echo ============================================================================
echo TwinCAT Package Builder
echo ============================================================================
echo.
echo Starting build process...
echo.

REM Change to script directory
cd /d "%~dp0"

REM Execute PowerShell script (now in scripts subdirectory)
powershell.exe -ExecutionPolicy Bypass -File ".\Build-TcPackages.ps1" -CleanBuild

REM Check exit code
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================================================
    echo Build completed successfully!
    echo ============================================================================
    echo.
    echo Output location: %~dp0..\release
    echo Checksums file:  %~dp0..\release\checksums.md
    echo.
) else (
    echo.
    echo ============================================================================
    echo Build failed with errors. Please review the output above.
    echo ============================================================================
    echo.
)

REM Keep window open to review results
pause

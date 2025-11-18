@echo off
REM ============================================================================
REM TwinCAT Package Builder - Root Convenience Wrapper
REM ============================================================================
REM This batch file allows you to run the build from the tcpkg root directory.
REM It forwards the call to scripts\Build-All-Packages.bat
REM ============================================================================

cd /d "%~dp0scripts"
call Build-All-Packages.bat

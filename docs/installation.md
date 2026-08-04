# Installation

The library ships as a TwinCAT package on the GitHub package feed of the Beckhoff USA Community organization. The package installs the library into the XAE library repository, ready to add as a reference, and keeps updates a single command away.

## Version compatibility

| TF5890 | Library | TwinCAT |
|--|--|--|
| 4.1.x | 1.0 | Tc4024 only |
| 4.2.x | 1.2 | Tc4024 / Tc4026 |
| 4.4.x | 1.4 | Tc4026 only |
| 5.0.x | 2.x | Tc4026 only, TF5400 3.4.45 or greater |

!!! note
    Version 2.0 is not a direct compatibility upgrade. See the [Version 2.0 release notes](https://github.com/Beckhoff-USA-Community/XPlanarApplicationLibrary/wiki/Version-2.0-release-notes) in the project wiki before upgrading a 1.x application.

## Adding the feed

GitHub requires a login for its package feeds, even for public packages, so you need a GitHub account and a personal access token. Create a token of the classic type with the read:packages scope under Developer settings in your GitHub account settings, then from an administrator PowerShell:

```powershell
tcpkg config unset -n VerifySignatures
tcpkg source add -n "Beckhoff-USA-Community" -s https://nuget.pkg.github.com/Beckhoff-USA-Community/index.json -u <your GitHub user name> --take 100
```

Both steps are required, and the order matters. Community packages carry no Beckhoff signature, including the disclaimer package the feed presents while it is being added, so verification must be off before the feed is added. GitHub rejects search requests larger than 100 results per page while the package manager asks for 500 by default, so without `--take 100` adding the feed fails with the error "Failed to retrieve metadata from source". Adding the feed shows the community disclaimer; accept it to continue.

## Installing

```powershell
tcpkg install Beckhoff-USA-Community.XPlanarApplication.XAE -y
```

The workload installs the XPlanarApplication PLC library into the XAE library repository, ready to add as a reference. TF5890 TwinCAT 3 XPlanar and TF5400 TwinCAT 3 Advanced Motion Pack must be installed to build a project that uses the library; the table above maps library versions to TF5890 versions.

If adding the feed fails, confirm the token is the classic type (it starts with ghp_), that it has the read:packages scope, and that it has not expired.

## Updating

New releases appear on the same feed. Upgrade the workload from an administrator PowerShell and the library package follows, since the workload pins its library at the exact release version:

```powershell
tcpkg upgrade Beckhoff-USA-Community.XPlanarApplication.XAE -y
```

## Uninstalling

Uninstalling the workload removes only the grouping package itself, so list the library package with it:

```powershell
tcpkg uninstall Beckhoff-USA-Community.XPlanarApplication.XAE Beckhoff-USA-Community.XAE.PLC.Lib.XPlanarApplication -y
```

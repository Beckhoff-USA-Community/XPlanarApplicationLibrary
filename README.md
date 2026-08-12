# XPlanar Application Library

A TwinCAT 3 PLC library built on the base functionality of TF5890 XPlanar and TF5400 Advanced Motion. Its main goal is to provide a consistent and flexible jumping off point for using XPlanar in applications: movers, stations, tracks and tiles with queueing, motion command interfaces and station processes.

## Installation  **NEW**

The library ships as a TwinCAT package on the GitHub package feed of the Beckhoff USA Community organization. From an administrator PowerShell, entering your GitHub personal access token when it prompts for a password:

```powershell
tcpkg config unset -n VerifySignatures
tcpkg source add -n "Beckhoff-USA-Community" -s https://nuget.pkg.github.com/Beckhoff-USA-Community/index.json -u <your GitHub user name> --take 100
tcpkg install Beckhoff-USA-Community.XPlanarApplication.XAE -y
```

The first two commands set up the feed and are only needed once per machine. [Adding the package feed](https://github.com/Beckhoff-USA-Community/BAUS_Community_General_Assets/blob/main/feed-setup.md) walks through creating the token, explains why both are required and why the order matters, and covers the common failures. The [installation page](https://beckhoff-usa-community.github.io/XPlanarApplicationLibrary/installation/) of the documentation covers this library specifically, including updating and uninstalling.

The old community package feed on packages.beckhoff-usa-community.com is retired.


## Version compatibility

**Version 2.0 is not a direct compatibility upgrade.** See the [Version 2.0 release notes](https://github.com/Beckhoff-USA-Community/XPlanarApplicationLibrary/wiki/Version-2.0-release-notes) for potential breaking changes.

| TF5890 | Library | TwinCAT | Notes |
|--|--|--|--|
| v4.1.x | 1.0 | Tc4024 only | |
| v4.2.x | 1.2 | Tc4024 / Tc4026 | |
| v4.4.x | 1.4 | Tc4026 only | |
| v5.0.x | 2.x | Tc4026 only | TF5400 Advanced Motion Pack 3.4.45 or greater required |

## Requirements

The following must be installed to build a project that uses the library:

* TE1000 TwinCAT 3 Engineering
* TF5890 TwinCAT 3 XPlanar
* TF5400 TwinCAT 3 Advanced Motion Pack

## Documentation

Please visit the [documentation site](https://beckhoff-usa-community.github.io/XPlanarApplicationLibrary/) for library functionality, installation details, and the changelog.

## How to get support

For any library issue, please raise an issue [here](https://github.com/Beckhoff-USA-Community/XPlanarApplicationLibrary/issues).

For general TwinCAT and Beckhoff product support, contact information can be found on the official [Beckhoff support page](https://www.beckhoff.com/en-us/support/).

## License

This library is created by [Beckhoff Automation LLC](https://www.beckhoff.com/en-us/) and is provided under the MIT license.

## Releasing a new version

The release runbook for maintainers lives on the [releasing page](https://beckhoff-usa-community.github.io/XPlanarApplicationLibrary/releasing/) of the documentation site.

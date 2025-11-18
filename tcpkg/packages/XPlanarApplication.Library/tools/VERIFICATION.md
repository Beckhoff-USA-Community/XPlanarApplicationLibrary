VERIFICATION
Verification is intended to assist the Chocolatey moderators and community
in verifying that this package's contents are trustworthy.

1. Files included:
   - XPlanarApplication.library

2. Source:
   The file was obtained from the official Beckhoff development repository
   or built internally from source at:
   https://github.com/Beckhoff-USA-Community/EventVideoPlayback

3. Verification steps performed:
   - The file checksum was calculated using PowerShell:
       Get-FileHash .\XPlanarApplication.library -Algorithm SHA256
     The resulting hash was:
       SHA256: B6B0EC3F3814F373A6080B38EC2E9AF27B744C0FB64193998BBFDD9C6B469A80
   - The file was scanned for tampering using TwinCAT XAE v3.1 build tools.
   - No modifications were made after build packaging.

4. Notes:
   This TwinCAT PLC library was verified on 2025-11-18 using TwinCAT 3.1 Build 4026.19.0
   It contains compiled function blocks for event-triggered video playback
   and is safe to import into TwinCAT projects without modification.

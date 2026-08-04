# Releasing

This page is the release runbook for maintainers. It covers publishing a documentation change and releasing a new library version to the package feed.

## Docs only change

1. Edit the markdown files under `docs/`.
2. Commit and push to main.
3. The docs workflow builds and publishes the site. Check the Actions tab if the site does not update.

## New library version

1. In XAE, save the new library version as a library file and overwrite the committed file at `packaging/XPlanarApplication.Library/library/XPlanarApplication.library`. The committed file name never changes; only its content does.
2. In the `packaging` folder, replace every occurrence of the previous version with the new one. Five spots across four files: both nuspec versions, the workload dependency pin, and one script variable each in chocolateyinstall.ps1 and chocolateyuninstall.ps1 under `packaging/XPlanarApplication.Library/tools`. The release check names any spot you miss.
3. Add an entry for the new version to `docs/changelog.md`.
4. Commit and push to main.
5. Create the tag. Use the exact version of the new library, prefixed with v, for example:

   ```
   git tag v2.0.8
   ```

   Do not use a trailing zero fourth part; NuGet trims 2.0.8.0 to 2.0.8, so version the library and name the tag without it. Four part versions with a nonzero ending, like 2.0.7.1, are fine.

6. Push the tag:

   ```
   git push origin v2.0.8
   ```

7. Watch the release run in the Actions tab. The step named "Check the tag against the repository" compares the tag against the packaging files and the version stored inside the committed library file, and fails with an exact message if anything disagrees.
8. When the run is green, verify both packages show the new version under the repository's Packages page.

## If the release run fails the version check

1. Read the run log. The check says exactly which file disagrees with the tag.
2. Fix the file, commit, and push.
3. Delete the tag locally and on GitHub:

   ```
   git tag -d v2.0.8
   git push origin :refs/tags/v2.0.8
   ```

4. Create and push the tag again.

## If the push publishes only one package

The run uploads both packages as a build artifact before pushing, so recovery is possible either way. A version that already exists on the feed fails the run on purpose, so the feed never silently disagrees with the tags.

To finish by hand:

1. Download the run artifact from the failed run.
2. Push the missing package with `dotnet nuget push <package>.nupkg --api-key <a token with the write:packages scope> --source https://nuget.pkg.github.com/Beckhoff-USA-Community/index.json`. The feed is then complete and nothing needs to run again.

To start the push over:

1. Delete the half published version on the repository's Packages page.
2. Open the failed run in the Actions tab and rerun it. The release triggers only on tag pushes, so rerunning the existing run is the way to start it again.

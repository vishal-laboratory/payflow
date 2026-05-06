# Release Artifacts

This folder is used for the latest packaged release output.

Use `scripts/sync_release.ps1` after building the app to copy the newest
Flutter release artifact into this folder.

The generated APK uses the app version from `pubspec.yaml`, for example:
`payflow-v1.0.0.apk`.

The GitHub Actions workflow also publishes the latest APK from this folder as
a GitHub Release asset.
param(
  [string]$BuildOutputPath = "build/app/outputs/flutter-apk/app-release.apk",
  [string]$ReleaseFolderPath = "release"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$absoluteBuildOutputPath = Join-Path $repoRoot $BuildOutputPath
$absoluteReleaseFolderPath = Join-Path $repoRoot $ReleaseFolderPath

Push-Location $repoRoot
try {
  flutter build apk --release
} finally {
  Pop-Location
}

$syncResult = & "$PSScriptRoot/sync_release.ps1" -BuildOutputPath $absoluteBuildOutputPath -ReleaseFolderPath $absoluteReleaseFolderPath

Push-Location $repoRoot
try {
  $releaseApkRelativePath = (Resolve-Path -Relative $syncResult.ReleaseApkPath)
  $releaseInfoRelativePath = (Resolve-Path -Relative $syncResult.ReleaseInfoPath)

  git add -- $releaseApkRelativePath $releaseInfoRelativePath

  $status = git status --short -- $releaseApkRelativePath $releaseInfoRelativePath
  if ($status) {
    git commit -m "Update release artifacts v$($syncResult.VersionName)"
    git push github HEAD:main
    Write-Host "Pushed release artifacts to GitHub."
  } else {
    Write-Host "No release artifact changes to push."
  }
} finally {
  Pop-Location
}
param(
  [string]$BuildOutputPath = "build/app/outputs/flutter-apk/app-release.apk",
  [string]$ReleaseFolderPath = "release",
  [string]$PubspecPath = "pubspec.yaml"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

if (-not [System.IO.Path]::IsPathRooted($BuildOutputPath)) {
  $BuildOutputPath = Join-Path $repoRoot $BuildOutputPath
}

if (-not [System.IO.Path]::IsPathRooted($ReleaseFolderPath)) {
  $ReleaseFolderPath = Join-Path $repoRoot $ReleaseFolderPath
}

if (-not [System.IO.Path]::IsPathRooted($PubspecPath)) {
  $PubspecPath = Join-Path $repoRoot $PubspecPath
}

if (-not (Test-Path $BuildOutputPath)) {
  throw "Release APK not found at '$BuildOutputPath'. Run 'flutter build apk --release' first."
}

if (-not (Test-Path $PubspecPath)) {
  throw "pubspec.yaml not found at '$PubspecPath'."
}

$pubspecContent = Get-Content $PubspecPath
$versionLine = $pubspecContent | Where-Object { $_ -match '^version:\s*' } | Select-Object -First 1

if (-not $versionLine) {
  throw "Could not find a version line in '$PubspecPath'."
}

$versionValue = ($versionLine -replace '^version:\s*', '').Trim()
if ($versionValue -notmatch '^[0-9]+\.[0-9]+\.[0-9]+(?:\+[0-9]+)?$') {
  throw "Unsupported version format '$versionValue' in '$PubspecPath'."
}

$versionName = $versionValue.Split('+')[0]

New-Item -ItemType Directory -Force -Path $ReleaseFolderPath | Out-Null

$releaseApkPath = Join-Path $ReleaseFolderPath "payflow-v$versionName.apk"
$releaseInfoPath = Join-Path $ReleaseFolderPath "release-info.txt"

Copy-Item -Force $BuildOutputPath $releaseApkPath

$buildInfo = @(
  "Version: $versionName"
  "Source: $BuildOutputPath"
  "Copied: $(Get-Date -Format o)"
  "Target: $releaseApkPath"
) -join [Environment]::NewLine

Set-Content -Path $releaseInfoPath -Value $buildInfo

Write-Host "Synced latest release to $releaseApkPath"

[pscustomobject]@{
  VersionName = $versionName
  ReleaseApkPath = $releaseApkPath
  ReleaseInfoPath = $releaseInfoPath
  RepoRoot = $repoRoot
}
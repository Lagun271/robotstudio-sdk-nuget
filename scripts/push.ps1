<#
.SYNOPSIS
  Pushes the packed .nupkg files to the private GitHub Packages NuGet feed.

.DESCRIPTION
  Uses the GitHub CLI token (gh auth token), which needs the write:packages scope:
    gh auth refresh -h github.com -s write:packages,read:packages
  Existing versions are skipped (--skip-duplicate); bump RobotStudio or delete the version on GitHub to republish.

.EXAMPLE
  ./scripts/pack.ps1; ./scripts/push.ps1
#>
param(
    [string]$Owner = 'Lagun271',
    [string]$Dotnet = 'dotnet.exe'
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$outDir = Join-Path $repoRoot 'artifacts\nuget'
$packages = @(Get-ChildItem $outDir -Filter *.nupkg -ErrorAction SilentlyContinue)
if ($packages.Count -eq 0) {
    throw "No packages in $outDir. Run ./scripts/pack.ps1 first."
}

$token = (& gh auth token).Trim()
if (-not $token) { throw 'No GitHub CLI token. Run: gh auth login' }

$source = "https://nuget.pkg.github.com/$Owner/index.json"
foreach ($package in $packages) {
    & $Dotnet nuget push $package.FullName --source $source --api-key $token --skip-duplicate
    if ($LASTEXITCODE -ne 0) {
        throw "Push failed for $($package.Name). Check that the gh token has write:packages."
    }
}

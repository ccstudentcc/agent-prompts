param(
    [string]$CodexRoot = (Join-Path $env:USERPROFILE ".codex"),
    [switch]$PlanOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Assert-PathExists {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$Label
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "$Label not found: $Path"
    }
}

function Ensure-Directory {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$publishedCodexDir = Join-Path $repoRoot ".codex"
$publishedAgentsDir = Join-Path $publishedCodexDir "agents"
$publishedSkillsDir = Join-Path $publishedCodexDir "skills"
$tmpRoot = Join-Path $repoRoot "tmp"
$syncTmpRoot = Join-Path $tmpRoot "sync-public-codex"

$sourceAgentsFile = Join-Path $CodexRoot "AGENTS.md"
$sourceAgentsDir = Join-Path $CodexRoot "agents"
$sourceSkillsDir = Join-Path $CodexRoot "skills"

Assert-PathExists -Path $sourceAgentsFile -Label "Source AGENTS.md"
Assert-PathExists -Path $sourceAgentsDir -Label "Source agents directory"
Assert-PathExists -Path $sourceSkillsDir -Label "Source skills directory"

$sourceRoleFiles = Get-ChildItem -Path $sourceAgentsDir -Filter *.toml -File | Sort-Object Name
$sourceSkillDirs = Get-ChildItem -Path $sourceSkillsDir -Directory | Where-Object { $_.Name -ne ".system" } | Sort-Object Name

$publishedRoleFiles = @()
if (Test-Path -LiteralPath $publishedAgentsDir) {
    $publishedRoleFiles = Get-ChildItem -Path $publishedAgentsDir -Filter *.toml -File | Sort-Object Name
}

$publishedSkillDirs = @()
if (Test-Path -LiteralPath $publishedSkillsDir) {
    $publishedSkillDirs = Get-ChildItem -Path $publishedSkillsDir -Directory | Sort-Object Name
}

$repoOnlyRoles = Compare-Object -ReferenceObject $sourceRoleFiles.Name -DifferenceObject $publishedRoleFiles.Name |
    Where-Object { $_.SideIndicator -eq "=>" } |
    Select-Object -ExpandProperty InputObject

$repoOnlySkills = Compare-Object -ReferenceObject $sourceSkillDirs.Name -DifferenceObject $publishedSkillDirs.Name |
    Where-Object { $_.SideIndicator -eq "=>" } |
    Select-Object -ExpandProperty InputObject

$plan = [PSCustomObject]@{
    RepoRoot = $repoRoot
    CodexRoot = $CodexRoot
    SourceRoles = $sourceRoleFiles.Name
    SourceSkills = $sourceSkillDirs.Name
    RepoOnlyPublishedRoles = $repoOnlyRoles
    RepoOnlyPublishedSkills = $repoOnlySkills
    PublishedAgentsDir = $publishedAgentsDir
    PublishedSkillsDir = $publishedSkillsDir
}

if ($PlanOnly) {
    $plan | ConvertTo-Json -Depth 4
    return
}

Ensure-Directory -Path $tmpRoot
Ensure-Directory -Path $syncTmpRoot
Ensure-Directory -Path $publishedCodexDir
Ensure-Directory -Path $publishedAgentsDir
Ensure-Directory -Path $publishedSkillsDir

Copy-Item -LiteralPath $sourceAgentsFile -Destination (Join-Path $publishedCodexDir "AGENTS.md") -Force

foreach ($roleFile in $sourceRoleFiles) {
    Copy-Item -LiteralPath $roleFile.FullName -Destination (Join-Path $publishedAgentsDir $roleFile.Name) -Force
}

foreach ($skillDir in $sourceSkillDirs) {
    $destinationSkillDir = Join-Path $publishedSkillsDir $skillDir.Name
    Ensure-Directory -Path $destinationSkillDir

    $skillChildren = Get-ChildItem -Path $skillDir.FullName -Force
    foreach ($child in $skillChildren) {
        Copy-Item -LiteralPath $child.FullName -Destination $destinationSkillDir -Recurse -Force
    }
}

$reportPath = Join-Path $syncTmpRoot "last-sync-report.json"
$plan | ConvertTo-Json -Depth 4 | Out-File -FilePath $reportPath -Encoding utf8

Write-Output "Synced public Codex snapshot."
Write-Output "Report: $reportPath"
if ($repoOnlyRoles.Count -gt 0) {
    Write-Output "Repo-only published role files kept in repo: $($repoOnlyRoles -join ', ')"
}
if ($repoOnlySkills.Count -gt 0) {
    Write-Output "Repo-only published skill directories kept in repo: $($repoOnlySkills -join ', ')"
}

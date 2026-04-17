[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$RepoRoot = (Join-Path $PSScriptRoot ".."),
    [string]$ConfigPath,
    [string]$CodexRoot,
    [string]$PublishedCodexDir,
    [string[]]$ExcludeSkillNames,
    [switch]$IncludeSystemSkills,
    [switch]$PlanOnly,
    [switch]$AsJson
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-FullPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    return [System.IO.Path]::GetFullPath($Path)
}

function Resolve-PathFromBase {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$BasePath
    )

    if ([System.IO.Path]::IsPathRooted($Path)) {
        return Resolve-FullPath -Path $Path
    }

    return Resolve-FullPath -Path (Join-Path $BasePath $Path)
}

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

function Read-JsonConfig {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $rawConfig = Get-Content -LiteralPath $Path -Raw
    if ([string]::IsNullOrWhiteSpace($rawConfig)) {
        throw "Config file is empty: $Path"
    }

    $config = $rawConfig | ConvertFrom-Json -AsHashtable
    if ($config -isnot [System.Collections.IDictionary]) {
        throw "Config file must contain a JSON object: $Path"
    }

    return $config
}

function Test-ConfigKey {
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]$Config,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    return $Config.Contains($Name)
}

function Get-NameArrayOrEmpty {
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [object[]]$Items
    )

    if ($null -eq $Items -or $Items.Count -eq 0) {
        return @()
    }

    return @($Items)
}

function Copy-DirectoryContents {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourceDirectory,
        [Parameter(Mandatory = $true)]
        [string]$DestinationDirectory
    )

    Ensure-Directory -Path $DestinationDirectory

    $children = Get-ChildItem -LiteralPath $SourceDirectory -Force
    foreach ($child in $children) {
        $destinationPath = Join-Path $DestinationDirectory $child.Name
        if ($PSCmdlet.ShouldProcess($destinationPath, "Copy $($child.FullName)")) {
            Copy-Item -LiteralPath $child.FullName -Destination $destinationPath -Recurse -Force
        }
    }
}

$resolvedRepoRoot = Resolve-FullPath -Path $RepoRoot
$resolvedConfigPath = $null
$config = @{}
$defaultCodexRoot = Resolve-FullPath -Path (Join-Path ([Environment]::GetFolderPath("UserProfile")) ".codex")
$defaultExcludeSkillNames = @(".system")

if ($PSBoundParameters.ContainsKey("ConfigPath")) {
    $resolvedConfigPath = Resolve-PathFromBase -Path $ConfigPath -BasePath $resolvedRepoRoot
} else {
    $defaultConfigPath = Join-Path $resolvedRepoRoot "config.json"
    if (Test-Path -LiteralPath $defaultConfigPath) {
        $resolvedConfigPath = $defaultConfigPath
    }
}

$configBasePath = $resolvedRepoRoot
if ($null -ne $resolvedConfigPath) {
    Assert-PathExists -Path $resolvedConfigPath -Label "Config file"
    $config = Read-JsonConfig -Path $resolvedConfigPath
    $configBasePath = Split-Path -Path $resolvedConfigPath -Parent
}

if ($PSBoundParameters.ContainsKey("CodexRoot")) {
    $resolvedCodexRoot = Resolve-FullPath -Path $CodexRoot
} elseif ((Test-ConfigKey -Config $config -Name "codexRoot") -and -not [string]::IsNullOrWhiteSpace([string]$config.codexRoot)) {
    $resolvedCodexRoot = Resolve-PathFromBase -Path ([string]$config.codexRoot) -BasePath $configBasePath
} else {
    $resolvedCodexRoot = $defaultCodexRoot
}

if ([string]::IsNullOrWhiteSpace($PublishedCodexDir)) {
    if ((Test-ConfigKey -Config $config -Name "publishedCodexDir") -and -not [string]::IsNullOrWhiteSpace([string]$config.publishedCodexDir)) {
        $resolvedPublishedCodexDir = Resolve-PathFromBase -Path ([string]$config.publishedCodexDir) -BasePath $configBasePath
    } else {
        $resolvedPublishedCodexDir = Join-Path $resolvedRepoRoot ".codex"
    }
} else {
    $resolvedPublishedCodexDir = Resolve-FullPath -Path $PublishedCodexDir
}

$publishedAgentsDir = Join-Path $resolvedPublishedCodexDir "agents"
$publishedSkillsDir = Join-Path $resolvedPublishedCodexDir "skills"
$tmpRoot = Join-Path $resolvedRepoRoot "tmp"
$syncTmpRoot = Join-Path $tmpRoot "sync-public-codex"

$sourceAgentsFile = Join-Path $resolvedCodexRoot "AGENTS.md"
$sourceAgentsDir = Join-Path $resolvedCodexRoot "agents"
$sourceSkillsDir = Join-Path $resolvedCodexRoot "skills"

Assert-PathExists -Path $sourceAgentsFile -Label "Source AGENTS.md"
Assert-PathExists -Path $sourceAgentsDir -Label "Source agents directory"
Assert-PathExists -Path $sourceSkillsDir -Label "Source skills directory"

$sourceRoleFiles = @(Get-ChildItem -LiteralPath $sourceAgentsDir -Filter *.toml -File | Sort-Object Name)
$excludedSkillNames = @()
if ($PSBoundParameters.ContainsKey("ExcludeSkillNames")) {
    $excludedSkillNames = @($ExcludeSkillNames | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
} elseif (Test-ConfigKey -Config $config -Name "excludeSkillNames") {
    $excludedSkillNames = @($config.excludeSkillNames | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } | ForEach-Object { [string]$_ })
} else {
    $excludedSkillNames = $defaultExcludeSkillNames
}

$includeSystemSkillsValue = $false
if ($PSBoundParameters.ContainsKey("IncludeSystemSkills")) {
    $includeSystemSkillsValue = $true
} elseif (Test-ConfigKey -Config $config -Name "includeSystemSkills") {
    $includeSystemSkillsValue = [bool]$config.includeSystemSkills
}

$sourceSkillDirs = @(Get-ChildItem -LiteralPath $sourceSkillsDir -Directory | Where-Object {
    $includeSystemSkillsValue -or $_.Name -notin $excludedSkillNames
} | Sort-Object Name)

$publishedRoleFiles = @()
if (Test-Path -LiteralPath $publishedAgentsDir) {
    $publishedRoleFiles = @(Get-ChildItem -LiteralPath $publishedAgentsDir -Filter *.toml -File | Sort-Object Name)
}

$publishedSkillDirs = @()
if (Test-Path -LiteralPath $publishedSkillsDir) {
    $publishedSkillDirs = @(Get-ChildItem -LiteralPath $publishedSkillsDir -Directory | Sort-Object Name)
}

$repoOnlyRoles = @(Compare-Object -ReferenceObject $sourceRoleFiles.Name -DifferenceObject $publishedRoleFiles.Name |
    Where-Object { $_.SideIndicator -eq "=>" } |
    Select-Object -ExpandProperty InputObject)

$repoOnlySkills = @(Compare-Object -ReferenceObject $sourceSkillDirs.Name -DifferenceObject $publishedSkillDirs.Name |
    Where-Object { $_.SideIndicator -eq "=>" } |
    Select-Object -ExpandProperty InputObject)

$plan = [PSCustomObject]@{
    repo_root = $resolvedRepoRoot
    config_path = $resolvedConfigPath
    codex_root = $resolvedCodexRoot
    published_codex_dir = $resolvedPublishedCodexDir
    published_agents_dir = $publishedAgentsDir
    published_skills_dir = $publishedSkillsDir
    include_system_skills = [bool]$includeSystemSkillsValue
    excluded_skill_names = $excludedSkillNames
    source_roles = Get-NameArrayOrEmpty -Items $sourceRoleFiles.Name
    source_skills = Get-NameArrayOrEmpty -Items $sourceSkillDirs.Name
    repo_only_published_roles = Get-NameArrayOrEmpty -Items $repoOnlyRoles
    repo_only_published_skills = Get-NameArrayOrEmpty -Items $repoOnlySkills
    generated_at_utc = [DateTime]::UtcNow.ToString("o")
}

if ($PlanOnly) {
    if ($AsJson) {
        $plan | ConvertTo-Json -Depth 6
    } else {
        $plan | Format-List | Out-String
    }
    return
}

Ensure-Directory -Path $tmpRoot
Ensure-Directory -Path $syncTmpRoot
Ensure-Directory -Path $resolvedPublishedCodexDir
Ensure-Directory -Path $publishedAgentsDir
Ensure-Directory -Path $publishedSkillsDir

$publishedAgentsFile = Join-Path $resolvedPublishedCodexDir "AGENTS.md"
if ($PSCmdlet.ShouldProcess($publishedAgentsFile, "Copy $sourceAgentsFile")) {
    Copy-Item -LiteralPath $sourceAgentsFile -Destination $publishedAgentsFile -Force
}

foreach ($roleFile in $sourceRoleFiles) {
    $destinationRolePath = Join-Path $publishedAgentsDir $roleFile.Name
    if ($PSCmdlet.ShouldProcess($destinationRolePath, "Copy $($roleFile.FullName)")) {
        Copy-Item -LiteralPath $roleFile.FullName -Destination $destinationRolePath -Force
    }
}

foreach ($skillDir in $sourceSkillDirs) {
    $destinationSkillDir = Join-Path $publishedSkillsDir $skillDir.Name
    Copy-DirectoryContents -SourceDirectory $skillDir.FullName -DestinationDirectory $destinationSkillDir
}

$reportPath = Join-Path $syncTmpRoot "last-sync-report.json"
$plan | ConvertTo-Json -Depth 6 | Out-File -FilePath $reportPath -Encoding utf8

if ($AsJson) {
    [PSCustomObject]@{
        status = "ok"
        report_path = $reportPath
        repo_only_published_roles = Get-NameArrayOrEmpty -Items $repoOnlyRoles
        repo_only_published_skills = Get-NameArrayOrEmpty -Items $repoOnlySkills
    } | ConvertTo-Json -Depth 4
    return
}

Write-Output "Synced public Codex snapshot."
Write-Output "Repo root: $resolvedRepoRoot"
Write-Output "Published Codex dir: $resolvedPublishedCodexDir"
Write-Output "Report: $reportPath"
if ($repoOnlyRoles.Count -gt 0) {
    Write-Output "Repo-only published role files kept in repo: $($repoOnlyRoles -join ', ')"
}
if ($repoOnlySkills.Count -gt 0) {
    Write-Output "Repo-only published skill directories kept in repo: $($repoOnlySkills -join ', ')"
}

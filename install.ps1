<#
claude-code-boris-workflow - Windows installer
Installs Boris workflow files for Claude Code, Codex and OpenCode with conflict detection.
#>

[CmdletBinding()]
param(
    [switch]$All,
    [switch]$Claude,
    [switch]$Codex,
    [switch]$OpenCode,
    [switch]$Help
)

$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/W4k4s/claude-code-boris-workflow.git"
$HomeDir = [Environment]::GetFolderPath("UserProfile")

$ClaudeDest = if ($env:CLAUDE_HOME) { $env:CLAUDE_HOME } else { Join-Path $HomeDir ".claude" }
$ClaudeSkillsDest = if ($env:CLAUDE_SKILLS_HOME) { $env:CLAUDE_SKILLS_HOME } else { Join-Path $ClaudeDest "skills" }
$CodexDest = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HomeDir ".codex" }
$CodexSkillsDest = if ($env:CODEX_SKILLS_HOME) { $env:CODEX_SKILLS_HOME } else { Join-Path (Join-Path $HomeDir ".agents") "skills" }
$OpenCodeDest = if ($env:OPENCODE_CONFIG_DIR) { $env:OPENCODE_CONFIG_DIR } else { Join-Path (Join-Path $HomeDir ".config") "opencode" }

function Show-Usage {
    @"
Usage: .\install.ps1 [-All] [-Claude] [-Codex] [-OpenCode]

Options:
  -All       Install Claude Code, Codex and OpenCode workflow files (default)
  -Claude    Install only Claude Code files under %USERPROFILE%\.claude
  -Codex     Install only Codex files under %USERPROFILE%\.codex and %USERPROFILE%\.agents\skills
  -OpenCode  Install only OpenCode files under %USERPROFILE%\.config\opencode
  -Help      Show this help

Environment overrides:
  CLAUDE_HOME, CLAUDE_SKILLS_HOME, CODEX_HOME, CODEX_SKILLS_HOME, OPENCODE_CONFIG_DIR, BORIS_WORKFLOW_SRC
"@
}

if ($Help) {
    Show-Usage
    exit 0
}

if (-not ($All -or $Claude -or $Codex -or $OpenCode)) {
    $All = $true
}

if ($All) {
    $Claude = $true
    $Codex = $true
    $OpenCode = $true
}

Write-Host "claude-code-boris-workflow Windows installer"
Write-Host "Claude Code:  $ClaudeDest"
Write-Host "Claude skills: $ClaudeSkillsDest"
Write-Host "Codex:        $CodexDest"
Write-Host "Codex skills: $CodexSkillsDest"
Write-Host "OpenCode:     $OpenCodeDest"
Write-Host ""

$Tmp = Join-Path ([IO.Path]::GetTempPath()) ("boris-workflow-" + [guid]::NewGuid().ToString())
[IO.Directory]::CreateDirectory($Tmp) | Out-Null

function Show-Diff {
    param(
        [Parameter(Mandatory=$true)][string]$CurrentFile,
        [Parameter(Mandatory=$true)][string]$IncomingFile
    )

    if (Get-Command git -ErrorAction SilentlyContinue) {
        git diff --no-index -- $CurrentFile $IncomingFile 2>$null
        if ($LASTEXITCODE -gt 1) {
            Write-Host "  No se pudo mostrar diff con git."
        }
    }
    else {
        Write-Host "  Git no esta disponible para mostrar diff."
        Write-Host "  Actual:  $CurrentFile"
        Write-Host "  Entrante: $IncomingFile"
    }
}

function Test-SameFile {
    param(
        [Parameter(Mandatory=$true)][string]$Left,
        [Parameter(Mandatory=$true)][string]$Right
    )

    $leftHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Left).Hash
    $rightHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Right).Hash
    return $leftHash -eq $rightHash
}

function Copy-TemplateOnly {
    param(
        [Parameter(Mandatory=$true)][string]$SrcFile,
        [Parameter(Mandatory=$true)][string]$DestFile,
        [Parameter(Mandatory=$true)][string]$Label
    )

    $destDir = Split-Path -Parent $DestFile
    [IO.Directory]::CreateDirectory($destDir) | Out-Null

    if (-not (Test-Path -LiteralPath $DestFile)) {
        Copy-Item -LiteralPath $SrcFile -Destination $DestFile
        Write-Host "  + instalado: $Label"
        return
    }

    if (Test-SameFile -Left $SrcFile -Right $DestFile) {
        Write-Host "  = ya al dia: $Label"
        return
    }

    Write-Host "  ! ya existe: $Label. No lo toco."
    Write-Host "  Diff (actual -> template):"
    Show-Diff -CurrentFile $DestFile -IncomingFile $SrcFile
    Write-Host "  -> copia manualmente las secciones que te falten."
}

function Copy-One {
    param(
        [Parameter(Mandatory=$true)][string]$SrcFile,
        [Parameter(Mandatory=$true)][string]$DestFile,
        [Parameter(Mandatory=$true)][string]$Label
    )

    $destDir = Split-Path -Parent $DestFile
    [IO.Directory]::CreateDirectory($destDir) | Out-Null

    if (-not (Test-Path -LiteralPath $DestFile)) {
        Copy-Item -LiteralPath $SrcFile -Destination $DestFile
        Write-Host "  + instalado: $Label"
        return
    }

    if (Test-SameFile -Left $SrcFile -Right $DestFile) {
        Write-Host "  = ya al dia: $Label"
        return
    }

    Write-Host ""
    Write-Host "CONFLICTO: $Label ya existe y es distinto."
    Write-Host "Diff (actual -> entrante):"
    Show-Diff -CurrentFile $DestFile -IncomingFile $SrcFile
    Write-Host ""
    $choice = Read-Host "[o]verwrite / [s]kip / [b]ackup (.bak) y sobreescribir"

    switch -Regex ($choice) {
        "^[oO]$" {
            Copy-Item -LiteralPath $SrcFile -Destination $DestFile -Force
            Write-Host "  ! sobrescrito: $Label"
        }
        "^[bB]$" {
            $backup = "$DestFile.$(Get-Date -Format 'yyyyMMdd-HHmmss').bak"
            Copy-Item -LiteralPath $DestFile -Destination $backup
            Copy-Item -LiteralPath $SrcFile -Destination $DestFile -Force
            Write-Host "  ! sobrescrito con backup: $Label ($backup guardado)"
        }
        default {
            Write-Host "  . saltado: $Label"
        }
    }
}

function Copy-TreeFiles {
    param(
        [Parameter(Mandatory=$true)][string]$SrcDir,
        [Parameter(Mandatory=$true)][string]$DestDir,
        [Parameter(Mandatory=$true)][string]$LabelPrefix
    )

    [IO.Directory]::CreateDirectory($DestDir) | Out-Null
    Get-ChildItem -LiteralPath $SrcDir -File | ForEach-Object {
        Copy-One -SrcFile $_.FullName -DestFile (Join-Path $DestDir $_.Name) -Label ("$LabelPrefix/$($_.Name)")
    }
}

function Copy-TreeRecursiveFiles {
    param(
        [Parameter(Mandatory=$true)][string]$SrcDir,
        [Parameter(Mandatory=$true)][string]$DestDir,
        [Parameter(Mandatory=$true)][string]$LabelPrefix
    )

    [IO.Directory]::CreateDirectory($DestDir) | Out-Null
    $resolved = Resolve-Path -LiteralPath $SrcDir
    $base = $resolved.ProviderPath.TrimEnd([char[]]@([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar))

    Get-ChildItem -LiteralPath $SrcDir -File -Recurse | ForEach-Object {
        $relative = $_.FullName.Substring($base.Length).TrimStart([char[]]@([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar))
        $labelRelative = $relative -replace '\\', '/'
        Copy-One -SrcFile $_.FullName -DestFile (Join-Path $DestDir $relative) -Label ("$LabelPrefix/$labelRelative")
    }
}

function Copy-SkillDir {
    param(
        [Parameter(Mandatory=$true)][string]$SrcDir,
        [Parameter(Mandatory=$true)][string]$DestDir,
        [Parameter(Mandatory=$true)][string]$Label
    )

    Copy-TreeRecursiveFiles -SrcDir $SrcDir -DestDir $DestDir -LabelPrefix $Label
}

function Cleanup-LegacyClaudeCommands {
    $cmdDir = Join-Path $ClaudeDest "commands"
    if (-not (Test-Path -LiteralPath $cmdDir)) { return }

    Write-Host ""
    Write-Host "Limpieza de comandos legacy de Claude"
    Get-ChildItem -LiteralPath (Join-Path $script:Src "skills") -Directory | ForEach-Object {
        $slug = $_.Name
        $legacy = Join-Path $cmdDir "$slug.md"
        if (Test-Path -LiteralPath $legacy) {
            $bak = "$legacy.$(Get-Date -Format 'yyyyMMdd-HHmmss').bak"
            Move-Item -LiteralPath $legacy -Destination $bak -Force
            Write-Host "  - retirado comando legacy: ~/.claude/commands/$slug.md (ahora skill) -> $bak"
        }
    }
}

function Install-ClaudeFiles {
    [IO.Directory]::CreateDirectory((Join-Path $ClaudeDest "agents")) | Out-Null
    [IO.Directory]::CreateDirectory($ClaudeSkillsDest) | Out-Null

    Write-Host ""
    Write-Host "Claude Code agents"
    Copy-TreeFiles -SrcDir (Join-Path $script:Src "agents") -DestDir (Join-Path $ClaudeDest "agents") -LabelPrefix "~/.claude/agents"

    Write-Host ""
    Write-Host "Claude Code skills"
    Get-ChildItem -LiteralPath (Join-Path $script:Src "skills") -Directory | ForEach-Object {
        Copy-SkillDir -SrcDir $_.FullName -DestDir (Join-Path $ClaudeSkillsDest $_.Name) -Label "~/.claude/skills/$($_.Name)"
    }

    Cleanup-LegacyClaudeCommands

    Write-Host ""
    Write-Host "CLAUDE.md global"
    Copy-TemplateOnly -SrcFile (Join-Path $script:Src "CLAUDE.md") -DestFile (Join-Path $ClaudeDest "CLAUDE.md") -Label "~/.claude/CLAUDE.md"

    Write-Host ""
    Write-Host "settings.json global"
    Copy-TemplateOnly -SrcFile (Join-Path $script:Src "settings.json") -DestFile (Join-Path $ClaudeDest "settings.json") -Label "~/.claude/settings.json"
}

function Install-CodexFiles {
    [IO.Directory]::CreateDirectory((Join-Path $CodexDest "agents")) | Out-Null
    [IO.Directory]::CreateDirectory((Join-Path $CodexDest "rules")) | Out-Null
    [IO.Directory]::CreateDirectory($CodexSkillsDest) | Out-Null

    Write-Host ""
    Write-Host "Codex agents"
    Copy-TreeFiles -SrcDir (Join-Path (Join-Path $script:Src "codex") "agents") -DestDir (Join-Path $CodexDest "agents") -LabelPrefix "~/.codex/agents"

    Write-Host ""
    Write-Host "Codex skills"
    Get-ChildItem -LiteralPath (Join-Path (Join-Path $script:Src "codex") "skills") -Directory | ForEach-Object {
        Copy-SkillDir -SrcDir $_.FullName -DestDir (Join-Path $CodexSkillsDest $_.Name) -Label "~/.agents/skills/$($_.Name)"
    }

    Write-Host ""
    Write-Host "Codex rules"
    Copy-TreeFiles -SrcDir (Join-Path (Join-Path $script:Src "codex") "rules") -DestDir (Join-Path $CodexDest "rules") -LabelPrefix "~/.codex/rules"

    Write-Host ""
    Write-Host "Codex AGENTS.md global"
    Copy-TemplateOnly -SrcFile (Join-Path (Join-Path $script:Src "codex") "AGENTS.md") -DestFile (Join-Path $CodexDest "AGENTS.md") -Label "~/.codex/AGENTS.md"
}

function Install-OpenCodeFiles {
    [IO.Directory]::CreateDirectory((Join-Path $OpenCodeDest "agents")) | Out-Null
    [IO.Directory]::CreateDirectory((Join-Path $OpenCodeDest "commands")) | Out-Null

    Write-Host ""
    Write-Host "OpenCode agents"
    Copy-TreeFiles -SrcDir (Join-Path (Join-Path $script:Src "opencode") "agents") -DestDir (Join-Path $OpenCodeDest "agents") -LabelPrefix "~/.config/opencode/agents"

    Write-Host ""
    Write-Host "OpenCode commands"
    Copy-TreeFiles -SrcDir (Join-Path (Join-Path $script:Src "opencode") "commands") -DestDir (Join-Path $OpenCodeDest "commands") -LabelPrefix "~/.config/opencode/commands"

    Write-Host ""
    Write-Host "OpenCode config"
    Copy-TemplateOnly -SrcFile (Join-Path (Join-Path $script:Src "opencode") "opencode.json") -DestFile (Join-Path $OpenCodeDest "opencode.json") -Label "~/.config/opencode/opencode.json"

    Write-Host ""
    Write-Host "OpenCode AGENTS.md global"
    Copy-TemplateOnly -SrcFile (Join-Path (Join-Path $script:Src "opencode") "AGENTS.md") -DestFile (Join-Path $OpenCodeDest "AGENTS.md") -Label "~/.config/opencode/AGENTS.md"
}

try {
    if ($env:BORIS_WORKFLOW_SRC) {
        Write-Host "Usando repo local en $env:BORIS_WORKFLOW_SRC..."
        $script:Src = Join-Path $env:BORIS_WORKFLOW_SRC "global"
    }
    else {
        $localSrc = Join-Path $PSScriptRoot "global"
        if (Test-Path -LiteralPath $localSrc) {
            Write-Host "Usando repo local en $PSScriptRoot..."
            $script:Src = $localSrc
        }
        else {
            if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
                throw "Git no esta disponible. Instala Git for Windows o ejecuta con BORIS_WORKFLOW_SRC apuntando a un checkout local."
            }
            Write-Host "Clonando repo en $Tmp..."
            git clone --depth=1 $RepoUrl (Join-Path $Tmp "boris-workflow") | Out-Null
            if ($LASTEXITCODE -ne 0) {
                throw "No se pudo clonar $RepoUrl"
            }
            $script:Src = Join-Path (Join-Path $Tmp "boris-workflow") "global"
        }
    }

    if (-not (Test-Path -LiteralPath $script:Src)) {
        throw "No encuentro global/ en $script:Src"
    }

    if ($Claude) { Install-ClaudeFiles }
    if ($Codex) { Install-CodexFiles }
    if ($OpenCode) { Install-OpenCodeFiles }

    Write-Host ""
    Write-Host "Listo."
    Write-Host "Siguiente paso: abre la herramienta instalada y prueba un flujo de planificacion."
}
finally {
    Remove-Item -LiteralPath $Tmp -Recurse -Force -ErrorAction SilentlyContinue
}

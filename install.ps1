param(
    [string]$InstallDir = "$env:USERPROFILE\.agents",
    [string]$RepoUrl = "https://github.com/senorbeast/agent-skills.git",
    [string]$Branch = "main",
    [switch]$NoAgentsMd
)

$ErrorActionPreference = "Stop"

# Clone or pull the repo
if (Test-Path "$InstallDir\.git") {
    Write-Host "Updating $InstallDir"
    git -C "$InstallDir" fetch origin $Branch
    git -C "$InstallDir" checkout $Branch
    git -C "$InstallDir" pull --ff-only origin $Branch
} elseif (Test-Path "$InstallDir") {
    Write-Error "Refusing to clone into existing non-git path: $InstallDir. Move it aside or use a different directory."
} else {
    Write-Host "Cloning $RepoUrl into $InstallDir"
    git clone --branch $Branch $RepoUrl $InstallDir
}

# Sync global guidance
if (-not $NoAgentsMd) {
    # 1. Antigravity / Gemini Configuration
    $GeminiConfigDir = "$env:USERPROFILE\.gemini\config"
    if (-not (Test-Path $GeminiConfigDir)) {
        New-Item -ItemType Directory -Path $GeminiConfigDir -Force | Out-Null
    }

    $SourceAgents = "$InstallDir\AGENTS.md"
    $TargetAgents = "$GeminiConfigDir\AGENTS.md"
    
    if (Test-Path $SourceAgents) {
        Write-Host "Setting up Antigravity/Gemini AGENTS.md..."
        # Due to symlink restrictions on Windows, we copy the file instead.
        if (Test-Path $TargetAgents) {
            $Timestamp = Get-Date -Format "yyyyMMddHHmmss"
            $Backup = "$TargetAgents.backup.$Timestamp"
            Write-Host "Backing up existing $TargetAgents to $Backup"
            Rename-Item -Path $TargetAgents -NewName (Split-Path $Backup -Leaf)
        }
        Copy-Item -Path $SourceAgents -Destination $TargetAgents -Force
        Write-Host "Copied: $SourceAgents -> $TargetAgents"
    }

    # Generate skills.json for Antigravity so it auto-discovers skills
    $SkillsJsonPath = "$GeminiConfigDir\skills.json"
    $SkillsDir = "$InstallDir\skills"
    
    if (Test-Path $SkillsDir) {
        # Use forward slashes to avoid JSON escaping nightmares in PowerShell
        $ForwardSlashSkillsDir = $SkillsDir -replace '\\', '/'
        
        $SkillsJsonContent = @{
            entries = @(
                @{ path = $ForwardSlashSkillsDir }
            )
        } | ConvertTo-Json -Depth 3
        
        Set-Content -Path $SkillsJsonPath -Value $SkillsJsonContent -Encoding UTF8
        Write-Host "Created Antigravity skills.json at $SkillsJsonPath pointing to $SkillsDir"
    }

    # 2. Codex Configuration (Legacy Windows)
    $CodexDir = "$env:USERPROFILE\.codex"
    if (-not (Test-Path $CodexDir)) {
        New-Item -ItemType Directory -Path $CodexDir -Force | Out-Null
    }
    
    $CodexTargetAgents = "$CodexDir\AGENTS.md"
    if (Test-Path $SourceAgents) {
        Write-Host "Setting up Codex AGENTS.md..."
        if (Test-Path $CodexTargetAgents) {
            $Timestamp = Get-Date -Format "yyyyMMddHHmmss"
            $Backup = "$CodexTargetAgents.backup.$Timestamp"
            Write-Host "Backing up existing $CodexTargetAgents to $Backup"
            Rename-Item -Path $CodexTargetAgents -NewName (Split-Path $Backup -Leaf)
        }
        Copy-Item -Path $SourceAgents -Destination $CodexTargetAgents -Force
        Write-Host "Copied: $SourceAgents -> $CodexTargetAgents"
    }
}

Write-Host "Agent skills setup complete on Windows."
Write-Host "Use 'npx skills@latest' to install/update skills and create agent symlinks."

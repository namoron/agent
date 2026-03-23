param(
    [ValidateSet('sessionStart', 'userPromptSubmitted', 'postToolUse', 'errorOccurred', 'sessionEnd')]
    [string]$Mode,
    [string]$JsonInput = ''
)

Set-StrictMode -Version Latest

function Read-HookInput {
    param([string]$Raw)

    $payload = if ([string]::IsNullOrWhiteSpace($Raw)) {
        [Console]::In.ReadToEnd()
    } else {
        $Raw
    }

    if ([string]::IsNullOrWhiteSpace($payload)) {
        return @{}
    }

    return $payload | ConvertFrom-Json -Depth 20
}

function Ensure-Directory {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Write-JsonLine {
    param(
        [string]$Path,
        [object]$Value
    )

    $json = $Value | ConvertTo-Json -Depth 20 -Compress
    Add-Content -Path $Path -Value $json -Encoding utf8
}

function Shorten-Text {
    param(
        [string]$Text,
        [int]$Limit = 96
    )

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return ''
    }

    $singleLine = ($Text -replace '\s+', ' ').Trim()
    if ($singleLine.Length -le $Limit) {
        return $singleLine
    }

    return $singleLine.Substring(0, $Limit - 3).TrimEnd() + '...'
}

function Convert-ToSlug {
    param([string]$Text)

    $value = if ([string]::IsNullOrWhiteSpace($Text)) { 'session' } else { $Text.ToLowerInvariant() }
    $value = $value -replace '[^a-z0-9]+', '-'
    $value = $value.Trim('-')
    if ([string]::IsNullOrWhiteSpace($value)) {
        return 'session'
    }

    return $value
}

function Get-LearningRecommendation {
    param([string]$Text)

    $combined = ($Text ?? '').ToLowerInvariant()

    if ($combined -match 'pytest|test|coverage|ruff|black|isort|mypy|bandit|lint|typecheck') {
        return @{
            category = 'verification'
            suggestedSkill = 'verification-loop'
            summary = 'Python changes repeatedly touched validation commands or test signals. This session is a good candidate for a reusable verification loop.'
        }
    }

    if ($combined -match 'worktree|parallel|orchestr|subagent|fleet') {
        return @{
            category = 'orchestration'
            suggestedSkill = 'parallel-worktrees'
            summary = 'The session referenced orchestration or parallel execution. Capture the branching, worktree, and merge pattern as a reusable workflow.'
        }
    }

    if ($combined -match 'review|regression|security|bug') {
        return @{
            category = 'review'
            suggestedSkill = 'python-review'
            summary = 'The session centered on review, regression control, or security checks. This may be reusable as a Python review checklist.'
        }
    }

    if ($combined -match 'refactor|pattern|architecture|service|protocol|dataclass|boundary') {
        return @{
            category = 'patterns'
            suggestedSkill = 'python-patterns'
            summary = 'The session contained structure or architecture decisions that may be worth curating as a Python pattern.'
        }
    }

    return @{
        category = 'implementation'
        suggestedSkill = 'python-tdd'
        summary = 'The session looks like general implementation work. Review whether any test-first workflow or local convention should be promoted into a skill.'
    }
}

function Format-LearningCandidateMarkdown {
    param([hashtable]$Candidate)

    $tools = if ($Candidate.toolsUsed.Count) { ($Candidate.toolsUsed -join ', ') } else { 'none' }
    $errors = if ($Candidate.errors.Count) { ($Candidate.errors -join '; ') } else { 'none' }
    $prompts = if ($Candidate.promptSamples.Count) { ($Candidate.promptSamples | ForEach-Object { "- $_" }) -join "`n" } else { '- none captured' }

    return @"
# Learning Candidate

- Captured at: $($Candidate.capturedAt)
- Category: $($Candidate.category)
- Suggested skill: $($Candidate.suggestedSkill)
- Session end reason: $($Candidate.reason)
- Prompt count: $($Candidate.promptCount)
- Tool count: $($Candidate.toolCount)

## Summary

$($Candidate.summary)

## Evidence

- Last prompt: $($Candidate.lastPrompt)
- Tools used: $tools
- Errors: $errors

## Prompt Samples

$prompts
"@
}

$inputData = Read-HookInput -Raw $JsonInput
$cwd = if ($null -ne $inputData.cwd -and -not [string]::IsNullOrWhiteSpace([string]$inputData.cwd)) {
    [string]$inputData.cwd
} else {
    (Get-Location).Path
}

$stateRoot = Join-Path $cwd '.git\copilot-memory'
$sessionsRoot = Join-Path $stateRoot 'sessions'
$currentSessionPath = Join-Path $stateRoot 'current-session.jsonl'
$learningCandidatesPath = Join-Path $stateRoot 'learning-candidates.jsonl'
$latestCandidatePath = Join-Path $stateRoot 'latest-learning-candidate.md'

Ensure-Directory -Path $stateRoot
Ensure-Directory -Path $sessionsRoot

switch ($Mode) {
    'sessionStart' {
        $source = [string]$inputData.source
        if ($source -ne 'resume' -or -not (Test-Path -LiteralPath $currentSessionPath)) {
            if (Test-Path -LiteralPath $currentSessionPath) {
                Remove-Item -LiteralPath $currentSessionPath -Force
            }
        }

        Write-JsonLine -Path $currentSessionPath -Value @{
            eventType = 'sessionStart'
            timestamp = $inputData.timestamp
            cwd = $cwd
            source = $source
            initialPrompt = [string]$inputData.initialPrompt
        }
    }
    'userPromptSubmitted' {
        if (-not (Test-Path -LiteralPath $currentSessionPath)) {
            New-Item -ItemType File -Path $currentSessionPath -Force | Out-Null
        }

        Write-JsonLine -Path $currentSessionPath -Value @{
            eventType = 'userPromptSubmitted'
            timestamp = $inputData.timestamp
            cwd = $cwd
            prompt = [string]$inputData.prompt
        }
    }
    'postToolUse' {
        if (-not (Test-Path -LiteralPath $currentSessionPath)) {
            New-Item -ItemType File -Path $currentSessionPath -Force | Out-Null
        }

        Write-JsonLine -Path $currentSessionPath -Value @{
            eventType = 'postToolUse'
            timestamp = $inputData.timestamp
            cwd = $cwd
            toolName = [string]$inputData.toolName
            toolArgs = [string]$inputData.toolArgs
            resultType = [string]$inputData.toolResult.resultType
            resultText = [string]$inputData.toolResult.textResultForLlm
        }
    }
    'errorOccurred' {
        if (-not (Test-Path -LiteralPath $currentSessionPath)) {
            New-Item -ItemType File -Path $currentSessionPath -Force | Out-Null
        }

        Write-JsonLine -Path $currentSessionPath -Value @{
            eventType = 'errorOccurred'
            timestamp = $inputData.timestamp
            cwd = $cwd
            errorName = [string]$inputData.error.name
            errorMessage = [string]$inputData.error.message
        }
    }
    'sessionEnd' {
        if (-not (Test-Path -LiteralPath $currentSessionPath)) {
            return
        }

        Write-JsonLine -Path $currentSessionPath -Value @{
            eventType = 'sessionEnd'
            timestamp = $inputData.timestamp
            cwd = $cwd
            reason = [string]$inputData.reason
        }

        $events = @()
        foreach ($line in Get-Content -LiteralPath $currentSessionPath) {
            if (-not [string]::IsNullOrWhiteSpace($line)) {
                $events += ($line | ConvertFrom-Json -Depth 20)
            }
        }

        $prompts = New-Object System.Collections.Generic.List[string]
        foreach ($event in $events) {
            if ($event.eventType -eq 'sessionStart' -and -not [string]::IsNullOrWhiteSpace([string]$event.initialPrompt)) {
                $prompts.Add([string]$event.initialPrompt)
            }
            if ($event.eventType -eq 'userPromptSubmitted' -and -not [string]::IsNullOrWhiteSpace([string]$event.prompt)) {
                $prompts.Add([string]$event.prompt)
            }
        }

        $postToolEvents = @($events | Where-Object { $_.eventType -eq 'postToolUse' })
        $toolsUsed = @($postToolEvents | ForEach-Object { [string]$_.toolName } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique)
        $errors = @($events | Where-Object { $_.eventType -eq 'errorOccurred' } | ForEach-Object {
            $name = [string]$_.errorName
            $message = [string]$_.errorMessage
            if ([string]::IsNullOrWhiteSpace($name)) {
                Shorten-Text -Text $message -Limit 80
            } else {
                Shorten-Text -Text ("{0}: {1}" -f $name, $message) -Limit 80
            }
        })

        $textForClassification = @(
            ($prompts -join "`n"),
            ($postToolEvents | ForEach-Object { "$($_.toolName) $($_.toolArgs) $($_.resultText)" } | Out-String)
        ) -join "`n"
        $recommendation = Get-LearningRecommendation -Text $textForClassification

        $lastPrompt = if ($prompts.Count) { Shorten-Text -Text $prompts[$prompts.Count - 1] -Limit 120 } else { 'No prompt captured' }
        $capturedAt = if ($null -ne $inputData.timestamp) {
            [DateTimeOffset]::FromUnixTimeMilliseconds([int64]$inputData.timestamp).ToString('o')
        } else {
            (Get-Date).ToString('o')
        }

        $candidate = [ordered]@{
            capturedAt = $capturedAt
            cwd = $cwd
            reason = [string]$inputData.reason
            category = $recommendation.category
            suggestedSkill = $recommendation.suggestedSkill
            summary = $recommendation.summary
            lastPrompt = $lastPrompt
            promptCount = $prompts.Count
            promptSamples = @($prompts | Select-Object -Last 3 | ForEach-Object { Shorten-Text -Text $_ -Limit 120 })
            toolCount = $postToolEvents.Count
            toolsUsed = $toolsUsed
            errors = $errors
        }

        Write-JsonLine -Path $learningCandidatesPath -Value $candidate
        Set-Content -LiteralPath $latestCandidatePath -Value (Format-LearningCandidateMarkdown -Candidate $candidate) -Encoding utf8

        $archiveName = 'session-{0}-{1}.jsonl' -f (
            [DateTimeOffset]::FromUnixTimeMilliseconds([int64]$inputData.timestamp).ToString('yyyyMMdd-HHmmss')
        ), (Convert-ToSlug -Text ([string]$inputData.reason))
        Copy-Item -LiteralPath $currentSessionPath -Destination (Join-Path $sessionsRoot $archiveName) -Force
        Remove-Item -LiteralPath $currentSessionPath -Force
    }
}

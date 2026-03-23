param(
    [string]$JsonInput = ''
)

$inputJson = if ([string]::IsNullOrWhiteSpace($JsonInput)) {
    [Console]::In.ReadToEnd()
} else {
    $JsonInput
}
$normalized = $inputJson.ToLowerInvariant()

$patterns = @(
    'git reset --hard',
    'git clean -fd',
    'git clean -fdx',
    'git push.*--force',
    'rm -rf /',
    'rm -rf \*',
    'remove-item.*-recurse.*-force',
    'del /f /s /q',
    'format c:',
    'mkfs',
    'drop table',
    'drop database',
    'terraform destroy',
    'kubectl delete namespace'
)

foreach ($pattern in $patterns) {
    if ($normalized -match $pattern) {
        @{
            permissionDecision = 'deny'
            permissionDecisionReason = 'Blocked by repository policy: destructive or forceful command requires explicit human approval.'
        } | ConvertTo-Json -Compress
        exit 0
    }
}

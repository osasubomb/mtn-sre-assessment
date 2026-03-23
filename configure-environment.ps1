# configure-environment.ps1
# Usage:
#   cd \path\to\sre-assessment
#   .\configure-environment.ps1
# This reads deployment-config.env and applies values to key YAML templates.

$envFile = "deployment-config.env"
if (-not (Test-Path $envFile)) {
    Write-Error "Missing $envFile. Please create it from template and set values."
    exit 1
}

# Import env file into variables
Get-Content $envFile | ForEach-Object {
    $_ = $_.Trim()
    if ([string]::IsNullOrWhiteSpace($_) -or $_.StartsWith("#")) { return }
    if ($_ -match "^([^=]+)=(.*)$") {
        $key = $matches[1].Trim()
        $val = $matches[2].Trim().Trim('"')
        Set-Variable -Name $key -Value $val -Scope Global
    }
}

# Set defaults and canonical endpoint variable
if (-not $ELASTIC_APM_ENDPOINT -or [string]::IsNullOrWhiteSpace($ELASTIC_APM_ENDPOINT)) {
    if ($ELASTIC_APM_SERVER -and -not [string]::IsNullOrWhiteSpace($ELASTIC_APM_SERVER)) {
        $ELASTIC_APM_ENDPOINT = "${ELASTIC_APM_PROTOCOL:-https}://${ELASTIC_APM_SERVER}"
    } else {
        Write-Error "ELASTIC_APM_ENDPOINT or ELASTIC_APM_SERVER must be set in deployment-config.env"
        exit 1
    }
}

$filesToUpdate = @(
    "otel-collector/values-agent.yaml",
    "otel-collector/values-gateway.yaml",
    "infrastructure/elastic-agent-policies/fleet-policy-example.yml"
)

# Backup originals once
$filesToUpdate | ForEach-Object {
    $path = $_
    if ((Test-Path $path) -and -not (Test-Path "$path.bak")) {
        Copy-Item -Path $path -Destination "$path.bak"
    }
}

function Repl($text) {
    $r = $text.Replace("<ELASTIC_APM_ENDPOINT>", $ELASTIC_APM_ENDPOINT)
    $r = $r.Replace("<ELASTIC_APM_SERVER>", $ELASTIC_APM_SERVER)
    $r = $r.Replace("<ELASTIC_APM_TOKEN>", $ELASTIC_APM_TOKEN)
    $r = $r.Replace("<POSTGRES_HOST>", $POSTGRES_HOST)
    $r = $r.Replace("<REDIS_HOST>", $REDIS_HOST)
    return $r
}

$filesToUpdate | ForEach-Object {
    $path = $_
    if (-not (Test-Path $path)) {
        Write-Warning "File not found: $path"
        return
    }
    $content = Get-Content $path -Raw
    $updated = Repl $content
    Set-Content -Path $path -Value $updated
    Write-Host "Updated $path"
}

Write-Host "Configuration applied successfully."
Write-Host "Optional: run 'git diff' to review changes, then commit."

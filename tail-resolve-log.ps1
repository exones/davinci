# Simple PowerShell script to monitor DaVinci Resolve log file in real-time
# Uses Get-Content -Wait (equivalent to 'tail -f' on Unix systems)

param (
    [string]$LogFile = "C:\Users\exon\AppData\Roaming\Blackmagic Design\DaVinci Resolve\Support\logs\davinci_resolve.log",
    [int]$InitialLines = 20,
    [switch]$NoColor
)

# Function to colorize log output based on content
function Format-LogLine {
    param (
        [string]$Line
    )
    
    if ($NoColor) {
        Write-Host $Line
        return
    }
    
    # Color coding based on log level/content
    if ($Line -match "ERROR|FATAL|CRITICAL|Exception|failed|crash") {
        Write-Host $Line -ForegroundColor Red
    } elseif ($Line -match "WARNING|WARN") {
        Write-Host $Line -ForegroundColor Yellow
    } elseif ($Line -match "INFO") {
        Write-Host $Line -ForegroundColor Green
    } elseif ($Line -match "DEBUG") {
        Write-Host $Line -ForegroundColor Cyan
    } elseif ($Line -match "DCTL|CUDA|OpenCL|Metal") {
        Write-Host $Line -ForegroundColor Magenta
    } else {
        Write-Host $Line
    }
}

# Check if the log file exists
if (-not (Test-Path $LogFile)) {
    Write-Host "Error: Log file not found: $LogFile" -ForegroundColor Red
    Write-Host "Please check the path and try again."
    exit 1
}

# Display header
Write-Host "=== DaVinci Resolve Log Monitor ===" -ForegroundColor Cyan
Write-Host "Monitoring: $LogFile" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to exit" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

try {
    # Get the last N lines and then continue monitoring
    Get-Content -Path $LogFile -Tail $InitialLines -Wait | ForEach-Object {
        Format-LogLine $_
    }
} catch {
    Write-Host "`nMonitoring stopped: $_" -ForegroundColor Red
} finally {
    Write-Host "`nExiting log monitor." -ForegroundColor Cyan
} 
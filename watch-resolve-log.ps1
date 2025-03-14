# PowerShell script to monitor DaVinci Resolve log file in real-time
# Equivalent to 'tail -f' on Unix systems

param (
    [string]$LogFile = "C:\Users\exon\AppData\Roaming\Blackmagic Design\DaVinci Resolve\Support\logs\ResolveDebug.txt",
    [int]$InitialLines = 20,
    [switch]$NoColor,
    [switch]$Help
)

# Function to display usage information
function Show-Usage {
    Write-Host "Usage: .\watch-resolve-log.ps1 [options]" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -LogFile <path>      Path to the log file (default: $LogFile)"
    Write-Host "  -InitialLines <n>    Number of initial lines to display (default: 20)"
    Write-Host "  -NoColor             Disable colored output"
    Write-Host "  -Help                Display this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\watch-resolve-log.ps1"
    Write-Host "  .\watch-resolve-log.ps1 -InitialLines 50"
    Write-Host "  .\watch-resolve-log.ps1 -LogFile 'C:\path\to\different\log.log'"
    exit
}

# Check if help is requested
if ($Help) {
    Show-Usage
}

# Check if the log file exists
if (-not (Test-Path $LogFile)) {
    Write-Host "Error: Log file not found: $LogFile" -ForegroundColor Red
    Write-Host "Please check the path and try again."
    exit 1
}

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

# Display header
Write-Host "=== DaVinci Resolve Log Monitor ===" -ForegroundColor Cyan
Write-Host "Monitoring: $LogFile" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to exit" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

try {
    # This is the most efficient way to implement tail -f in PowerShell
    Get-Content -Path $LogFile -Tail $InitialLines -Wait | ForEach-Object {
        Format-LogLine $_
    }
} catch {
    Write-Host "`nMonitoring stopped: $_" -ForegroundColor Red
} finally {
    Write-Host "`nExiting log monitor." -ForegroundColor Cyan
} 
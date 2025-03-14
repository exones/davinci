# Advanced PowerShell script to monitor DaVinci Resolve log file with filtering capabilities
# Particularly useful for monitoring DCTL-related log entries
# Supports interactive keystroke commands while monitoring

param (
    [string]$LogFile = "C:\Users\exon\AppData\Roaming\Blackmagic Design\DaVinci Resolve\Support\logs\ResolveDebug.txt",
    [int]$InitialLines = 20,
    [string]$Filter = "",
    [switch]$DCTLOnly,
    [switch]$ErrorsOnly,
    [switch]$NoColor,
    [string]$DCTLFile = "grid.dctl",
    [switch]$Help
)

# Function to display usage information
function Show-Usage {
    Write-Host "Usage: .\monitor-dctl-logs.ps1 [options]" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -LogFile <path>      Path to the log file (default: $LogFile)"
    Write-Host "  -InitialLines <n>    Number of initial lines to display (default: 20)"
    Write-Host "  -Filter <pattern>    Only show lines matching this pattern"
    Write-Host "  -DCTLOnly            Only show DCTL-related entries"
    Write-Host "  -ErrorsOnly          Only show error messages"
    Write-Host "  -NoColor             Disable colored output"
    Write-Host "  -DCTLFile <path>     Path to DCTL file to copy with 'c' key (optional)"
    Write-Host "  -Help                Display this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\monitor-dctl-logs.ps1"
    Write-Host "  .\monitor-dctl-logs.ps1 -DCTLOnly"
    Write-Host "  .\monitor-dctl-logs.ps1 -Filter 'grid.dctl'"
    Write-Host "  .\monitor-dctl-logs.ps1 -ErrorsOnly -DCTLOnly -DCTLFile 'C:\code\DCTL\grid.dctl'"
    Write-Host ""
    Write-Host "Interactive Commands (while monitoring):"
    Write-Host "  c - Copy the specified DCTL file to DaVinci Resolve LUTs folder"
    Write-Host "  f - Toggle DCTL-only filter"
    Write-Host "  e - Toggle errors-only filter"
    Write-Host "  r - Reload/restart monitoring"
    Write-Host "  h - Show help"
    Write-Host "  q - Quit"
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

# Check if DCTL file exists if specified
if ($DCTLFile -and -not (Test-Path $DCTLFile)) {
    Write-Host "Warning: Specified DCTL file not found: $DCTLFile" -ForegroundColor Yellow
    Write-Host "The 'c' key command will not work until a valid file is specified."
    $DCTLFile = ""
}

# Define DaVinci Resolve LUTs folder
$resolveLUTFolder = "C:\ProgramData\Blackmagic Design\DaVinci Resolve\Support\LUT"

# Function to copy DCTL file to Resolve LUTs folder
function Copy-DCTLToResolve {
    param (
        [string]$SourceFile
    )
    
    if (-not $SourceFile) {
        Write-Host "`n[!] No DCTL file specified. Use -DCTLFile parameter when starting the script." -ForegroundColor Yellow
        return
    }
    
    if (-not (Test-Path $SourceFile)) {
        Write-Host "`n[!] DCTL file not found: $SourceFile" -ForegroundColor Red
        return
    }
    
    if (-not (Test-Path $resolveLUTFolder)) {
        Write-Host "`n[!] DaVinci Resolve LUT folder not found: $resolveLUTFolder" -ForegroundColor Red
        return
    }
    
    try {
        $fileName = Split-Path $SourceFile -Leaf
        Copy-Item -Path $SourceFile -Destination $resolveLUTFolder -Force
        Write-Host "`n[✓] Successfully copied $fileName to DaVinci Resolve LUTs folder" -ForegroundColor Green
        Write-Host "    The DCTL effect should now be available in DaVinci Resolve" -ForegroundColor Green
        Write-Host "    (You may need to reset the DCTL combo box in Resolve to see changes)" -ForegroundColor Green
    } catch {
        Write-Host "`n[!] Failed to copy DCTL file: $_" -ForegroundColor Red
    }
}

# Function to determine if a line should be displayed based on filters
function Should-DisplayLine {
    param (
        [string]$Line
    )
    
    # Apply DCTLOnly filter
    if ($DCTLOnly -and -not ($Line -match "DCTL|CUDA|OpenCL|Metal|shader")) {
        return $false
    }
    
    # Apply ErrorsOnly filter
    if ($ErrorsOnly -and -not ($Line -match "ERROR|FATAL|CRITICAL|Exception|failed|crash|error")) {
        return $false
    }
    
    # Apply custom filter
    if ($Filter -and -not ($Line -match $Filter)) {
        return $false
    }
    
    return $true
}

# Function to colorize log output based on content
function Format-LogLine {
    param (
        [string]$Line
    )
    
    # Check if line should be displayed based on filters
    if (-not (Should-DisplayLine -Line $Line)) {
        return
    }
    
    if ($NoColor) {
        Write-Host $Line
        return
    }
    
    # Color coding based on log level/content
    if ($Line -match "ERROR|FATAL|CRITICAL|Exception|failed|crash|error") {
        Write-Host $Line -ForegroundColor Red
    } elseif ($Line -match "WARNING|WARN") {
        Write-Host $Line -ForegroundColor Yellow
    } elseif ($Line -match "INFO") {
        Write-Host $Line -ForegroundColor Green
    } elseif ($Line -match "DEBUG") {
        Write-Host $Line -ForegroundColor Cyan
    } elseif ($Line -match "DCTL|CUDA|OpenCL|Metal|shader") {
        Write-Host $Line -ForegroundColor Magenta
    } else {
        Write-Host $Line
    }
}

# Function to display the current filter status
function Show-FilterStatus {
    $filterDescription = ""
    if ($DCTLOnly) { $filterDescription += "DCTL entries only, " }
    if ($ErrorsOnly) { $filterDescription += "Errors only, " }
    if ($Filter) { $filterDescription += "Pattern: '$Filter', " }
    if ($filterDescription) { 
        $filterDescription = "Filters: " + $filterDescription.TrimEnd(", ")
    } else {
        $filterDescription = "No filters applied"
    }
    
    Write-Host "`n=== Current Settings ===" -ForegroundColor Cyan
    Write-Host "Monitoring: $LogFile" -ForegroundColor Cyan
    Write-Host $filterDescription -ForegroundColor Cyan
    if ($DCTLFile) {
        Write-Host "DCTL File: $DCTLFile" -ForegroundColor Cyan
    }
    Write-Host "======================" -ForegroundColor Cyan
}

# Function to display help during monitoring
function Show-MonitoringHelp {
    Write-Host "`n=== Keyboard Commands ===" -ForegroundColor Cyan
    Write-Host "c - Copy the specified DCTL file to DaVinci Resolve LUTs folder"
    Write-Host "f - Toggle DCTL-only filter (currently: $($DCTLOnly ? 'ON' : 'OFF'))"
    Write-Host "e - Toggle errors-only filter (currently: $($ErrorsOnly ? 'ON' : 'OFF'))"
    Write-Host "r - Reload/restart monitoring"
    Write-Host "h - Show this help"
    Write-Host "q - Quit"
    Write-Host "======================" -ForegroundColor Cyan
}

# Function to start monitoring
function Start-Monitoring {
    # Display header
    Write-Host "`n=== DaVinci Resolve Log Monitor ===" -ForegroundColor Cyan
    Write-Host "Monitoring: $LogFile" -ForegroundColor Cyan
    Show-FilterStatus
    Write-Host "Press 'h' for help or 'q' to quit" -ForegroundColor Cyan
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Create a job to read the log file
    $job = Start-Job -ScriptBlock {
        param($logFile, $initialLines)
        Get-Content -Path $logFile -Tail $initialLines -Wait
    } -ArgumentList $LogFile, $InitialLines
    
    # Monitor for keystrokes while displaying log content
    try {
        while ($true) {
            # Check for new log content
            $jobOutput = Receive-Job -Job $job
            if ($jobOutput) {
                foreach ($line in $jobOutput) {
                    Format-LogLine $line
                }
            }
            
            # Check for keystrokes (non-blocking)
            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey($true)
                
                switch ($key.KeyChar) {
                    'c' {
                        Copy-DCTLToResolve -SourceFile $DCTLFile
                        break
                    }
                    'f' {
                        $DCTLOnly = -not $DCTLOnly
                        Write-Host "`n[i] DCTL-only filter toggled to: $($DCTLOnly ? 'ON' : 'OFF')" -ForegroundColor Cyan
                        break
                    }
                    'e' {
                        $ErrorsOnly = -not $ErrorsOnly
                        Write-Host "`n[i] Errors-only filter toggled to: $($ErrorsOnly ? 'ON' : 'OFF')" -ForegroundColor Cyan
                        break
                    }
                    'r' {
                        Write-Host "`n[i] Restarting monitoring..." -ForegroundColor Cyan
                        Remove-Job -Job $job -Force
                        return "restart"
                    }
                    'h' {
                        Show-MonitoringHelp
                        break
                    }
                    'q' {
                        Write-Host "`n[i] Exiting..." -ForegroundColor Cyan
                        return "quit"
                    }
                }
            }
            
            # Small sleep to prevent high CPU usage
            Start-Sleep -Milliseconds 100
        }
    } finally {
        # Clean up the job
        if ($job) {
            Remove-Job -Job $job -Force -ErrorAction SilentlyContinue
        }
    }
}

# Main execution loop
try {
    $action = "start"
    while ($action -ne "quit") {
        $action = Start-Monitoring
    }
} catch {
    Write-Host "`n[!] Monitoring stopped: $_" -ForegroundColor Red
} finally {
    Write-Host "`nExiting log monitor." -ForegroundColor Cyan
} 
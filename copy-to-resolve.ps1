# PowerShell script to copy the DCTL file to DaVinci Resolve LUTs folder
# This script copies grid.dctl to the standard DaVinci Resolve LUTs location

# Define source and destination paths
$sourceFile = Join-Path -Path $PSScriptRoot -ChildPath "grid.dctl"
$destinationFolder = "C:\ProgramData\Blackmagic Design\DaVinci Resolve\Support\LUT"

# Check if source file exists
if (-not (Test-Path $sourceFile)) {
    Write-Error "Source file not found: $sourceFile"
    exit 1
}

# Check if destination folder exists
if (-not (Test-Path $destinationFolder)) {
    Write-Error "Destination folder not found: $destinationFolder"
    Write-Host "Please make sure DaVinci Resolve is installed correctly."
    exit 1
}

# Copy the file
try {
    Copy-Item -Path $sourceFile -Destination $destinationFolder -Force
    Write-Host "Successfully copied grid.dctl to $destinationFolder" -ForegroundColor Green
    Write-Host "The DCTL effect should now be available in DaVinci Resolve."
} catch {
    Write-Error "Failed to copy file: $_"
    exit 1
}

# Provide instructions for using the DCTL
Write-Host "`nTo use this DCTL in DaVinci Resolve:" -ForegroundColor Cyan
Write-Host "1. Open DaVinci Resolve"
Write-Host "2. In the Color page, right-click on a node and select 'LUTs > grid'"
Write-Host "   OR"
Write-Host "3. Add the ResolveFX DCTL plugin and select 'grid' from the DCTL list" 
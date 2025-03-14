# DCTL Grid Effect

This repository contains a simple DCTL (DaVinci Color Transform Language) effect that draws a vertical white line in the middle of the frame.

## Files

- `grid.dctl` - The DCTL effect file that creates a vertical white line
- `copy-to-resolve.ps1` - PowerShell script to install the DCTL to DaVinci Resolve

## Installation

### Using PowerShell (Recommended)

1. Right-click on `copy-to-resolve.ps1` and select "Run with PowerShell"
2. If you get a security warning, you may need to run:
   ```
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
   ```
   Then run the script again.

### Using Batch File

1. Double-click on `copy-to-resolve.bat` to run it
2. You may need to run it as administrator if you encounter permission issues

### Manual Installation

Copy the `grid.dctl` file to:

```
C:\ProgramData\Blackmagic Design\DaVinci Resolve\Support\LUT
```

## Usage

After installation, you can use the DCTL effect in DaVinci Resolve in two ways:

1. In the Color page, right-click on a node and select "LUTs > grid"
2. Add the ResolveFX DCTL plugin and select "grid" from the DCTL list

## How It Works

The DCTL effect:

- Processes each pixel in the frame
- Identifies pixels that are on the vertical center line
- Changes those pixels to white
- Leaves all other pixels unchanged

## Customization

You can modify the `grid.dctl` file to change:

- The line color (change the RGB values in `make_float3()`)
- The line position (modify the `midX` calculation)
- The line width (change the condition to include pixels near the center)

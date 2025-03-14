# DCTL Effects Collection

A collection of custom DCTL (DaVinci Color Transform Language) effects for DaVinci Resolve.

## Overview

This repository contains a variety of DCTL effects that can be used in DaVinci Resolve to enhance your color grading and visual effects workflow. Each effect is designed to solve specific creative challenges and can be applied as either a LUT or through the ResolveFX DCTL plugin.

## Effects Included

### Grid Selector

A customizable grid overlay that displays only the content within a selected cell. Perfect for composition analysis, split-screen effects, and region isolation.

[View Grid Selector Documentation](dctl/grid-selector/README.md)

## What is DCTL?

DCTL (DaVinci Color Transform Language) is a C-like programming language used in DaVinci Resolve to create custom color transformations and effects. DCTL effects are GPU-accelerated and can be applied in various ways within Resolve:

- As a color LUT
- Through the ResolveFX DCTL plugin
- As a transition effect

DCTL allows for complex pixel-by-pixel operations that would be difficult or impossible to achieve with standard color grading tools.

## Installation

Each effect has its own installation instructions in its respective directory. Generally, to install a DCTL effect:

1. Copy the `.dctl` file to your DaVinci Resolve LUT directory:

   - Windows: `%APPDATA%\Blackmagic Design\DaVinci Resolve\Support\LUT`
   - macOS: `/Library/Application Support/Blackmagic Design/DaVinci Resolve/LUT`
   - Linux: `/home/resolve/LUT`

2. Restart DaVinci Resolve if it's already running.

## Usage

DCTL effects can be applied in two main ways:

### As a ResolveFX:

1. In the Color page, add a new node
2. Open the OpenFX panel
3. Navigate to ResolveFX Color > DCTL
4. Select the desired DCTL from the dropdown
5. Adjust the parameters in the Inspector panel

### As a LUT:

1. In the Color page, add a new node
2. Right-click the node and select "3D LUT" > [DCTL name]
3. Adjust any available parameters

## Development

If you're interested in developing your own DCTL effects, check out the [Blackmagic Design DCTL documentation](https://documents.blackmagicdesign.com/UserManuals/DaVinci_Resolve_17_DCTL_Developer_Guide.pdf).

Key points for DCTL development:

- DCTL uses a C-like syntax
- Effects are GPU-accelerated
- UI parameters can be defined for interactive control
- Custom structs and helper functions can be used for complex operations

## Monitoring DCTL Logs

This repository includes PowerShell scripts for monitoring DCTL compilation logs, which is helpful for debugging:

```powershell
.\monitor-dctl-logs.ps1 -DCTLFile "your_effect.dctl" -DCTLOnly -ErrorsOnly
```

## License

These DCTL effects are provided as-is for educational and professional use.

## Author

Aleksey Larchenko (aleksey.larchenko@gmail.com)

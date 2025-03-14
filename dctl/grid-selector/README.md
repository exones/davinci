# Grid Selector DCTL

A DaVinci Resolve DCTL effect that creates a customizable grid overlay and displays only the content within a selected cell.

## Overview

The Grid Selector DCTL divides the frame into a customizable grid and allows you to select a specific cell to display, masking out all other areas. This is useful for:

- Isolating and comparing specific regions of an image
- Creating split-screen effects
- Analyzing composition using the rule of thirds or other grid-based techniques
- Creating grid-based visual effects

## Features

- Adjustable grid dimensions (rows and columns)
- Selectable cell to display
- Customizable grid line appearance
- Adjustable cell spacing and border width
- Option to show or hide grid lines
- Customizable grid color

## Parameters

| Parameter          | Description                                  | Default | Range        |
| ------------------ | -------------------------------------------- | ------- | ------------ |
| Number of Rows     | Sets the number of rows in the grid          | 3       | 1-5          |
| Number of Columns  | Sets the number of columns in the grid       | 3       | 1-5          |
| Selected Row       | Specifies which row to display (1-based)     | 1       | 1-5          |
| Selected Column    | Specifies which column to display (1-based)  | 1       | 1-5          |
| Cell Spacing       | Sets the space between cells in pixels       | 5       | 0-100        |
| Outer Border Width | Sets the width of the outer border in pixels | 10      | 0-100        |
| Show Grid Lines    | Toggles visibility of grid lines             | On      | On/Off       |
| Grid Color         | Sets the color of the grid lines             | Yellow  | Color Picker |

## Installation

1. Copy the `grid_selector.dctl` file to your DaVinci Resolve LUT directory:

   - Windows: `%APPDATA%\Blackmagic Design\DaVinci Resolve\Support\LUT`
   - macOS: `/Library/Application Support/Blackmagic Design/DaVinci Resolve/LUT`
   - Linux: `/home/resolve/LUT`

2. Restart DaVinci Resolve if it's already running.

## Usage

### As a ResolveFX:

1. In the Color page, add a new node
2. Open the OpenFX panel
3. Navigate to ResolveFX Color > DCTL
4. Select "grid_selector" from the DCTL dropdown
5. Adjust the parameters to customize the grid

### As a LUT:

1. In the Color page, add a new node
2. Right-click the node and select "3D LUT" > "grid_selector"
3. Adjust the parameters in the Inspector panel

## Technical Details

The Grid Selector DCTL works by:

1. Dividing the frame into a grid based on the specified rows and columns
2. Calculating the boundaries of each cell
3. Determining if each pixel is within the selected cell or on a grid line
4. Displaying the original pixel color for pixels in the selected cell
5. Displaying the grid color for pixels on grid lines
6. Displaying black for pixels outside the selected cell

The code uses a custom struct (`GridCell`) to efficiently manage cell information and helper functions to calculate cell dimensions and check pixel positions.

## Examples

- **Rule of Thirds**: Set rows and columns to 3, then select different cells to focus on different compositional areas
- **Split Screen**: Set rows to 1 and columns to 2 for a simple side-by-side comparison
- **Grid Analysis**: Enable grid lines to analyze the composition of your shot

## Compatibility

This DCTL has been tested with DaVinci Resolve 17 and 18. It should work with any version of Resolve that supports DCTL effects.

## License

This DCTL is provided under the Apache 2.0 license. See the LICENSE file for details.

## Author

Aleksey Larchenko aleksey.larchenko@gmail.com

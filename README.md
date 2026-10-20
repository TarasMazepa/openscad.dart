# openscad.dart

CLI tool to convert VGG Image Annotator (VIA) measurement annotations into parametric [OpenSCAD](https://openscad.org/) 3D models.

## Overview

`openscad.dart` reads JSON export files from [VIA](http://www.robots.ox.ac.uk/~vgg/software/via) containing:
- Calibration lines (e.g., a photographed 150 mm ruler) to scale pixels to millimeters.
- Key outline quadrilaterals.

It normalizes, mirrors, and scales the geometry, then outputs OpenSCAD code for 3D printable keyboard covers, key spacers, and case recesses.

## Usage

```bash
# Using dart run directly
dart run cli/bin/openscad.dart <calibration.json> <measured.json> > output.scad

# Or via the live shell wrapper
./path/openscad.dart-live.sh <calibration.json> <measured.json> > output.scad
```

## Related Projects

- **[Perixx-PERIBOARD-524](https://github.com/TarasMazepa/Perixx-PERIBOARD-524)**: Uses this tool to generate `keyboard_left.scad` and `keyboard_right.scad` models for the Perixx PERIBOARD-524 ergonomic split keyboard.

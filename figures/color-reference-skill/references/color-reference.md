# Color Reference

Project color conventions for the GastricBypass figures.

## Palette

- Blue, SWL, Class 1, primary: `#0072B2`
- Orange, RGN, Class 2: `#E69F00`
- Muted pink, Class 3: `#CC79A7`
- Light blue, secondary or MAE: `#56B4E9`
- Vermillion, validation or PreSx: `#D55E00`
- Teal-green, PostSx: `#009E73`
- Forest plot point or line: `#0072B2`

## Diverging Correlation Convention

For this project’s intended diverging correlation scale:

- lower = `#0072B2`
- midpoint = white
- higher = `#D55E00`

When documenting, reconstructing, or validating heatmaps and correlation-style panels, treat that direction as the project semantic standard unless the source panel explicitly indicates a different legend mapping.

## Usage Notes

- Preserve semantic consistency across main and supplementary figures.
- When rebuilding or extending existing figures, match these colors before considering stylistic changes.
- When extracting values from heatmaps or diverging scales, calibrate from the figure’s own legend if present, but use this reference as the project default interpretation.

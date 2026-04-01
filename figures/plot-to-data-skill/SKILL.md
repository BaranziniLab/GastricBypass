---
name: plot-to-data
description: Reconstruct numerical data from plots and figures with high geometric accuracy. Use when a user wants data recovered from a PDF, PNG, or figure panel and visual exactness matters, especially for scatter plots, line plots, ROC curves, forest plots, box plots, and heatmaps.
---

# Plot To Data

Use this skill when the task is to recover structured data from a figure by measuring the figure itself rather than relying on OCR.

## When To Use

Use this skill if the user wants any of the following:

- rebuild a `data.csv` from a figure panel
- recover points, lines, intervals, or heatmap intensities from a PDF or image
- validate whether an extracted CSV actually matches the figure
- regenerate a plot from recovered data and compare it against the source panel

This skill is for visual-data inversion, not text OCR.

## Workflow

1. Start from the highest-resolution panel image available.
2. Detect the true plot region from axes, matrix bounds, or panel geometry.
3. Calibrate the coordinate system from tick marks, reference lines, or color bars.
4. Extract the graphical marks that encode data.
5. Convert those marks from pixels or colors back into numeric values.
6. Write the recovered values into structured data such as `data.csv`.
7. Rerun the plotting code if present.
8. Compare the regenerated panel to the original and iterate until aligned.

## Accuracy Rules

- Prefer measurement from the image itself over visual guessing.
- Fix errors in calibration or extraction logic upstream instead of hand-editing many values downstream.
- Treat overlay comparison as mandatory validation when exactness matters.
- If a plotting script clips valid recovered values, correct the script so the regenerated panel matches the source panel.

## References

- For the detailed end-to-end method, read [references/plot-to-data.md](references/plot-to-data.md).
- For line plots, forest plots, heatmaps, and other figure types, use the generalized sections in [references/plot-to-data.md](references/plot-to-data.md).


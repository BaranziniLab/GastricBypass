# Plot To Data

## Purpose

This document describes a high-accuracy workflow for reconstructing numerical data from publication-quality figures when the underlying source data are unavailable and standard OCR is not trustworthy.

The emphasis is:

- exact geometric calibration
- image-derived extraction rather than guesswork
- explicit conversion from pixels to data coordinates
- reproducible reconstruction into `data.csv`
- regeneration of the panel with plotting code
- direct visual comparison of the regenerated panel against the original figure

This workflow was used to repair `Fig4c` in this directory and is designed to generalize to scatter plots, line plots, forest plots, and heatmaps.

## Core Idea

A figure is a coordinate system rendered into pixels.

The job is to invert that rendering carefully:

1. isolate the plotting region
2. identify the axis geometry
3. identify the graphical marks that encode data
4. convert mark locations, lengths, or colors back into data space
5. save those recovered values to structured data
6. regenerate the figure from the recovered data
7. compare regenerated output against the original and iterate until aligned

The key shift is: do not treat this as text OCR. Treat it as geometric and color measurement.

## What Was Done For `Fig4c`

`Fig4c` is a grouped scatter plot with two colored point clouds and two fitted regression lines.

The repair process was:

1. read the original rendered panel image
2. detect the true plot rectangle from the black axis lines
3. detect x-axis and y-axis tick marks and use them to build a pixel-to-data mapping
4. isolate orange and green point fills by RGB thresholds
5. find connected components in each color mask
6. collapse duplicate detections caused by anti-aliasing and outlines into single centroids
7. transform each centroid from pixel coordinates into data coordinates
8. write those recovered coordinates into `Fig4c/data.csv`
9. rerun `Fig4c/make_plot.R`
10. compare the regenerated panel to the original panel and adjust the workflow, not the points by hand, when mismatches appear

## Why This Worked Better Than Manual Transcription

Manual point-by-point reading from an image is useful for triage but not for exact alignment.

The image-derived method is better because:

- point locations come from measured centroids, not eyeballing
- the axis mapping comes from detected tick geometry, not rough interpolation
- the same extraction rules can be rerun after each refinement
- errors can be diagnosed at the stage where they arise: calibration, segmentation, deduplication, or plotting

## Detailed Workflow

### 1. Start From The Best Raster Representation

Use the highest-quality rendered image available.

Preferred order:

1. original PNG exported from the figure source
2. high-resolution PNG rendered from PDF
3. PDF page rendered to a large raster image

For `Fig4c`, the source image was:

- `Fig4c/Fig4c_MetRS_regain_scatter.png`

This image was `1500 x 1200`, which is adequate for centroid extraction.

If only PDF is available, render at high resolution first. Do not extract from a small screenshot if you can avoid it.

### 2. Detect The Plot Rectangle

Before extracting data marks, find the actual data panel.

For axis-based figures, the plotting area is usually bounded by:

- a left vertical axis line
- a bottom horizontal axis line

For `Fig4c`, dark-pixel scanning showed:

- left axis at about `x = 199`
- bottom axis at about `y = 1009`
- vertical extent of plot near `y = 235` to `1009`
- horizontal extent of plot near `x = 199` to `1469`

This was done by scanning for nearly black pixels and finding the long contiguous runs corresponding to the axis lines.

Practical rule:

- do not infer the panel bounds from labels or margins
- detect the axes from the image itself

### 3. Detect Tick Marks And Build The Coordinate Map

Once the axes are located, detect tick marks.

For `Fig4c`, the x-axis tick centers were found near:

- `247.5, 478.0, 708.5, 939.5, 1170.5, 1401.5`

These corresponded to:

- `-40, -20, 0, 20, 40, 60`

The y-axis tick centers were found near:

- `394.5, 602.0, 809.5`

These corresponded to:

- `50, 25, 0`

Then a linear mapping was fitted:

```text
MetRS      = a_x * pixel_x + b_x
% regain   = a_y * pixel_y + b_y
```

For `Fig4c`, the fitted mappings were approximately:

```text
MetRS    =  0.08664972 * pixel_x - 61.4210351
regain   = -0.12048193 * pixel_y + 97.53012048
```

Why fit the map instead of using two ticks manually:

- it averages out anti-aliasing noise
- it catches slight rendering offsets
- it gives a single reproducible transform for every recovered point

### 4. Segment Data Marks By Color

For grouped scatter plots, the marks are often the easiest objects to extract because they are color-coded.

The method used for `Fig4c`:

- crop the plot region
- threshold orange and green pixels separately in RGB space
- ignore black text and black axes
- ignore regression lines as much as possible by favoring point-fill colors rather than dark edge colors

Example strategy:

- orange mask: high red, medium green, lower blue
- green mask: medium red, high green, medium-high blue

This works because ggplot-style points are anti-aliased but still cluster tightly around a small set of fill colors.

Important:

- threshold the fills, not the outlines, when possible
- use separate masks for each group
- inspect the color histograms if the figure uses unusual palette values

### 5. Extract Connected Components

After thresholding, each point usually appears as one or more connected pixel components.

For `Fig4c`, connected components were extracted from each binary color mask.

Each component was filtered by:

- minimum and maximum area
- bounding-box width and height
- rough circularity proxy through width/height ratio

This removes:

- tiny anti-aliasing fragments
- long pieces of line segments
- legend noise outside the panel

### 6. Deduplicate Components Into Point Centroids

Anti-aliased points often generate multiple nearby components:

- fill fragment
- edge fragment
- partial overlap with another graphic primitive

So component extraction alone overcounts.

The solution used for `Fig4c`:

- cluster extracted components whose centers are within a small radius
- replace each cluster by one averaged centroid

This produced a much more realistic set of points.

General rule:

- if the same plotted point is being detected twice, fix the grouping logic, not the final CSV manually

Manual cleanup is acceptable only for clear false positives after the extraction logic has already done most of the work.

### 7. Convert Centroids To Data Coordinates

Once each point centroid exists in pixel coordinates:

1. apply the x-axis mapping
2. apply the y-axis mapping
3. round only as much as the figure justifies

For `Fig4c`, recovered points were rounded to one decimal place.

This is usually better than integer rounding because the source panel is continuous and the tick spacing allowed finer recovery than whole units.

### 8. Write `data.csv`

The recovered data were then written as:

```csv
group,MetRS,pct_regain
PreSx,...
PostSx,...
```

The key requirement is that the CSV structure must match what the plotting script expects.

For `Fig4c`, that was:

- `group`
- `MetRS`
- `pct_regain`

If the existing R script expects different column names, either:

- preserve the expected schema in the CSV, or
- change the R script intentionally and document why

### 9. Rerun The Plot Script

After rebuilding the data:

- rerun the panel’s R script
- regenerate the output SVG or PNG
- confirm there are no warnings caused by mismatched scale limits

For `Fig4c`, rerunning the plot exposed a genuine issue:

- the script used `limits = c(-15, 70)` on the y-axis
- the extracted data contained real points below `-15`

So the plot script was updated to:

```r
scale_y_continuous(breaks = c(0, 25, 50), limits = c(-25, 70))
```

This matters because clipping valid points creates a fake mismatch between the reconstruction and the original.

### 10. Compare Reconstructed Output To The Original

The final validation step is not a numeric summary. It is a panel-to-panel comparison.

The practical comparison method is:

1. render the regenerated panel to raster
2. resize it to the same dimensions as the original
3. overlay or blend the two images
4. inspect:
   - point alignment
   - regression line alignment
   - relative group density
   - axis limits
   - clipping behavior

If the shapes mismatch, diagnose by layer:

- wrong panel geometry: axes or crop are wrong
- wrong coordinate map: tick calibration is wrong
- wrong masks: extraction is pulling in non-data pixels
- wrong deduplication: same point counted twice
- wrong script limits: valid data are being clipped

Only after localizing the error should you revise the workflow.

## Generalized Recipe By Figure Type

### Scatter Plots

Recover:

- point centers
- point groups by color/shape
- optional fitted lines if needed

Best method:

- detect panel
- calibrate axes
- color-segment points
- connected components
- centroid extraction
- pixel-to-data transform

Main risks:

- duplicate detections from anti-aliased edges
- confusion between points and regression lines
- clipped points due to script scale limits

### Line Plots

Recover:

- line trajectories as sequences of `(x, y)` values
- optionally confidence ribbons
- optionally point markers

Best method:

1. isolate line color
2. thin the line into a center path
3. for each x column, estimate the y center of the line
4. convert sampled pixels to data coordinates
5. resample or smooth carefully if needed

For multiple lines:

- segment by color first
- process each series separately

For confidence ribbons:

- detect upper and lower ribbon boundaries from semi-transparent fills
- convert top and bottom edges into `ymin` and `ymax`

Main risks:

- aliasing causes jagged center paths
- overlapping lines can merge
- legends share the same colors as the plot

### Forest Plots

Recover:

- point estimate
- lower confidence bound
- upper confidence bound
- label order

Best method:

1. calibrate x-axis from tick marks
2. detect each row
3. locate the CI line segment for the row
4. identify the estimate marker center
5. convert x positions to effect sizes

If text labels are not recoverable reliably:

- preserve row order from top to bottom
- assign temporary row IDs
- link labels separately from text extraction if needed

Main risks:

- estimate markers and CI segments merge
- log-scale axes require log-space calibration
- row labels can be misaligned relative to graphical rows

Special note for forest plots:

- always detect whether the x-axis is linear or log
- do not assume equal spacing in data space from equal spacing in pixels

### Bar Plots And Box Plots

Recover:

- bar heights
- error bar ends
- box boundaries
- whisker limits
- outlier points

Best method:

- detect group centers along x
- use panel bottom as the zero reference if the y-axis is numeric
- detect top edges or whisker endpoints
- map those y pixels back to values

For boxplots specifically:

- median line
- upper and lower box edges
- whisker ends
- outlier centroids

should be extracted separately.

### Heatmaps

Recover:

- cell intensities
- row and column order
- optionally clustered structure

Best method:

1. detect the heatmap matrix rectangle
2. detect grid boundaries or infer cell count
3. sample the center color of each cell
4. calibrate the color bar
5. invert color to value

The crucial extra step is color-bar inversion.

For a continuous color scale:

- detect the color bar gradient
- sample many colors along the bar
- map those sampled RGB values to the corresponding numeric scale
- for each heatmap cell, find the nearest color-bar color and assign the matching value

For diverging palettes:

- detect the midpoint explicitly
- do not assume RGB distance is linear in value unless the palette is known
- for this project’s correlation diverging convention, `#0072B2` is the lower end, white is the midpoint, and `#D55E00` is the higher end

For exactness, it is better to calibrate from the figure’s own legend than from assumptions like:

- blue equals `-1`
- white equals `0`
- red equals `1`

unless that is explicitly encoded in the figure.

Main risks:

- clustered heatmaps may omit visible grid lines
- anti-aliased cell boundaries can shift sampled colors if you sample near edges
- legend gradients can be non-linear in perceptual space

### Correlation Circles, Volcano Plots, ROC Curves, Density Plots

Treat each according to what encodes the data:

- ROC curves: path extraction plus x/y axis calibration
- density curves: line extraction plus optional filled area boundaries
- volcano plots: scatter workflow with possible label extraction
- correlation circles: point or text positions plus radial calibration if needed

For ROC curves in particular:

- recover the actual polyline from the colored path
- compute AUC from the recovered coordinates
- verify it matches the figure’s annotation

If the AUC does not match the figure annotation, the reconstruction is wrong even if the curve looks visually close.

## Accuracy Rules

### 1. Calibrate From The Figure, Not From Assumptions

Always derive:

- axis positions
- tick spacing
- plot bounds
- color-value mapping

from the image itself.

### 2. Preserve Native Geometry

Do not “clean up” the data into prettier values unless the figure clearly supports that precision.

If the source point is at `(9.1, 57.2)`, do not round it to `(10, 60)` unless the panel resolution makes finer precision meaningless.

### 3. Fix Pipeline Errors Upstream

If the regenerated panel does not align:

- do not hand-edit fifty points first
- determine whether the error came from calibration, segmentation, deduplication, or plotting

### 4. Validate At The Figure Level

A plausible `data.csv` is not enough.

The reconstruction is only acceptable if the regenerated panel overlays the original closely.

### 5. Be Honest About Precision

There are three levels of recovery:

1. exact source data recovery
2. exact visual reconstruction
3. approximate visual reconstruction

This workflow targets level 2 when source data are missing.

That distinction should be stated explicitly.

## Practical Implementation Pattern

For most figures, use this loop:

1. render the source figure to high-resolution raster
2. detect plot geometry
3. calibrate axes or color bar
4. extract marks by geometry or color
5. convert to data coordinates or intensities
6. write structured CSV
7. rerun plotting code
8. compare rendered output to the source
9. revise extraction rules
10. repeat until aligned

This should be treated as a measurement-and-reconstruction problem, not an OCR problem.

## Recommended File Outputs

For each repaired panel, keep:

- original figure image or rendered PDF panel
- extraction script or command history
- calibrated `data.csv`
- plotting script
- regenerated figure
- optional overlay image for validation

Suggested temporary validation artifacts:

- `/tmp/<panel>_overlay.png`
- `/tmp/<panel>_extracted.csv`
- `/tmp/<panel>_extracted.png`

These do not have to be committed, but they are valuable during iteration.

## Common Failure Modes

### False Positives

Examples:

- legend markers included as data points
- regression line fragments mistaken for points
- text anti-aliasing mistaken for colored marks

Mitigation:

- restrict extraction to the plot rectangle
- exclude legend area
- tighten component shape filters

### False Negatives

Examples:

- lightly colored points missed by narrow thresholds
- overlapping points merging into one centroid

Mitigation:

- inspect color distribution
- use multiple masks if necessary
- compare expected point counts visually

### Wrong Coordinate Transform

Examples:

- using label positions instead of tick marks
- ignoring log scaling
- assuming the panel starts exactly at the first visible tick

Mitigation:

- detect axes directly
- fit transforms from multiple ticks
- check known anchor values

### Plot Script Mismatch

Examples:

- wrong scale limits
- reversed axes
- group order differs from the original
- factor levels differ from the panel legend

Mitigation:

- inspect the plotting code after rebuilding the data
- compare generated annotations, legend order, and clipping behavior

## What To Do When Exact Alignment Still Fails

If overlay comparison still shows mismatch:

1. verify the panel crop
2. verify the axis-line coordinates
3. verify tick-center detection
4. verify whether the figure uses a transformed scale
5. verify whether the color threshold is picking fill, outline, or both
6. verify component clustering radius
7. verify that the plotting code reproduces the same visual grammar as the original

If needed, build a layered diagnostic:

- original image
- extracted point centroids plotted as dots only
- regenerated full panel
- blended overlay

This makes it easier to see whether the mismatch is in the raw points or in the plotting style.

## Minimal Reusable Checklist

For any figure:

1. get the highest-resolution panel image available
2. isolate the data panel
3. detect axis lines or matrix boundaries
4. detect tick marks or color bar anchors
5. build the pixel-to-data or color-to-value transform
6. extract graphical marks with explicit rules
7. deduplicate and filter artifacts
8. convert measurements into structured data
9. regenerate the panel from that data
10. compare regenerated output against the original and iterate

## Final Principle

When accuracy matters, the figure itself is the measurement instrument.

Do not ask “what text does the image contain?”

Ask:

- where is the plotting coordinate system?
- which pixels encode data?
- how do those pixels map back to values?
- does the regenerated figure land on the same geometry as the original?

That is the standard required for exacting plot-to-data recovery.

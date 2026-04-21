# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Research manuscript project: **"Baseline metabolomic profile as potential biomarker for weight change after Roux-en-Y gastric bypass (RYGB) surgery"**

- **Discovery cohort:** LABS-2 (n=160 with metabolomics)
- **Key outcome:** %EBW at year 5 (%EBW5); higher = worse (more weight regain)
- **Key construct:** MetRS (13-metabolite Metabolite Risk Score); higher = higher regain risk
- **Validation:** Post-RYGB clinical cohort, Estonian Biobank, Framingham Heart Study (GWAS)
- **Current submission target:** Cell Reports Medicine

## Running Figures

Each figure lives in `figures/FigXX/` with a `make_plot.R` script and a `data.csv`. To regenerate a figure:

```r
setwd("figures/Fig3a")   # or use here::here()
source("make_plot.R")
```

Figures save at `dpi=800, bg="white"` as `.svg` (preferred) or `.png`.

Data files are **not committed** — they live in `figures_crm_data/`. See [figures/_README.txt](figures/_README.txt) for the full file manifest and placement instructions.

## R Coding Style

All conventions are defined in [figures/plotting-style-reference.md](figures/plotting-style-reference.md). Key rules:

- **Assignment:** use `=`, never `<-`
- **base_size:** always `15` in theme calls
- **Points:** `shape=21, size=3, alpha=0.8, color="black"` (filled circle with border)
- **Boxplots:** `outlier.shape=NA`; plot individual points separately with jitter/dodge
- **Lines:** `linewidth=0.8`; error bars `linewidth=0.5, width=0.3`
- **File paths:** relative only, never hardcoded absolute paths
- **Legend titles:** use `labs(fill="", color="")` to remove

### Themes by plot type

| Plot type | Theme |
|-----------|-------|
| Boxplot / bar | `theme_classic(base_size=15)` + `axis.text.x` angle 45 |
| Line / time-course | `theme_linedraw(base_size=15)` |
| PCoA / scatter | `theme_linedraw(base_size=15)` |
| Horizontal bar | `theme_minimal(base_size=15)` |
| Network / alluvial | `theme_void()` |

## Color Palette (colorblind-friendly)

```
Blue  (SWL / Class 1):         #0072B2
Orange/Gold (RGN / Class 2):   #E69F00
Muted pink (Class 3):          #CC79A7
Light blue (secondary / Lean): #56B4E9
Vermillion (validation / PreSx / Obese): #D55E00
Teal-green (PostSx):           #009E73
Correlation diverging:         #0072B2 — white — #D55E00
```

## Repository Structure

```
figures/
  FigXX/          # One directory per panel: make_plot.R + data.csv + output
  combined_figures/
  graphical_abstract/
  figures-explained.md    # Full figure-by-figure description
  plotting-style-reference.md
  color-reference.md
  plot-to-data.md         # Workflow for recovering data from rendered images
  _README.txt             # Data file manifest
submissions/
  cell report medicine/   # Current target (CRM_met_20Mar26.docx)
  nature communications/
  original draft/
supplement/
  Extended_data_20Jul25.docx
```

## Recovering Data From Figures

When source data are missing and must be reconstructed from a rendered panel, follow the geometric workflow in [figures/plot-to-data.md](figures/plot-to-data.md). The core loop:

1. Detect plot rectangle from axis lines
2. Calibrate pixel-to-data coordinates from tick marks (fit a linear map, don't use two manual points)
3. Segment data marks by color/shape in pixel space
4. Extract connected components → deduplicate centroids
5. Convert centroids to data coordinates
6. Write `data.csv`, rerun `make_plot.R`, compare overlay against original

Fix errors upstream in the pipeline — do not hand-edit individual recovered points.

## Git Automation

`auto_sync.sh` (Mac) / `auto_sync.bat` (Windows) runs: add → commit → pull → push in one step.

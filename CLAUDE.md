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

---

## Cell Reports Medicine Submission — File Paths
*Added 2026-04-30*

### Active Manuscript
```
submissions/cell report medicine/manuscript/CRM_met_23Apr26.docx   ← LATEST
submissions/cell report medicine/manuscript/CRM_met_20Mar26_rs.docx
submissions/cell report medicine/manuscript/LC-MS_methods_042426.docx
submissions/cell report medicine/manuscript/Network Analysis Writeup.docx
submissions/cell report medicine/manuscript/tasks/Tasks.txt         ← task list (23 Apr 2026)
```

### Submission Figures Folder
All submission-ready figures are in `submissions/cell report medicine/figures/`.
See `submissions/cell report medicine/figures/action_items.md` for the complete file inventory, outstanding to-do items, and per-figure action notes.

**Main figure Illustrator files (combined multi-panel):**
```
submissions/cell report medicine/figures/Figure1.ai       ← from figures/Figure1_revised.ai
submissions/cell report medicine/figures/Figure2.ai       ← from figures/Figure2.ai (Apr 18, latest)
submissions/cell report medicine/figures/Figure3.ai       ← from figures/Figure3.ai
submissions/cell report medicine/figures/Figure4.ai       ← from figures/Figure4.ai
```

**Supplementary Illustrator files:**
```
submissions/cell report medicine/figures/SupplementaryFigure1.ai
submissions/cell report medicine/figures/SupplementaryFigure2.ai
submissions/cell report medicine/figures/SupplementaryFigure3.ai   ← panels b,d missing
submissions/cell report medicine/figures/SupplementaryFigureX.ai   ← MetRS stability
```

**Individual panel PNGs (Fig 1–4):**
```
submissions/cell report medicine/figures/fig1a.png  fig1b.png  fig1c.png  fig1d.png  fig1e.png  fig1f.png
submissions/cell report medicine/figures/fig2b.png  fig2c.png  fig2d.1.png  fig2d.2.png
submissions/cell report medicine/figures/fig3a.png  fig3b.png  fig3c.png  fig3d.png
submissions/cell report medicine/figures/fig4a.png  fig4b.png  fig4c.png
submissions/cell report medicine/figures/fig4d.png  fig4e.png  fig4f.png  fig4g.png   ← GWAS Manhattans
```

**Supplementary panel PNGs:**
```
submissions/cell report medicine/figures/figs1a.png  figs1b.png  figs1c.png
submissions/cell report medicine/figures/figs2_delta_ebw.png  figs2_ebw_cohort.png
submissions/cell report medicine/figures/figs5_bootstrap_stability.png  figs5_pvalue_histogram.png  figs5_qq_plot.png
submissions/cell report medicine/figures/figs5a_corrplot_62metab.png
submissions/cell report medicine/figures/figs6b.png  figs7b.png
submissions/cell report medicine/figures/figsx_metrs_density.png  figsx_metrs10_labs2.png  figsx_metrs8_labs2.png
submissions/cell report medicine/figures/figsx_predicted_vs_observed_rmse.png
submissions/cell report medicine/figures/figsy.png
```

### Supplemental Documents
```
submissions/cell report medicine/supplement/Supplemental_Tables.xlsx
submissions/cell report medicine/supplement/Supplemental Note.docx
```

### Key Outstanding Issues (from Tasks.txt + manuscript review)
1. **Remove Fig. 2b** from Figure2.ai — Rany's recommendation (agreed)
2. **Fig. 2a PNG missing** — only PDF/xlsx in `figures/Fig2a/`; export needed
3. **Supp Fig. 3 panels b & d missing** — `% EBW` and `by center` plots need to be generated
4. **Supp Fig. 4 PNG missing** — only old PDF in `figures/FigS4/`
5. **Supp Fig. 8** — fully annotated network plot not yet assembled
6. **Figure numbering discrepancy** — manuscript uses Supp Fig. 8A/B/C for GWAS; Tasks.txt assigns Fig. 8 = network, Fig. 9 = GWAS; needs reconciliation
7. **Expand GWAS section** per Rany's comments
8. **Add FHS cohort demographics** to manuscript/supplemental table

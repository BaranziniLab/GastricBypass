# GastricBypass: Baseline Metabolomic Profiling of Weight Change After RYGB

Analysis code, figure pipelines, and manuscript materials for the study:

> **Baseline metabolomic profile as a potential biomarker for weight change after Roux-en-Y gastric bypass (RYGB) surgery**

This repository holds the code and source data needed to reproduce the figures and statistical analyses in the manuscript, covering latent-class trajectory modeling, the Metabolite Risk Score (MetRS), knowledge-graph network analysis, and genome-wide association testing.

## Study overview

Roux-en-Y gastric bypass produces large, durable weight loss for most patients, but a subset of patients regain a clinically significant amount of weight, and no validated biomarker predicts long-term success. Because the circulating metabolome reflects host genetics, diet, microbiota, and environmental exposures, we asked whether baseline (pre-operative) fasting plasma metabolites can separate individuals who sustain weight loss from those who regain.

The main result is the MetRS (Metabolite Risk Score), a 13-metabolite weighted score derived in the discovery cohort. A higher MetRS corresponds to higher predicted weight-regain risk. The score is evaluated in two independent cohorts and examined genetically in a population study.

Key terms used in the code and manuscript:

| Term | Definition |
|---|---|
| EBW | Excess body weight, the measured weight minus ideal body weight at BMI 25 kg/m2 |
| %EBW5 | (EBW at year 5 / baseline EBW) x 100. Higher values mean a worse outcome |
| MetRS | 13-metabolite risk score, a weighted sum of standardized metabolite concentrations |
| Trajectory classes | Latent groups from LCGMM: Class 1 (regain), Class 2 (sustained loss), Class 3 (lower-baseline majority) |

## Cohorts

| Role | Cohort | N (analytic) | Use |
|---|---|---|---|
| Discovery | LABS-2 (Longitudinal Assessment of Bariatric Surgery-2) | 1,590 RYGB with 7-year weight data; 160 profiled (80 sustained loss, 80 regain) | Trajectory modeling, metabolite association, MetRS derivation |
| Validation | Post-RYGB clinical cohort | 35 (about 14 SWL, 21 RGN) | MetRS replication at a median of about 7 years post-surgery |
| External | Estonian Biobank (University of Tartu) | 198 BMI extremes (about 98 lean, 100 obese) | Cross-platform metabolite signal |
| Genetics | Framingham Heart Study (FHS) Offspring | 1,613 European-ancestry with plasma metabolomics | GWAS of MetRS and constituent metabolites |

## Repository structure

```
GastricBypass/
  README.md                      This file
  CLAUDE.md                      Working notes, conventions, submission file map
  figures/                       One directory per panel: make_plot.R + data.csv + output
    Fig1a ... Fig4c              Main-figure panels
    Fig2de/                      SPOKE knowledge-graph network panels
    Fig4defg/                    GWAS Manhattan and regional plots
    FigS, FigSx, FigSy           Supplementary-figure panels
    combined_figures/            Assembled multi-panel figures
    graphical_abstract/
    figures-explained.md         Panel-by-panel description of every figure
    plotting-style-reference.md  ggplot2 conventions (themes, sizes, palette)
    color-reference.md
    plot-to-data.md              Workflow to recover data from rendered panels
    _README.txt                  Data-file manifest for the figure pipeline
  tables/                        FHS demographic and GWAS summary tables plus builder scripts
    make_fhs_cohort_summary.R
    make_fhs_demographics_table.R
    make_gwas_hits_table.R
    data/                        FHS phenotype inputs (controlled access, not distributed)
    README.md                    FHS cohort-construction and GWAS documentation
  submissions/                   Manuscript versions by target journal
    med/
      manuscript/                Current working manuscript (.docx)
      figures/                   Submission-ready Figure1 to 4 and SupplementaryFigure1 to 7
      supplement/                Supplemental tables, note, figure captions
  supplement/                    Extended data
  auto_sync.sh / auto_sync.bat   add, commit, pull, push helper
  .gitignore
```

## Reproducing the figures

Each panel is self-contained. From the repository root:

```r
setwd("figures/Fig3a")   # or use here::here()
source("make_plot.R")
```

Figures are written at dpi = 800, bg = "white" as .svg (preferred) or .png.

Data files are not committed. Large source-data files live in a local `figures_crm_data/` folder; see `figures/_README.txt` for the file list and placement instructions. The de-identified, publication-level source data behind each panel are released separately (see Data availability).

### R coding conventions

Full conventions are in `figures/plotting-style-reference.md`. Main points:

- Assignment with `=`; `theme(base_size = 15)`.
- Points: `shape = 21, size = 3, alpha = 0.8, color = "black"`.
- Boxplots: `outlier.shape = NA`, with individual points jittered or dodged separately.
- Relative file paths only.

Colorblind-friendly palette:

| Hex | Use |
|---|---|
| 0072B2 | Blue, sustained weight loss (SWL) or Class 1 |
| E69F00 | Orange or gold, regain (RGN) or Class 2 |
| CC79A7 | Muted pink, Class 3 |
| 56B4E9 | Light blue, secondary or lean |
| D55E00 | Vermillion, validation, pre-surgery, or obese |
| 009E73 | Teal-green, post-surgery |

## Analysis components

1. Trajectory modeling: latent class growth mixture modeling (Mplus) over 7-year EBW; broken-stick (linear B-spline) mixed-effects models with knots at 6, 12, and 24 months (`brokenstick`).
2. Cohort matching: propensity-score 1:1 matching of regain versus sustained-loss participants (`MatchIt`), with multiple imputation (`MICE`).
3. Metabolite association and MetRS: per-metabolite regression against %EBW5, FDR control, bidirectional stepwise selection (AIC), bootstrap stability, and 100 repeats of 10-fold cross-validation.
4. Network analysis: seed metabolites mapped into the SPOKE biomedical knowledge graph; first-degree neighbors and shortest-path (Steiner-tree) subgraphs across Gene, Protein, Pathway, and Disease nodes; centrality via NetworkX or igraph; visualized in Cytoscape.
5. Genetics: FHS GWAS with SAIGE (covariates: sex, age, PC1 to PC10), imputation via the Michigan Imputation Server (HRC r1.1), conditional analysis, and LocusZoom regional plots.

## Data availability

- Individual-level LABS-2, post-RYGB, and Estonian Biobank data are subject to the respective studies' data-use agreements and are not redistributed here.
- Framingham Heart Study genotype, phenotype, and metabolomics data are available through dbGaP under accession phs000007 (consent group HMB-IRB-MDS); component phenotype tables used here include pht000091 (HbA1c, fasting insulin), pht000202 (serum creatinine), pht002343 (case status), pht003099 (sex, age), and pht006027 (BMI). See `tables/README.md` for the full cohort-construction pipeline. (Accession details pending final author confirmation.)
- Publication-level, de-identified source data behind the figures are deposited on Zenodo (DOI to be added on release).

## Manuscript and submissions

The working manuscript and submission-ready assets are under `submissions/med/`. Figure descriptions are in `figures/figures-explained.md`; the manuscript Key Resources Table lists all software, databases, and versions.

## Citation

If you use this code or the MetRS, please cite the manuscript (full citation to be added on publication) and this repository.

## Contact

Corresponding author: Vidhu V. Thaker (vvt2114@cumc.columbia.edu). For code questions, open an issue on this repository.

## License

Code is released for academic, non-commercial use. See `LICENSE` (to be added) for terms.

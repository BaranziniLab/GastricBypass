# Release Notes

## v1.0 — 2026-06-20

First public release of the de-identified figure source data accompanying
*Baseline metabolomic profile as a potential biomarker for weight change after Roux-en-Y gastric bypass (RYGB) surgery.*

### Contents
- **37 figure source-data CSVs** covering main Figures 1–4 and Supplementary Figures (panel folders `Fig1a`–`Fig4c`, `Fig2de` network tables, and `FigS*`/`FigSx`/`FigSy`).
- **5 FHS summary tables** (cohort summary, sex-stratified demographics, genome-wide significant hits) in `.csv`/`.xlsx`.
- `MANIFEST.csv` describing the row/column structure and column names of every file.

### Privacy / exclusions
- Excluded `FigS3/ebw_metab_cohort_site.csv` — contains quasi-identifiable LABS-2 per-participant records (`id`, age, sex, race, surgical site).
- No raw individual-level metabolomics, genotype, or phenotype data are included; these remain under the source studies' data-use agreements.

### Known items pending
- **FHS dbGaP accession/version** strings (phs000007 and component pht tables) are to be confirmed against the analysis cluster records before final publication.
- **Zenodo DOI** will be minted on publication of this deposit and added to the manuscript Key Resources Table and the repository README.

### Provenance
All files were drawn directly from the `figures/` and `tables/` directories of the companion repository (https://github.com/baranzinilab/GastricBypass). No values were altered during packaging.

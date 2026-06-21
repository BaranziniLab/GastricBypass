# tables/

Supplemental and summary tables for the GastricBypass manuscript.

---

## FHS_cohort_summary.xlsx

**Description:** Participant characteristics of the Framingham Heart Study (FHS) GWAS validation cohort (N = 1,613 European-ancestry individuals with plasma metabolomics data at Exam 5).

**Sections in the table:**

| Section | Variables |
|---|---|
| Demographics | N, sex, age at metabolomics exam |
| Anthropometrics | BMI at Exam 5 (baseline), BMI at Exam 7 (follow-up), ΔBMI |
| Cardiometabolic | Serum creatinine, HbA1c, fasting insulin |
| Clinical events | Type 2 diabetes, CVD history (Exam 5 metabolomics case-control subset) |
| Metabolite Risk Score | MetRS (10-metabolite composite) |
| MetRS components | All 10 individual metabolites (inverse-normal transformed) |

---

## Reproducing the table

Run from this directory:

```r
Rscript make_fhs_cohort_summary.R
```

### Input files (in `data/`)

| File | Source | Description |
|---|---|---|
| `FHS_EA_phenotype.txt` | `/salemlab/users/wanjun/met_redo/FHS_EA_metabolites_phenotype.txt` | Primary analytical sample: 1,613 EA subjects with sex, age, BMI5/7, ΔBMI, 10 metabolites, MetRS, PCs |
| `Visit_1_creat.txt` | `/salemlab/users/wanjun/met_ckd/raw_data/cleanup/Visit_1_creat.txt.txt` | Serum creatinine at Exam 5 (extracted from dbGaP pht000202.v6) |
| `inshba1_5s.txt` | `~/fhs_pheno/phs000007.v29.pht000091.v6.p10.c1.inshba1_5s.HMB-IRB-MDS.txt` | HbA1c and fasting insulin at Exam 5 (dbGaP pht000091.v6) |
| `l_mtbllipi1_ex05.txt` | `~/fhs_pheno/phs000007.v29.pht002343.v4.p10.c1.l_mtbllipi1_ex05_1_0617s.HMB-IRB-MDS.txt` | Lipid-platform metabolomics, Exam 5, installment 1 (carries PC(34:2) = LIPID.C34_2_PC); dbGaP pht002343.v4 |

### Verified dbGaP accessions

Parent study **phs000007.v29.p10**, consent group **c1 (HMB-IRB-MDS)**. All phenotype tables below are under `phs000007.v29.p10.c1`.

**Metabolomics (Offspring Exam 5; three platforms, seven installment tables — combine installments per dbGaP):**

| Accession | Table | Platform |
|---|---|---|
| pht002234.v5 | l_mtbli1_ex05 | HILIC (amide/polar) inst 1 |
| pht002566.v3 | l_mtbli2_ex05 | HILIC inst 2 |
| pht002895.v1 | l_mtbli3_ex05 | HILIC inst 3 |
| pht002565.v4 | l_mtblcmhi1_ex05 | Central HILIC inst 1 |
| pht002894.v1 | l_mtblcmhi2_ex05 | Central HILIC inst 2 |
| pht002343.v4 | l_mtbllipi1_ex05 | Lipid inst 1 (carries PC(34:2)) |
| pht002567.v3 | l_mtbllipi2_ex05 | Lipid inst 2 |

**Clinical / covariate tables (Offspring Exam 5):**

| Accession | Table | Content used |
|---|---|---|
| pht000091.v6 | inshba1_5s | HbA1c, fasting insulin |
| pht000202.v6 | laba1_5s | Creatinine (table also holds B12, B6, folate, homocysteine, cysteine, riboflavin) |
| pht003099.v4 | vr_dates_2014 | Sex (phv177929), age at exam (phv177930) |
| pht006027.v1 | vr_wkthru_ex09 | BMI (BMI1–BMI9; uses BMI5 and BMI7 for ΔBMI) |

**Genotype datasets (for the GWAS):**

| Accession | Dataset | Used as |
|---|---|---|
| phg000006.v9 | FHS SHARe Affymetrix 500K | FHS_EA build (primary GWAS) |
| phg000256.v4 | FHS SHARe Omni5M | FHS_Omni5M build |

Genotypes were locally imputed to 1000 Genomes (`FHS_EA_FINAL_HG19_1KGpos`); for data-availability, cite the source array datasets above under the parent study phs000007.v29.p10.

### Cohort construction pipeline

The analytical sample was built in two stages on the Narrows cluster:

**Stage 1 — `get_met.R`** (`/salemlab/users/wanjun/met/`):
- Starts from 2,011 subjects in `METdata_RheeCompleteSamples_qc_log_adj_medianImp_invNorm.txt` (Rhee et al. metabolomics; already QC'd, log-adjusted, median-imputed, inverse-normal transformed)
- Joins sex/age from `Visit_pht003099_sex_age_FHS.txt` (dbGaP vr_dates table)
- Inner joins with `FHS_EA.linker` → restricts to **European-ancestry** participants with genotype data
- Inner joins with `FHS_EA_FINAL_PCAS.evec` → restricts to subjects with valid ancestry PCA

**Stage 2 — `cleanup.R`** (`/salemlab/users/wanjun/met_redo/raw_data/`):
- Joins BMI at Exam 5 and Exam 7 (`Visit_1_BMIs.txt.txt`, derived from dbGaP pht006027)
- Computes ΔBMI = BMI7 − BMI5 and ΔBMI/age
- Recomputes MetRS from 10 metabolite weights (LASSO coefficients from LABS-2 discovery)
- Final N = **1,613** (from 2,011 after EA + PCA filter)

**No explicit exclusions** for diabetes, CVD, CKD, smoking, or BMI thresholds in the main analytical pipeline (those exclusions exist only in the `met_ckd` branch).

### GWAS model

All GWAS runs used SAIGE mixed model with covariates: **sex, age, PC1–PC10**.
- Autosomes: N = 1,613 (full sample; SAIGE handles relatedness via random effects)
- Chromosome X: N = 742 (unrelated subjects only; status = UN)
- ΔBMI GWAS: N = 1,467 (subjects with both Exam 5 and Exam 7 BMI)

---

## Other tables in this folder

| File | Description |
|---|---|
| `Table1_FHS_demographics.xlsx` | Sex-stratified Table 1 (see `figures/Table1/make_table.R`) |

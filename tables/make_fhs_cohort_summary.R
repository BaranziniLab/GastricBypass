library(dplyr)
library(openxlsx)

# ── Data loading ─────────────────────────────────────────────────────────────
pheno = read.table("data/FHS_EA_phenotype.txt",
                   header = TRUE, sep = " ", na.strings = "NA")

creat = read.table("data/Visit_1_creat.txt",
                   header = TRUE, sep = "\t", na.strings = c("NA", ""))

# Skip comment lines (start with #) then read
hba_lines = readLines("data/inshba1_5s.txt")
hba_lines = hba_lines[!grepl("^#", hba_lines) & nchar(trimws(hba_lines)) > 0]
hba = read.table(text = paste(hba_lines, collapse = "\n"),
                 header = TRUE, sep = "\t", na.strings = c("NA", ""))

lip_lines = readLines("data/l_mtbllipi1_ex05.txt")
lip_lines = lip_lines[!grepl("^#", lip_lines) & nchar(trimws(lip_lines)) > 0]
lip = read.table(text = paste(lip_lines, collapse = "\n"),
                 header = TRUE, sep = "\t", na.strings = c("NA", ""))

# Rename key columns
creat = creat %>% rename(dbgap = dbgap)
hba   = hba   %>% rename(dbgap = dbGaP_Subject_ID)
lip   = lip   %>% rename(dbgap = dbGaP_Subject_ID)

# ── Merge all onto analytical sample ─────────────────────────────────────────
df = pheno %>%
  mutate(dbgap = as.integer(dbgap)) %>%
  left_join(creat %>% mutate(dbgap = as.integer(dbgap)) %>% select(dbgap, CREAT),
            by = "dbgap") %>%
  left_join(hba   %>% mutate(dbgap = as.integer(dbgap)) %>% select(dbgap, HBA1C, PFINSLN5),
            by = "dbgap") %>%
  left_join(lip   %>% mutate(dbgap = as.integer(dbgap)) %>% select(dbgap, dm_case, cvd_case),
            by = "dbgap") %>%
  mutate(Sex = factor(sex, levels = c(1, 2), labels = c("Male", "Female")))

N = nrow(df)

# ── Helper functions ──────────────────────────────────────────────────────────
fmt_ms = function(x, digits = 1) {
  x = x[!is.na(x)]
  if (!length(x)) return("N/A")
  sprintf(paste0("%.", digits, "f ± %.", digits, "f"), mean(x), sd(x))
}

fmt_np = function(n_cases, n_total) {
  if (!n_total) return("N/A")
  sprintf("%d (%s%%)", n_cases, formatC(100 * n_cases / n_total, digits = 1, format = "f"))
}

n_avail = function(x) sum(!is.na(x))

# ── Build table rows ──────────────────────────────────────────────────────────
make_row = function(characteristic, value, n_avail = "", note = "") {
  data.frame(Characteristic = characteristic,
             Value           = value,
             N_available     = as.character(n_avail),
             Note            = note,
             stringsAsFactors = FALSE)
}

rows = bind_rows(
  # Section: Demographics
  make_row("DEMOGRAPHICS", "", "", ""),
  make_row("Total N", as.character(N)),
  make_row("Female, n (%)", fmt_np(sum(df$sex == 2), N), N),
  make_row("Age, years", fmt_ms(df$age), n_avail(df$age),
           "Age at metabolomics exam"),

  # Section: Anthropometrics
  make_row("ANTHROPOMETRICS", "", "", ""),
  make_row("BMI at Exam 5 (baseline), kg/m²",
           fmt_ms(df$BMI5), n_avail(df$BMI5),
           "Exam 5 (~1991–1995); metabolomics baseline"),
  make_row("BMI at Exam 7 (follow-up), kg/m²",
           fmt_ms(df$BMI7), n_avail(df$BMI7),
           "Exam 7 (~1998–2001)"),
  make_row("ΔBMI (Exam 7 − Exam 5), kg/m²",
           fmt_ms(df$delta_bmi), n_avail(df$delta_bmi),
           "Primary outcome analogue in FHS"),

  # Section: Cardiometabolic labs
  make_row("CARDIOMETABOLIC", "", "", ""),
  make_row("Serum creatinine, mg/dL",
           fmt_ms(df$CREAT), n_avail(df$CREAT),
           "Exam 5 (pht000202)"),
  make_row("HbA1c, %",
           fmt_ms(df$HBA1C), n_avail(df$HBA1C),
           "Exam 5 (pht000091 inshba1_5s)"),
  make_row("Fasting insulin, uIU/mL",
           fmt_ms(df$PFINSLN5, digits = 1), n_avail(df$PFINSLN5),
           "Plasma fasting insulin at Exam 5"),

  # Section: Clinical events (from Exam 5 metabolomics case-control subset)
  make_row("CLINICAL EVENTS (Exam 5 metabolomics subset)", "", "", ""),
  make_row("Type 2 diabetes, n (%)",
           fmt_np(sum(df$dm_case == 1, na.rm = TRUE), n_avail(df$dm_case)),
           n_avail(df$dm_case),
           "dm_case from pht002343 (n matched to metabolomics subset)"),
  make_row("CVD history, n (%)",
           fmt_np(sum(df$cvd_case == 1, na.rm = TRUE), n_avail(df$cvd_case)),
           n_avail(df$cvd_case),
           "cvd_case from pht002343"),

  # Section: MetRS
  make_row("METABOLITE RISK SCORE", "", "", ""),
  make_row("MetRS", fmt_ms(df$MRS, digits = 2), n_avail(df$MRS),
           "10-metabolite score; higher = greater BMI gain risk"),

  # Section: Individual metabolites (all inverse-normal transformed)
  make_row("METRS COMPONENT METABOLITES (inverse-normal transformed)", "", "",
           "All values are inverse-normal transformed; mean ≈ 0, SD ≈ 1"),
  make_row("Glucuronate",
           fmt_ms(df$CENTRAL.glucuronate, 3), n_avail(df$CENTRAL.glucuronate),
           "Negative MetRS weight (−4.31)"),
  make_row("Hippurate",
           fmt_ms(df$CENTRAL.hippurate, 3), n_avail(df$CENTRAL.hippurate),
           "Negative MetRS weight (−3.26)"),
  make_row("Methyladipate/Pimelate",
           fmt_ms(df$CENTRAL.methyladi_pimelate, 3), n_avail(df$CENTRAL.methyladi_pimelate),
           "Negative MetRS weight (−4.50)"),
  make_row("2-Aminoisobutyric acid (BAIBA)",
           fmt_ms(df$HILIC.aminoisobutyric_acid, 3), n_avail(df$HILIC.aminoisobutyric_acid),
           "Positive MetRS weight (+6.29)"),
  make_row("Arginine",
           fmt_ms(df$HILIC.arginine, 3), n_avail(df$HILIC.arginine),
           "Positive MetRS weight (+5.85)"),
  make_row("Hydroxyproline",
           fmt_ms(df$HILIC.cis_trans_hydroxyproline, 3),
           n_avail(df$HILIC.cis_trans_hydroxyproline),
           "Negative MetRS weight (−4.30)"),
  make_row("N-carbamoyl-beta-alanine",
           fmt_ms(df$HILIC.n_carbamoyl_b_alanine, 3),
           n_avail(df$HILIC.n_carbamoyl_b_alanine),
           "Negative MetRS weight (−2.74)"),
  make_row("Serine",
           fmt_ms(df$HILIC.serine, 3), n_avail(df$HILIC.serine),
           "Positive MetRS weight (+3.81)"),
  make_row("Kynurenine",
           fmt_ms(df$CENTRAL.kynurenine, 3), n_avail(df$CENTRAL.kynurenine),
           "Positive MetRS weight (+9.24)"),
  make_row("Malate",
           fmt_ms(df$CENTRAL.malate, 3), n_avail(df$CENTRAL.malate),
           "Positive MetRS weight (+4.99)")
)

# ── Build Excel workbook (transcribed_table style) ────────────────────────────
# Style spec: font 15, no background fills, bold headers + section labels only,
# col A left-aligned, cols B-D center-aligned, black font, no alternating colors.
wb = createWorkbook()
addWorksheet(wb, "FHS Cohort Summary")

FS = 15  # global font size matching reference table

# Base styles
left_sty    = createStyle(fontSize = FS, halign = "left",   wrapText = FALSE)
center_sty  = createStyle(fontSize = FS, halign = "center", wrapText = FALSE)
bold_left   = createStyle(fontSize = FS, halign = "left",   textDecoration = "bold")
bold_center = createStyle(fontSize = FS, halign = "center", textDecoration = "bold")
foot_sty    = createStyle(fontSize = 11, fontColour = "#595959",
                          textDecoration = "italic", wrapText = TRUE)

# Column headers (row 1): bold, centered for value cols
header_row = 1
writeData(wb, "FHS Cohort Summary",
          data.frame(
            Characteristic = " ",
            Value          = sprintf("FHS (N = %d)", N),
            N_available    = "N with data",
            Note           = "Source / Note"
          ),
          startRow = header_row, startCol = 1, colNames = FALSE)
addStyle(wb, "FHS Cohort Summary", bold_left,
         rows = header_row, cols = 1, gridExpand = TRUE)
addStyle(wb, "FHS Cohort Summary", bold_center,
         rows = header_row, cols = 2:4, gridExpand = TRUE)

# Data rows
section_rows = which(rows$Value == "" & rows$N_available == "")
data_row = header_row + 1

for (i in seq_len(nrow(rows))) {
  r = rows[i, ]
  writeData(wb, "FHS Cohort Summary", r,
            startRow = data_row, startCol = 1, colNames = FALSE)

  if (i %in% section_rows) {
    # Section label: bold left, all cols
    addStyle(wb, "FHS Cohort Summary", bold_left,
             rows = data_row, cols = 1:4, gridExpand = TRUE)
  } else {
    addStyle(wb, "FHS Cohort Summary", left_sty,
             rows = data_row, cols = 1, gridExpand = TRUE)
    addStyle(wb, "FHS Cohort Summary", center_sty,
             rows = data_row, cols = 2:3, gridExpand = TRUE)
    addStyle(wb, "FHS Cohort Summary",
             createStyle(fontSize = 11, halign = "left",
                         fontColour = "#666666", wrapText = TRUE),
             rows = data_row, cols = 4, gridExpand = TRUE)
  }
  data_row = data_row + 1
}

# Footnotes
foot_row = data_row + 1
footnotes = c(
  "Values are mean ± SD unless noted otherwise.",
  "GWAS model covariates: sex, age, PC1–PC10 (10 ancestry principal components).",
  "Metabolite values are inverse-normal transformed (Exam 5 Rhee et al. dataset).",
  "BMI: Exam 5 = ~1991–1995 (metabolomics baseline); Exam 7 = ~1998–2001 (follow-up).",
  "DM/CVD case status: from pht002343 (Exam 5 metabolomics subset, n=671 matched).",
  "MetRS weights: derived from LABS-2 LASSO model (Supplement Table 2).",
  paste("Generated:", Sys.Date(), "| Script: tables/make_fhs_cohort_summary.R")
)

for (j in seq_along(footnotes)) {
  writeData(wb, "FHS Cohort Summary", footnotes[j],
            startRow = foot_row + j - 1, startCol = 1)
  addStyle(wb, "FHS Cohort Summary", foot_sty,
           rows = foot_row + j - 1, cols = 1)
  mergeCells(wb, "FHS Cohort Summary",
             rows = foot_row + j - 1, cols = 1:4)
}

setColWidths(wb, "FHS Cohort Summary", cols = 1, widths = 40)
setColWidths(wb, "FHS Cohort Summary", cols = 2, widths = 22)
setColWidths(wb, "FHS Cohort Summary", cols = 3, widths = 13)
setColWidths(wb, "FHS Cohort Summary", cols = 4, widths = 48)

saveWorkbook(wb, "FHS_cohort_summary.xlsx", overwrite = TRUE)

message(sprintf("Done. FHS_cohort_summary.xlsx saved (%d data rows).", nrow(rows)))

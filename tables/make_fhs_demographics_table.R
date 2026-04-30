library(dplyr)
library(openxlsx)

fhs = read.table("data/FHS_EA_phenotype.txt", header = TRUE, sep = " ", na.strings = "NA") %>%
  mutate(Sex = factor(sex, levels = c(1, 2), labels = c("Male", "Female")))

# ── helper functions ────────────────────────────────────────────────────────
fmt_mean_sd = function(x) {
  x = x[!is.na(x)]
  sprintf("%.1f (%.1f)", mean(x), sd(x))
}

fmt_n_pct = function(x, total) sprintf("%d (%.1f%%)", x, 100 * x / total)

ttest_p = function(x, grp) {
  x_m = x[grp == "Male"   & !is.na(x)]
  x_f = x[grp == "Female" & !is.na(x)]
  if (length(x_m) < 2 || length(x_f) < 2) return(NA_real_)
  t.test(x_m, x_f)$p.value
}

fmt_p = function(p) {
  if (is.na(p)) return("")
  if (p < 0.001) return("<0.001")
  sprintf("%.3f", p)
}

# ── compute rows ────────────────────────────────────────────────────────────
make_row = function(label, overall_val, male_val, female_val, p_val = "") {
  data.frame(
    Characteristic   = label,
    Overall          = overall_val,
    Male             = male_val,
    Female           = female_val,
    P_value          = p_val,
    stringsAsFactors = FALSE
  )
}

N_all  = nrow(fhs)
N_male = sum(fhs$Sex == "Male")
N_fem  = sum(fhs$Sex == "Female")

rows = bind_rows(
  # Header row
  make_row(
    sprintf("N = %d", N_all),
    sprintf("N = %d", N_all),
    sprintf("N = %d", N_male),
    sprintf("N = %d", N_fem),
    ""
  ),
  # Sex
  make_row(
    "Sex, Female — n (%)",
    fmt_n_pct(N_fem, N_all),
    "—",
    "—",
    "—"
  ),
  # Age
  make_row(
    "Age, years — mean (SD)",
    fmt_mean_sd(fhs$age),
    fmt_mean_sd(fhs$age[fhs$Sex == "Male"]),
    fmt_mean_sd(fhs$age[fhs$Sex == "Female"]),
    fmt_p(ttest_p(fhs$age, fhs$Sex))
  ),
  # BMI baseline (Exam 5)
  make_row(
    "BMI at Exam 5 (baseline), kg/m² — mean (SD)",
    fmt_mean_sd(fhs$BMI5),
    fmt_mean_sd(fhs$BMI5[fhs$Sex == "Male"]),
    fmt_mean_sd(fhs$BMI5[fhs$Sex == "Female"]),
    fmt_p(ttest_p(fhs$BMI5, fhs$Sex))
  ),
  # BMI follow-up (Exam 7)
  make_row(
    sprintf("BMI at Exam 7 (follow-up), kg/m² — mean (SD) [n = %d]",
            sum(!is.na(fhs$BMI7))),
    fmt_mean_sd(fhs$BMI7),
    fmt_mean_sd(fhs$BMI7[fhs$Sex == "Male"]),
    fmt_mean_sd(fhs$BMI7[fhs$Sex == "Female"]),
    fmt_p(ttest_p(fhs$BMI7, fhs$Sex))
  ),
  # Delta BMI
  make_row(
    sprintf("ΔBMI (Exam 7 − Exam 5), kg/m² — mean (SD) [n = %d]",
            sum(!is.na(fhs$delta_bmi))),
    fmt_mean_sd(fhs$delta_bmi),
    fmt_mean_sd(fhs$delta_bmi[fhs$Sex == "Male"]),
    fmt_mean_sd(fhs$delta_bmi[fhs$Sex == "Female"]),
    fmt_p(ttest_p(fhs$delta_bmi, fhs$Sex))
  ),
  # MetRS
  make_row(
    "Metabolite Risk Score (MetRS) — mean (SD)",
    fmt_mean_sd(fhs$MRS),
    fmt_mean_sd(fhs$MRS[fhs$Sex == "Male"]),
    fmt_mean_sd(fhs$MRS[fhs$Sex == "Female"]),
    fmt_p(ttest_p(fhs$MRS, fhs$Sex))
  )
)

# ── print to console ────────────────────────────────────────────────────────
cat("\nTable 1. FHS GWAS Validation Cohort — Participant Characteristics\n")
cat(rep("-", 110), "\n", sep = "")
print(rows, row.names = FALSE)
cat(rep("-", 110), "\n", sep = "")
cat("P-values from two-sample t-test (Male vs Female).\n\n")

# ── write CSV ───────────────────────────────────────────────────────────────
write.csv(rows, "Table1_FHS_demographics.csv", row.names = FALSE, quote = FALSE)

# ── write formatted Excel ────────────────────────────────────────────────────
wb = createWorkbook()
addWorksheet(wb, "Table1")

title_style = createStyle(fontSize = 12, textDecoration = "bold", wrapText = TRUE)
header_style = createStyle(
  fontSize = 11, textDecoration = "bold",
  fgFill = "#D9E1F2", border = "TopBottom",
  borderColour = "#2F5496", halign = "center", wrapText = TRUE
)
row1_style  = createStyle(fontSize = 10, fgFill = "#F2F2F2", wrapText = TRUE)
row2_style  = createStyle(fontSize = 10, fgFill = "#FFFFFF",  wrapText = TRUE)
center_style = createStyle(halign = "center", fontSize = 10)

writeData(wb, "Table1",
          "Table 1. FHS GWAS Validation Cohort — Participant Characteristics",
          startRow = 1, startCol = 1)
addStyle(wb, "Table1", title_style, rows = 1, cols = 1)
mergeCells(wb, "Table1", rows = 1, cols = 1:5)

writeData(wb, "Table1", rows, startRow = 3, startCol = 1, colNames = TRUE)
addStyle(wb, "Table1", header_style, rows = 3, cols = 1:5, gridExpand = TRUE)

row1_center = createStyle(fontSize = 10, fgFill = "#F2F2F2",
                          halign = "center", wrapText = TRUE)
row2_center = createStyle(fontSize = 10, fgFill = "#FFFFFF",
                          halign = "center", wrapText = TRUE)

for (i in seq_len(nrow(rows))) {
  sty       = if (i %% 2 == 1) row1_style  else row2_style
  sty_ctr   = if (i %% 2 == 1) row1_center else row2_center
  addStyle(wb, "Table1", sty,     rows = 3 + i, cols = 1,   gridExpand = TRUE)
  addStyle(wb, "Table1", sty_ctr, rows = 3 + i, cols = 2:5, gridExpand = TRUE)
}

setColWidths(wb, "Table1", cols = 1,   widths = 55)
setColWidths(wb, "Table1", cols = 2:5, widths = 22)

footnote_row = 3 + nrow(rows) + 2
writeData(wb, "Table1",
          "P-values from two-sample t-test (Male vs Female). BMI = body mass index. MetRS = Metabolite Risk Score computed from 10 pre-specified metabolites.",
          startRow = footnote_row, startCol = 1)
addStyle(wb, "Table1",
         createStyle(fontSize = 9, fontColour = "#595959", wrapText = TRUE),
         rows = footnote_row, cols = 1)
mergeCells(wb, "Table1", rows = footnote_row, cols = 1:5)

saveWorkbook(wb, "Table1_FHS_demographics.xlsx", overwrite = TRUE)

message("Done. Outputs saved:\n  Table1_FHS_demographics.csv\n  Table1_FHS_demographics.xlsx")

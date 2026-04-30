library(openxlsx)

# ── GWAS genome-wide significant hits (p < 5e-8) from FHS EA GWAS ─────────────
# Source: met_final merged stats on Narrows cluster (/salemlab/users/wanjun/met_final/merged_stats/)
# Top hit per phenotype extracted with Python; gene/rsID annotated via Ensembl GRCh37 REST API.
# Chromosome positions are GRCh37/hg19.
# rsIDs for non-BAIBA metabolites cross-referenced from reference table (table screenshot.png).
# rs37376 (BAIBA/MRS locus) confirmed via Ensembl: chr5:35044716, alleles G/A/C, intron_variant in AGXT2.

hits = data.frame(
  Metabolite = c(
    "N-carbamoyl-β-alanine",
    "BAIBA (2-aminoisobutyric acid)",
    "MetRS",
    "C34:2 PC",
    "Glucuronate",
    "Kynurenine",
    "Hippurate"
  ),
  Chromosomal_Position_hg19 = c(
    "chr3:g.161361793A>C",
    "chr5:g.35044716G>C",
    "chr5:g.35044716G>C",
    "chr11:g.61603510C>A",
    "chr13:g.86072971C>T",
    "chr16:g.87883089C>T",
    "chr21:g.44802152C>T"
  ),
  Gene = c(
    "Intergenic",
    "AGXT2",
    "AGXT2",
    "FADS2",
    "LINC00351",
    "SLC7A5",
    "Intergenic"
  ),
  Variant_Type = c(
    "Intergenic",
    "Intron",
    "Intron",
    "Intron",
    "Intron; nc",
    "Intron",
    "Intergenic"
  ),
  Variant_Consequence = c(
    "INTERGENIC",
    "INTRONIC",
    "INTRONIC",
    "INTRONIC",
    "INTRONIC",
    "INTRONIC",
    "INTERGENIC"
  ),
  RSID = c(
    "rs182678014",
    "rs37376",
    "rs37376",
    "rs174576",
    "rs9594030",
    "rs2926829",
    "rs11638208"
  ),
  BETA_SE = c(
    "-0.823 (0.147)",
    "-1.045 (0.062)",
    "-6.603 (0.956)",
    "0.279 (0.040)",
    "-0.563 (0.102)",
    "0.243 (0.043)",
    "1.685 (0.296)"
  ),
  P_value = c(
    "2.29×10⁻⁸",
    "4.77×10⁻⁶⁴",
    "4.88×10⁻¹²",
    "1.85×10⁻¹²",
    "3.22×10⁻⁸",
    "1.64×10⁻⁸",
    "1.32×10⁻⁸"
  ),
  Disease_Association = c(
    "—",
    "BAIBA plasma levels; beta-alanine metabolism",
    "—",
    "Fatty acid desaturase family",
    "Waist circumference (BMI adjusted)",
    "Type 2 diabetes",
    "—"
  ),
  stringsAsFactors = FALSE
)

# ── Build Excel workbook ───────────────────────────────────────────────────────
wb = createWorkbook()
addWorksheet(wb, "GWAS Hits")

FS = 11  # body font size

title_sty = createStyle(
  fontSize     = 13,
  textDecoration = "bold",
  wrapText     = FALSE
)

header_sty = createStyle(
  fontSize       = FS,
  textDecoration = "bold",
  halign         = "center",
  valign         = "center",
  fgFill         = "#D9E1F2",
  border         = "TopBottom",
  borderColour   = "#2F5496",
  wrapText       = TRUE
)

body_left = createStyle(
  fontSize = FS,
  halign   = "left",
  valign   = "center",
  wrapText = TRUE,
  border   = "TopBottomLeftRight",
  borderColour = "#BFBFBF"
)

body_center = createStyle(
  fontSize = FS,
  halign   = "center",
  valign   = "center",
  wrapText = TRUE,
  border   = "TopBottomLeftRight",
  borderColour = "#BFBFBF"
)

body_mono = createStyle(
  fontSize = FS,
  fontName = "Courier New",
  halign   = "left",
  valign   = "center",
  wrapText = FALSE,
  border   = "TopBottomLeftRight",
  borderColour = "#BFBFBF"
)

foot_sty = createStyle(
  fontSize     = 9,
  fontColour   = "#595959",
  textDecoration = "italic",
  wrapText     = TRUE
)

# Title
writeData(wb, "GWAS Hits",
          "Table. Genome-wide significant loci (p < 5×10⁻⁸) from FHS GWAS (N = 1,613 European-ancestry individuals)",
          startRow = 1, startCol = 1)
addStyle(wb, "GWAS Hits", title_sty, rows = 1, cols = 1)
mergeCells(wb, "GWAS Hits", rows = 1, cols = 1:9)

# Column headers (row 3)
col_headers = data.frame(
  Metabolite           = "Metabolite",
  Chromosomal_Position = "Chromosomal position (hg19)",
  Gene                 = "Gene",
  Variant_Type         = "Variant type",
  Variant_Consequence  = "Variant consequence",
  RSID                 = "RSID",
  BETA_SE              = "BETA (SE)",
  P_value              = "P-value",
  Disease_Association  = "Disease association",
  stringsAsFactors     = FALSE
)
writeData(wb, "GWAS Hits", col_headers, startRow = 3, startCol = 1, colNames = FALSE)
addStyle(wb, "GWAS Hits", header_sty, rows = 3, cols = 1:9, gridExpand = TRUE)

# Data rows
for (i in seq_len(nrow(hits))) {
  r = hits[i, ]
  writeData(wb, "GWAS Hits", r, startRow = 3 + i, startCol = 1, colNames = FALSE)

  # Col 1: metabolite name — left
  addStyle(wb, "GWAS Hits", body_left,   rows = 3 + i, cols = 1,     gridExpand = TRUE)
  # Col 2: position — monospace left
  addStyle(wb, "GWAS Hits", body_mono,   rows = 3 + i, cols = 2,     gridExpand = TRUE)
  # Cols 3-6: gene, type, consequence, rsid — center
  addStyle(wb, "GWAS Hits", body_center, rows = 3 + i, cols = 3:6,   gridExpand = TRUE)
  # Col 7-8: beta, p-value — center
  addStyle(wb, "GWAS Hits", body_center, rows = 3 + i, cols = 7:8,   gridExpand = TRUE)
  # Col 9: disease — left
  addStyle(wb, "GWAS Hits", body_left,   rows = 3 + i, cols = 9,     gridExpand = TRUE)
}

# Footnotes
foot_row = 3 + nrow(hits) + 2
footnotes = c(
  "GWAS model: SAIGE mixed model; covariates = sex, age, PC1–PC10 (10 ancestry PCs). Autosomes N=1,613; chrX N=742.",
  "Only the top hit per phenotype (lowest p-value genome-wide) is shown. BAIBA hits on chr12 (rs11605023, rs4762 loci) not shown.",
  "Gene annotation via Ensembl GRCh37 REST API. Variant consequence per Ensembl VEP terminology.",
  "rsIDs for glucuronate, hippurate, kynurenine, N-carbamoyl-β-alanine, and C34:2 PC cross-referenced from reference table.",
  "rs37376 (BAIBA/MetRS locus) is a multiallelic variant in AGXT2 (alleles G/A/C); G>C coding used here per SAIGE output.",
  "BETA: effect of the effect allele (EA) on inverse-normal transformed metabolite or MetRS. MetRS = 10-metabolite LASSO score.",
  paste("Generated:", Sys.Date(), "| Script: tables/make_gwas_hits_table.R")
)

for (j in seq_along(footnotes)) {
  writeData(wb, "GWAS Hits", footnotes[j], startRow = foot_row + j - 1, startCol = 1)
  addStyle(wb, "GWAS Hits",  foot_sty, rows = foot_row + j - 1, cols = 1)
  mergeCells(wb, "GWAS Hits", rows = foot_row + j - 1, cols = 1:9)
}

# Column widths
setColWidths(wb, "GWAS Hits", cols = 1, widths = 26)   # Metabolite
setColWidths(wb, "GWAS Hits", cols = 2, widths = 24)   # Position
setColWidths(wb, "GWAS Hits", cols = 3, widths = 12)   # Gene
setColWidths(wb, "GWAS Hits", cols = 4, widths = 14)   # Variant type
setColWidths(wb, "GWAS Hits", cols = 5, widths = 18)   # Consequence
setColWidths(wb, "GWAS Hits", cols = 6, widths = 13)   # RSID
setColWidths(wb, "GWAS Hits", cols = 7, widths = 17)   # BETA (SE)
setColWidths(wb, "GWAS Hits", cols = 8, widths = 13)   # P-value
setColWidths(wb, "GWAS Hits", cols = 9, widths = 38)   # Disease

# Row heights
setRowHeights(wb, "GWAS Hits", rows = 1,        heights = 22)
setRowHeights(wb, "GWAS Hits", rows = 3,        heights = 30)
setRowHeights(wb, "GWAS Hits", rows = 4:(3 + nrow(hits)), heights = rep(30, nrow(hits)))

saveWorkbook(wb, "tables/FHS_GWAS_significant_hits.xlsx", overwrite = TRUE)
message(sprintf("Done. tables/FHS_GWAS_significant_hits.xlsx saved (%d rows).", nrow(hits)))

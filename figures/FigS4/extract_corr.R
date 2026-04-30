# extract_corr.R
# Extracts 62x62 Pearson correlation matrix from /tmp/figs4_hires.png
# using calibrated grid parameters, then saves wide and long CSVs.

library(png)

# ── 0. Metabolite names ────────────────────────────────────────────────────────
met_names = c(
  "c34_3_pe_plasmalogen","c36_3_pe_plasmalogen","c36_2_pc_plasmalogen",
  "c34_2_pc","c18_2_lpe","c18_2_lpc","c18_1_lpe","c18_0_lpc","c18_1_lpc",
  "c36_2_pe","c36_4_pc","c34_3_pe","c32_2_pe","c36_1_pe",
  "c48_4_tag","c48_5_tag","c46_3_tag","c46_4_tag","c50_5_tag","c50_6_tag",
  "c34_0_ps","c36_5_pc_plasmalogen","c44_0_tag","c42_0_tag","c44_1_tag",
  "c44_2_tag","c45_2_tag","c43_1_tag","c45_0_tag","c43_0_tag","c54_1_tag",
  "proline","kynurenine","x15_hete","x13_hode","x2_hydroxyglutarate",
  "amp","lactate","methyladipate_pimelate","dmgv","n_acetylputrescine",
  "x4_acetamidobutanoate","glucuronate","l_carbamoyl_beta_alanine",
  "adonitol_arabitol","n2_dimethylguanosine","x3_hydroxymethylglutarate",
  "x2_hydroxyoctanoate","hydroxyproline","phenyllactate","x4_hydroxystyrene",
  "x4_hydroxyhippurate","trigonelline","x3_methyladipate","arachidate",
  "caprate","x2_aminobutyrate","gaba","x2_aminoisobutyric_acid",
  "c20_4_ce","malonate","valerate_methylbutyrate"
)

pretty_names = c(
  "PE 34:3 plasmalogen","PE 36:3 plasmalogen","PC 36:2 plasmalogen",
  "PC 34:2","LPE 18:2","LPC 18:2","LPE 18:1","LPC 18:0","LPC 18:1",
  "PE 36:2","PC 36:4","PE 34:3","PE 32:2","PE 36:1",
  "TAG 48:4","TAG 48:5","TAG 46:3","TAG 46:4","TAG 50:5","TAG 50:6",
  "PS 34:0","PC 36:5 plasmalogen","TAG 44:0","TAG 42:0","TAG 44:1",
  "TAG 44:2","TAG 45:2","TAG 43:1","TAG 45:0","TAG 43:0","TAG 54:1",
  "Proline","Kynurenine","15-HETE","13-HODE","2-Hydroxyglutarate",
  "AMP","Lactate","3-Methyladipate/Pimelate","DMGV","N-Acetylputrescine",
  "4-Acetamidobutanoate","Glucuronate","L-Carbamoyl-β-Alanine",
  "Adonitol/Arabitol","N2-Dimethylguanosine","3-Hydroxymethylglutarate",
  "2-Hydroxyoctanoate","Hydroxyproline","Phenyllactate","4-Hydroxystyrene",
  "4-Hydroxyhippurate","Trigonelline","3-Methyladipate","Arachidate",
  "Caprate","2-Aminobutyrate","GABA","2-Aminoisobutyric Acid",
  "CE 20:4","Malonate","Valerate/Methylbutyrate"
)

N = 62

# ── 1. Load image ─────────────────────────────────────────────────────────────
cat("Loading image...\n")
img = readPNG("/tmp/figs4_hires.png")   # array [row, col, channel], values 0-1
img_rows = nrow(img)
img_cols = ncol(img)
cat(sprintf("Image dimensions: %d rows x %d cols x %d channels\n",
            img_rows, img_cols, dim(img)[3]))

# Helper: safe pixel reader (clamps to image bounds)
px = function(r, c) {
  r = max(1, min(img_rows, round(r)))
  c = max(1, min(img_cols, round(c)))
  img[r, c, 1:3]   # r, g, b
}

# ── 2. Build legend lookup table (TASK 1) ─────────────────────────────────────
# Calibrated from pixel analysis:
# Top (corr=+1.0): row 580, bright red  R=0.984 G=0.859 B=0.863
# Bottom (corr=-1.0): row 1113, bright blue  R=0.788 G=0.847 B=1.000
# Legend column: 1900
cat("Building legend lookup table...\n")
leg_col       = 1900
leg_row_top   = 580    # corr = +1.0
leg_row_bottom = 1113  # corr = -1.0

legend_rows  = leg_row_top:leg_row_bottom
legend_corrs = 1.0 - 2.0 * (legend_rows - leg_row_top) / (leg_row_bottom - leg_row_top)
legend_rgb   = t(sapply(legend_rows, function(r) px(r, leg_col)))   # nrow x 3

# Function: map rgb triple -> correlation via nearest-neighbor in legend
rgb_to_corr = function(rgb_vec) {
  dists = rowSums((legend_rgb - matrix(rgb_vec, nrow=nrow(legend_rgb), ncol=3, byrow=TRUE))^2)
  legend_corrs[which.min(dists)]
}

# ── 3. Grid calibration ───────────────────────────────────────────────────────
# Row centers calibrated from image (provided in specification):
band_centers = c(51,71,92,112,132,152,172,192,213,233,253,273,293,314,334,354,
                 374,394,414,435,455,475,496,516,536,556,576,596,617,637,657,
                 677,698,718,738,758,778,798,819,839,859,879,900,920,940,960,
                 980,1000,1021,1041,1061,1081,1101,1122,1142,1162,1182,1202,
                 1223,1243,1263,1283)

# Column center formula calibrated from diagonal pixel analysis:
# j=1 rightmost (col center ~1746), j=62 leftmost (col center ~515)
# col_width = (1746-515)/61 = 20.18 px/cell
col_center = function(j) round(1766 - 20.18 * j)

# ── 4. Background detection ───────────────────────────────────────────────────
# Background gray: R=G=B ~0.92, maxdiff ~0
# Colored cells (any correlation value): maxdiff >= 0.015  OR  mean >= 0.95
#   - Strongly colored (red/orange/blue): low mean but high maxdiff
#   - Near-zero corr (near-white): mean ~0.97-1.0, tiny maxdiff, but mean >= 0.95
# Combined rule: background = mean < 0.95 AND maxdiff < 0.015

is_background = function(rgb_vec) {
  mn      = mean(rgb_vec)
  maxdiff = max(abs(rgb_vec - mn))
  mn < 0.95 & maxdiff < 0.015
}

# ── 5. Extract upper-triangle correlations (TASK 2) ───────────────────────────
cat("Extracting correlation matrix...\n")
corr_mat = matrix(NA_real_, nrow=N, ncol=N)
diag(corr_mat) = 1.0

n_bg  = 0
n_col = 0

for (i in 2:N) {
  for (j in 1:(i-1)) {
    r = band_centers[i]
    c = col_center(j)
    rgb_vec = px(r, c)
    if (is_background(rgb_vec)) {
      n_bg = n_bg + 1
    } else {
      val = rgb_to_corr(rgb_vec)
      corr_mat[i, j] = val
      corr_mat[j, i] = val
      n_col = n_col + 1
    }
  }
}

n_expected = N*(N-1)/2
cat(sprintf("Background (NA): %d / %d  (%.1f%%)\n", n_bg, n_expected, 100*n_bg/n_expected))
cat(sprintf("Extracted:       %d / %d  (%.1f%%)\n", n_col, n_expected, 100*n_col/n_expected))

# ── 6. Save wide matrix ───────────────────────────────────────────────────────
out_dir = "/Users/wanjun/Desktop/GastricBypass/figures/FigS4"
rownames(corr_mat) = met_names
colnames(corr_mat) = met_names

write.csv(corr_mat,
          file = file.path(out_dir, "data_corr_matrix.csv"),
          row.names = TRUE)
cat("Saved data_corr_matrix.csv\n")

# ── 7. Save long format ───────────────────────────────────────────────────────
rows_long = list()
for (i in seq_len(N - 1)) {
  for (j in (i+1):N) {
    rows_long[[length(rows_long)+1]] = data.frame(
      met1         = met_names[i],
      met2         = met_names[j],
      corr         = corr_mat[i, j],
      pretty_name1 = pretty_names[i],
      pretty_name2 = pretty_names[j],
      stringsAsFactors = FALSE
    )
  }
}
long_df = do.call(rbind, rows_long)

write.csv(long_df,
          file = file.path(out_dir, "data_corr_long.csv"),
          row.names = FALSE)
cat("Saved data_corr_long.csv\n")

# ── 8. Diagnostics ────────────────────────────────────────────────────────────
vals = corr_mat[upper.tri(corr_mat)]
vals_noNA = vals[!is.na(vals)]
cat(sprintf("\nExtracted correlation range: min=%.3f  max=%.3f  mean=%.3f\n",
            min(vals_noNA), max(vals_noNA), mean(vals_noNA)))
cat(sprintf("NAs in upper triangle: %d\n", sum(is.na(vals))))
cat("\nDone.\n")

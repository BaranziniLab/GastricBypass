###########################
# Author: Wanjun Gu
# Email: wanjun.gu@ucsf.edu
# Date: 2026-03-31
###########################

library(grid)
library(forestploter)

# Build display table with model-group header rows
dt = data.frame(
  Variable = c(
    "Model 1",
    "   Age", "   Baseline EBW", "   Sex",
    "Model 2",
    "   MetRS (per SD)",
    "Model 3",
    "   Baseline EBW", "   MetRS (per SD)",
    "Model 4",
    "   Age", "   Baseline EBW", "   Sex", "   MetRS (per SD)"
  ),
  est = c(
    NA,
    1.00, 1.20, 1.10,
    NA,
    2.80,
    NA,
    1.00, 2.60,
    NA,
    1.00, 1.10, 1.55, 2.75
  ),
  lo = c(
    NA,
    0.85, 1.05, 0.45,
    NA,
    1.70,
    NA,
    0.90, 1.55,
    NA,
    0.85, 1.00, 0.45, 1.55
  ),
  hi = c(
    NA,
    1.10, 1.35, 2.65,
    NA,
    4.20,
    NA,
    1.10, 3.80,
    NA,
    1.10, 1.25, 3.30, 4.30
  ),
  is_header = c(
    TRUE,
    FALSE, FALSE, FALSE,
    TRUE,
    FALSE,
    TRUE,
    FALSE, FALSE,
    TRUE,
    FALSE, FALSE, FALSE, FALSE
  ),
  stringsAsFactors = FALSE
)

# CI text column (blank for header rows)
dt$`OR (95% CI)` = ifelse(
  dt$is_header, "",
  sprintf("%.2f (%.2f to %.2f)", dt$est, dt$lo, dt$hi)
)

# Blank column: wider spacing gives more room for CI bars
dt$` ` = paste(rep(" ", 22), collapse = " ")

tm = forest_theme(
  base_size      = 11,
  ci_pch         = 15,
  ci_col         = "#0072B2",
  ci_fill        = "#0072B2",
  ci_alpha       = 0.9,
  ci_lwd         = 1.8,
  ci_Theight     = 0.2,
  refline_gp     = gpar(lwd = 1, lty = "dashed", col = "grey50"),
  summary_fill   = "#222222",
  summary_col    = "#222222",
  core = list(padding = unit(c(3, 4), "mm"))
)

p = forest(
  dt[, c("Variable", "OR (95% CI)", " ")],
  est        = dt$est,
  lower      = dt$lo,
  upper      = dt$hi,
  sizes      = 0.45,
  ci_column  = 3,
  ref_line   = 1,
  x_trans    = "log",
  xlim       = c(0.25, 6),
  ticks_at   = c(0.5, 1, 2, 4),
  xlab       = "Odds Ratio (log scale)",
  is_summary = dt$is_header,
  theme      = tm
)

# Auto-size output to avoid clipping
p_wh = get_wh(plot = p, unit = "in")

png("fig3d.png", res = 300, width = max(p_wh[1], 7), height = max(p_wh[2], 5), units = "in")
plot(p)
dev.off()

pdf("Fig3d_forest_plot.pdf", width = max(p_wh[1], 7), height = max(p_wh[2], 5))
plot(p)
dev.off()

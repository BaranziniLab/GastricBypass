library(ggplot2)
library(data.table)
library(here)
setwd(here::here("figures/Fig4defg"))

dt = fread("data/FHS_EA_LIPID.C34_2_PC_merged.txt",
           select = c("CHR", "POS", "P_gc"))
dt = dt[!is.na(P_gc) & P_gc > 0]
dt[, CHR := fcase(CHR == "X", 23L, rep(TRUE, .N), suppressWarnings(as.integer(CHR)))]
dt = dt[!is.na(CHR)]
dt = dt[order(CHR, POS)]

# Cumulative genomic positions
chr_info = dt[, .(chr_len = max(POS)), by = CHR][order(CHR)]
chr_info[, cum_start := cumsum(shift(as.numeric(chr_len), fill = 0))]
dt = chr_info[, .(CHR, cum_start)][dt, on = "CHR"]
dt[, bp_cum := as.numeric(POS) + cum_start]
dt[, log10p := -log10(P_gc)]

# Chromosome axis tick positions
axis_df = dt[, .(center = (min(bp_cum) + max(bp_cum)) / 2), by = CHR][order(CHR)]

# Alternating black / gray per chromosome
dt[, dot_color := ifelse(CHR %% 2 == 1, "black", "gray60")]

sig_5e8  = -log10(5e-8)
sig_1e5  = -log10(1e-5)

p = ggplot(dt, aes(x = bp_cum, y = log10p, color = dot_color)) +
  geom_point(size = 2, alpha = 0.7, stroke = 0) +
  geom_hline(yintercept = sig_1e5, linetype = "dashed", color = "gray50", linewidth = 0.7) +
  geom_hline(yintercept = sig_5e8, linetype = "dashed", color = "black", linewidth = 0.7) +
  scale_color_identity() +
  scale_x_continuous(
    breaks = axis_df$center,
    labels = ifelse(axis_df$CHR == 23, "X", as.character(axis_df$CHR)),
    expand = c(0.01, 0)
  ) +
  scale_y_continuous(
    expand = expansion(mult = c(0, 0.08)),
    limits = c(0, NA)
  ) +
  labs(
    x = "Chromosomal Position",
    y = expression(-log[10](p))
  ) +
  theme_classic(base_size = 18) +
  theme(
    axis.line   = element_line(linewidth = 0.8),
    axis.text.x = element_text(size = 12),
    panel.grid  = element_blank()
  )

ggsave("fig4g_c34_2_pc_manhattan.png", p, width = 15, height = 3.5, dpi = 800, bg = "white")

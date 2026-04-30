# make_plot.R  —  FigS4: Upper-triangle Pearson correlation heatmap (62 metabolites)
# Working directory: figures/FigS4/

library(ggplot2)
library(dplyr)
library(here)

# ── 1. Metabolite level order (row/col display order, met 1 → 62) ─────────────
met_levels = c(
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

pretty_levels = c(
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

# ── 2. Load data ──────────────────────────────────────────────────────────────
setwd(here::here("figures", "FigS4"))

long = read.csv("data_corr_long.csv", stringsAsFactors = FALSE)

# ── 3. Apply factor levels and pretty labels ──────────────────────────────────
# Map met_names -> pretty_names via lookup
pretty_map = setNames(pretty_levels, met_levels)

long = long |>
  mutate(
    met1 = factor(met1, levels = met_levels),
    met2 = factor(met2, levels = met_levels),
    label1 = pretty_map[as.character(met1)],
    label2 = pretty_map[as.character(met2)],
    label1 = factor(label1, levels = pretty_levels),
    label2 = factor(label2, levels = pretty_levels)
  )

# ── 4. Keep only upper triangle (i <= j, i.e., met1 order <= met2 order) ──────
long_upper = long |>
  filter(as.integer(met1) <= as.integer(met2)) |>
  filter(!is.na(corr))   # remove background (NA) cells

# ── 5. Build plot ─────────────────────────────────────────────────────────────
p = ggplot(long_upper, aes(x = label2, y = label1, fill = corr)) +
  geom_tile(color = NA) +
  scale_fill_gradient2(
    low     = "#0072B2",
    mid     = "white",
    high    = "#D55E00",
    midpoint = 0,
    limits  = c(-1, 1),
    na.value = "grey92"
  ) +
  scale_x_discrete(limits = rev(pretty_levels)) +
  scale_y_discrete(limits = rev(pretty_levels)) +
  coord_fixed() +
  labs(fill = "Corr") +
  theme_minimal(base_size = 15) +
  theme(
    axis.text.x  = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 6),
    axis.text.y  = element_text(size = 6),
    axis.title   = element_blank(),
    panel.grid   = element_blank()
  )

# ── 6. Save ───────────────────────────────────────────────────────────────────
ggsave("figs4.png", plot = p, width = 12, height = 10, dpi = 800, bg = "white")
message("Saved figs4.png")

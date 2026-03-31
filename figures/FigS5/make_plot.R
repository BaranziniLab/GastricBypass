library(ggplot2)

# Read pairwise correlation data
df = read.csv("data.csv", stringsAsFactors = FALSE)

# Define the ordered list of 54 metabolites as they appear in the figure
# (bottom-to-top on y-axis, left-to-right on x-axis)
metabolite_order = c(
  "serine", "histidine", "lysine", "leucine", "tryptophan", "proline",
  "hydroxyproline", "gaba", "x2_aminoisobutyric_acid", "histamine",
  "n_carbamoyl_beta_alanine", "x4_acetamidobutanoate", "x4_hydroxyhippurate",
  "bilirubin", "biliverdin", "dmgv", "hippurate", "homoarginine",
  "n2_n2_dimethylguanosine", "n6_n6_dimethyllysine", "n6_methyllysine",
  "n_acetylputrescine", "trigonelline", "x2_aminobutyrate",
  "x3_hydroxymethylglutarate", "x3_methyladipate_pimelate",
  "adonitol_arabitol", "amp", "glucuronate", "kynurenine", "lactate",
  "malonate", "c18_2_lpc", "c18_1_lpc", "c18_0_lpc", "c18_2_lpe",
  "c18_1_lpe", "c34_2_pc", "c36_4_pc_a", "c36_2_pc",
  "c36_3_pe_plasmalogen", "c42_0_tag", "c43_1_tag", "c45_2_tag",
  "c46_4_tag", "x13_hode", "x15_hete", "x2_hydroxyoctanoate", "caprate",
  "arachidate", "x3_methyladipate", "x4_hydroxystyrene", "alpha_cehc",
  "phenyllactate"
)

# Mirror the lower-triangle: keep only var1 index <= var2 index (lower triangle)
df$var1 = factor(df$var1, levels = metabolite_order)
df$var2 = factor(df$var2, levels = metabolite_order)

# Keep only lower-triangle entries (var1 index >= var2 index)
df = df[as.integer(df$var1) >= as.integer(df$var2), ]

# Humanize labels for axis display
humanize = function(x) {
  x = gsub("_", " ", x)
  x = gsub("^x(\\d)", "\\1", x)  # remove leading x from numeric names
  x
}

df$var1_label = humanize(as.character(df$var1))
df$var2_label = humanize(as.character(df$var2))

label_map = setNames(humanize(metabolite_order), metabolite_order)

p = ggplot(df, aes(x = var2, y = var1, fill = correlation)) +
  geom_tile(color = "grey90", linewidth = 0.15) +
  scale_fill_gradientn(
    colours = c("#2166AC", "#92C5DE", "#F7F7F7", "#F4A582", "#B2182B"),
    limits  = c(-1, 1),
    name    = "Pearson\nCorrelation",
    breaks  = c(-1.0, -0.5, 0.0, 0.5, 1.0)
  ) +
  scale_x_discrete(labels = label_map, position = "bottom") +
  scale_y_discrete(labels = label_map) +
  labs(
    x = NULL,
    y = NULL
  ) +
  coord_fixed() +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.x  = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 5),
    axis.text.y  = element_text(size = 5),
    panel.grid   = element_blank(),
    legend.title = element_text(size = 10),
    legend.text  = element_text(size = 9),
    plot.margin  = margin(5, 5, 5, 5)
  )

ggsave("plot.png", p, width = 5, height = 4, dpi = 800)

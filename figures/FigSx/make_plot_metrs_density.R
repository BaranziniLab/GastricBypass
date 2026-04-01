library(ggplot2)
library(svglite)

set.seed(42)
swl_scores = rnorm(200, mean = 0.35, sd = 0.85)
rgn_scores = rnorm(200, mean = -0.65, sd = 0.85)

df = data.frame(
  score = c(swl_scores, rgn_scores),
  group = factor(c(rep("SWL", 200), rep("RGN", 200)), levels = c("SWL", "RGN"))
)

group_colors = c("SWL" = "#0072B2", "RGN" = "#E69F00")

p = ggplot(df, aes(x = score, fill = group, color = group)) +
  geom_density(alpha = 0.4, linewidth = 0.9) +
  scale_fill_manual(
    values = group_colors,
    labels = c("SWL" = "Sustained Weight Loss", "RGN" = "Weight Regain"),
    name = NULL
  ) +
  scale_color_manual(
    values = group_colors,
    labels = c("SWL" = "Sustained Weight Loss", "RGN" = "Weight Regain"),
    name = NULL
  ) +
  scale_x_continuous(limits = c(-3, 3), breaks = seq(-3, 3, by = 1)) +
  scale_y_continuous(limits = c(0, 0.55), breaks = seq(0, 0.5, by = 0.1)) +
  labs(x = "Metabolite Risk Score", y = "Density") +
  theme_classic(base_size = 14) +
  theme(
    legend.position = c(0.80, 0.82),
    legend.background = element_rect(fill = "white", color = "grey80", linewidth = 0.4),
    axis.line = element_line(linewidth = 0.8)
  )

ggsave("figsx_metrs_density.svg", p, width = 5, height = 4)

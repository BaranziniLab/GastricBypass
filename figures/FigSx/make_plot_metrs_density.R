library(ggplot2)
library(RColorBrewer)

# Representative density curve data extracted from figure
# Two groups: SWL (Sustained Weight Loss) and RGN (Regain)
# RGN distribution is shifted left (lower scores), SWL is shifted right (higher scores)

# Simulate underlying data consistent with visible density curves
set.seed(42)
swl_scores = rnorm(200, mean = 0.35, sd = 0.85)
rgn_scores = rnorm(200, mean = -0.65, sd = 0.85)

df = data.frame(
  score = c(swl_scores, rgn_scores),
  class = factor(c(rep("SWL", 200), rep("RGN", 200)), levels = c("SWL", "RGN"))
)

# Colors matching figure: SWL = steel blue, RGN = sandy yellow
group_colors = c("SWL" = "#6BAED6", "RGN" = "#F4C97A")

p = ggplot(df, aes(x = score, fill = class, color = class)) +
  geom_density(alpha = 0.6, linewidth = 0.9) +
  scale_fill_manual(
    name = "Class",
    values = group_colors
  ) +
  scale_color_manual(
    name = "Class",
    values = c("SWL" = "#3182BD", "RGN" = "#B8860B")
  ) +
  scale_x_continuous(
    limits = c(-3, 3),
    breaks = seq(-3, 3, by = 1)
  ) +
  scale_y_continuous(
    limits = c(0, 0.5),
    breaks = seq(0, 0.4, by = 0.1)
  ) +
  labs(
    x = "Metabolite Risk Score",
    y = "density"
  ) +
  theme_classic(base_size = 14) +
  theme(
    legend.position = c(0.88, 0.80),
    legend.background = element_rect(fill = "white", color = "black", linewidth = 0.4),
    legend.key.size = unit(0.6, "cm"),
    axis.line = element_line(linewidth = 0.8)
  )

ggsave("plot_metrs_density.png", p, width = 5, height = 4, dpi = 800)

library(ggplot2)
library(RColorBrewer)

df = read.csv("data.csv", stringsAsFactors = FALSE)
df$group = factor(df$group, levels = c("Lean", "Obese"))

# Colors matching original: Lean = steel blue, Obese = burnt orange
group_colors = c("Lean" = "#4393C3", "Obese" = "#B5651D")
group_shapes = c("Lean" = 1, "Obese" = 2)  # circle (open), triangle (open)

p = ggplot(df, aes(x = xvar1, y = xvar2, color = group, shape = group)) +
  geom_point(size = 2.5, alpha = 0.8, stroke = 0.8) +
  stat_ellipse(
    aes(color = group),
    level     = 0.95,
    linewidth = 0.9,
    show.legend = FALSE
  ) +
  scale_color_manual(values = group_colors, name = "Legend") +
  scale_shape_manual(values = group_shapes, name = "Legend") +
  labs(
    title = "Estonia Obesity Extremes: PLS-DA",
    x     = "X-variate 1: NC% expl. var",
    y     = "X-variate 2: NC% expl. var"
  ) +
  theme_classic(base_size = 14) +
  theme(
    plot.title       = element_text(face = "bold", hjust = 0.5, size = 13),
    panel.background = element_rect(fill = "grey92", color = NA),
    panel.grid.major = element_line(color = "white", linewidth = 0.4),
    legend.title     = element_text(size = 12),
    legend.text      = element_text(size = 11)
  )

ggsave("plot.png", p, width = 5, height = 4, dpi = 800)

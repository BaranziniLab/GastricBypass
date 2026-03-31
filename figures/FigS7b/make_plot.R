library(ggplot2)

df = read.csv("data.csv", stringsAsFactors = FALSE)
df$group = factor(df$group, levels = c("swl", "rgn"))

# Colors matching original: swl = teal/green, rgn = gold/orange
group_colors = c("swl" = "#1B7837", "rgn" = "#D4A017")
group_shapes = c("swl" = 1, "rgn" = 2)  # circle (open), triangle (open)

p = ggplot(df, aes(x = xvar1, y = xvar2, color = group, shape = group)) +
  geom_point(size = 2.5, alpha = 0.8, stroke = 0.9) +
  stat_ellipse(
    aes(color = group),
    level       = 0.95,
    linewidth   = 0.9,
    show.legend = FALSE
  ) +
  scale_color_manual(values = group_colors, name = "Legend") +
  scale_shape_manual(values = group_shapes, name = "Legend") +
  labs(
    title = "Post-RYGB Cohort: PLS-DA",
    x     = "X-variate 1: 7% expl. var",
    y     = "X-variate 2: 20% expl. var"
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

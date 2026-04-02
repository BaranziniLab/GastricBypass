library(ggplot2)

df = read.csv("data.csv", stringsAsFactors = FALSE)
df$group = factor(df$group, levels = c("swl", "rgn"))

group_colors = c("swl" = "#0072B2", "rgn" = "#E69F00")

p = ggplot(df, aes(x = xvar1, y = xvar2)) +
  stat_ellipse(aes(color = group), level = 0.95, linewidth = 0.8, show.legend = FALSE) +
  geom_point(aes(fill = group), shape = 21, size = 3, alpha = 0.8, color = "black") +
  scale_fill_manual(
    values = group_colors,
    labels = c("swl" = "SWL", "rgn" = "RGN"),
    name = "Outcome Group"
  ) +
  scale_color_manual(values = group_colors, guide = "none") +
  labs(
    x = "PLS-DA Component 1 (7% Variance Explained)",
    y = "PLS-DA Component 2 (20% Variance Explained)"
  ) +
  theme_linedraw(base_size = 15) +
  theme(
    panel.grid.major = element_line(colour = "grey90"),
    panel.grid.minor = element_blank(),
    legend.position = "right"
  )

ggsave("figs7b.png", p, width = 5, height = 4, dpi = 800, bg = "white")

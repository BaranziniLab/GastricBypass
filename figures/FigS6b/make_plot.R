library(ggplot2)
library(svglite)

df = read.csv("data.csv", stringsAsFactors = FALSE)
df$group = factor(df$group, levels = c("Lean", "Obese"))

group_colors = c("Lean" = "#0072B2", "Obese" = "#E69F00")
group_shapes = c("Lean" = 16, "Obese" = 17)

p = ggplot(df, aes(x = xvar1, y = xvar2, color = group, shape = group)) +
  geom_point(size = 2.5, alpha = 0.8) +
  stat_ellipse(aes(color = group), level = 0.95, linewidth = 0.9, show.legend = FALSE) +
  scale_color_manual(values = group_colors, name = "BMI Group") +
  scale_shape_manual(values = group_shapes, name = "BMI Group") +
  labs(
    x = "PLS-DA Component 1",
    y = "PLS-DA Component 2"
  ) +
  theme_classic(base_size = 14) +
  theme(
    axis.line = element_line(linewidth = 0.8),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 11)
  )

ggsave("figs6b.svg", p, width = 5, height = 4)

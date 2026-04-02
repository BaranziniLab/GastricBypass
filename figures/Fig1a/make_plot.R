library(ggplot2)

df = read.csv("data.csv")
df$class = factor(df$class, levels = c("Class 1", "Class 2", "Class 3"))

class_colors = c(
  "Class 1" = "#E69F00",
  "Class 2" = "#0072B2",
  "Class 3" = "#CC79A7"
)

p = ggplot(df, aes(x = year, y = ebw_mean, color = class, fill = class)) +
  geom_ribbon(aes(ymin = ebw_lower, ymax = ebw_upper), alpha = 0.15, color = NA) +
  geom_line(linewidth = 0.8) +
  scale_color_manual(values = class_colors, name = NULL) +
  scale_fill_manual(values = class_colors, name = NULL) +
  scale_x_continuous(breaks = c(0.5, 1, 2, 3, 4, 5, 6), limits = c(0.2, 6.7)) +
  scale_y_continuous(breaks = c(25, 50, 75, 100), limits = c(0, 115)) +
  labs(
    x = "Years After Surgery",
    y = "Excess Body Weight (kg)"
  ) +
  theme_linedraw(base_size = 15) +
  theme(
    legend.position = "right",
    legend.key.width = unit(1.2, "cm"),
    panel.grid.minor = element_blank()
  )

ggsave("fig1a.png", p, width = 8, height = 4, dpi = 800, bg = "white")

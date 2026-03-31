library(ggplot2)
library(RColorBrewer)

df = read.csv("data.csv")

df$class = factor(df$class, levels = c("Class 1", "Class 2", "Class 3"))

class_colors = c(
  "Class 1" = "#4878CF",
  "Class 2" = "#D4A017",
  "Class 3" = "#C47DB5"
)

p = ggplot(df, aes(x = year, y = ebw_mean, color = class, fill = class)) +
  geom_ribbon(aes(ymin = ebw_lower, ymax = ebw_upper), alpha = 0.2, color = NA) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2.5, alpha = 0.8) +
  scale_color_manual(values = class_colors, name = NULL) +
  scale_fill_manual(values = class_colors, name = NULL) +
  scale_x_continuous(
    breaks = c(0.5, 1, 2, 3, 4, 5, 6),
    limits = c(0.2, 6.7)
  ) +
  scale_y_continuous(
    breaks = c(25, 50, 75, 100),
    limits = c(0, 115)
  ) +
  labs(
    x = "Years After Surgery",
    y = "Excess Body Weight (kg)"
  ) +
  theme_classic(base_size = 14) +
  theme(
    legend.position = c(0.82, 0.82),
    legend.background = element_rect(color = "grey70", fill = "white"),
    legend.key.width = unit(1.2, "cm"),
    axis.line = element_line(linewidth = 0.8)
  )

ggsave("plot.png", p, width = 5, height = 4, dpi = 800)

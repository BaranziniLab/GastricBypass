library(ggplot2)

df = read.csv("data.csv", stringsAsFactors = FALSE)
df$class = factor(df$class, levels = c("Weight Regain", "Sustained Loss"))

# Colors: gold for Weight Regain, steel blue for Sustained Loss (matching original)
class_colors = c("Weight Regain" = "#E6A817", "Sustained Loss" = "#4E84C4")

p = ggplot(df, aes(x = time, y = ebw, group = subject_id, color = class)) +
  geom_line(linewidth = 0.8, alpha = 0.8) +
  scale_color_manual(values = class_colors, name = NULL) +
  scale_x_continuous(breaks = c(0, 12, 24, 36, 48, 60, 72, 84)) +
  scale_y_continuous(breaks = c(0, 50, 100, 150)) +
  labs(
    x = "Time (months)",
    y = "Excess Body Weight (kg)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "top",
    panel.grid.minor = element_blank()
  )

ggsave("plot.png", p, width = 5, height = 4, dpi = 800)

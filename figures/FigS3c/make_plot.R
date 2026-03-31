library(ggplot2)

df = read.csv("data.csv", stringsAsFactors = FALSE)
df$sex = factor(df$sex, levels = c("Male", "Female"))

# Colors matching original: steel blue for Male, pink for Female
sex_colors = c("Male" = "#5B9BD5", "Female" = "#D98CB3")

p = ggplot(df, aes(x = time, y = ebw, group = subject_id, color = sex)) +
  geom_line(linewidth = 0.8, alpha = 0.8) +
  scale_color_manual(values = sex_colors, name = NULL) +
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

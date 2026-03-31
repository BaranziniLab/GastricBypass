library(ggplot2)

df = read.csv("data.csv")

p = ggplot(df, aes(x = ebw_observed, y = ebw_predicted)) +
  geom_abline(slope = 1, intercept = 0, color = "#D4820A", linetype = "dashed", linewidth = 1.0) +
  geom_point(size = 2.5, alpha = 0.8, color = "grey60", stroke = 0.4) +
  scale_x_continuous(
    breaks = c(0, 50, 100),
    limits = c(-15, 125)
  ) +
  scale_y_continuous(
    breaks = c(0, 20, 40, 60, 80, 100, 120),
    limits = c(-15, 135)
  ) +
  labs(
    x = "EBW Observed (kg)",
    y = "EBW Predicted (kg)"
  ) +
  theme_classic(base_size = 14) +
  theme(
    axis.line = element_line(linewidth = 0.8),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8)
  )

ggsave("plot.png", p, width = 5, height = 4, dpi = 800)

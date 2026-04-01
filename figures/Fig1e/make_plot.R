library(ggplot2)
library(svglite)

df = read.csv("data.csv")

p = ggplot(df, aes(x = ebw_observed, y = ebw_predicted)) +
  geom_abline(slope = 1, intercept = 0, color = "#E69F00", linetype = "dashed", linewidth = 1.0) +
  geom_point(size = 2.5, alpha = 0.8, color = "grey50", stroke = 0.3) +
  scale_x_continuous(breaks = c(0, 50, 100), limits = c(-20, 135)) +
  scale_y_continuous(breaks = c(0, 20, 40, 60, 80, 100, 120), limits = c(-20, 135)) +
  labs(
    x = "Observed Excess Body Weight (kg)",
    y = "Predicted Excess Body Weight (kg)"
  ) +
  theme_classic(base_size = 14) +
  theme(
    axis.line = element_line(linewidth = 0.8),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8)
  )

ggsave("fig1e.svg", p, width = 5, height = 4)

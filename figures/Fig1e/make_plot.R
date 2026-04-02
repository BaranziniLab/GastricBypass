library(ggplot2)
library(here)
setwd(here::here("figures/Fig1e"))

df = read.csv("data.csv")

p = ggplot(df, aes(x = ebw_observed, y = ebw_predicted)) +
  geom_abline(slope = 1, intercept = 0, color = "gray60", linetype = "dashed", linewidth = 0.8) +
  geom_point(size = 3, alpha = 0.8, color = "#0072B2") +
  scale_x_continuous(breaks = c(0, 50, 100), limits = c(-20, 135)) +
  scale_y_continuous(breaks = c(0, 20, 40, 60, 80, 100, 120), limits = c(-20, 135)) +
  labs(
    x = "EBW Observed (kg)",
    y = "EBW Predicted (kg)"
  ) +
  theme_classic(base_size = 15) +
  theme(
    axis.line = element_line(linewidth = 0.8)
  )

ggsave("fig1e.png", p, width = 5, height = 4, dpi = 800, bg = "white")

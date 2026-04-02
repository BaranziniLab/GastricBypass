library(ggplot2)

df = read.csv("data_predicted_vs_observed_rmse.csv")

p = ggplot(df, aes(x = observed, y = predicted)) +
  geom_smooth(method = "lm", se = FALSE,
              color = "#E69F00", linetype = "dashed", linewidth = 0.8) +
  geom_point(size = 3, alpha = 0.8, color = "#0072B2") +
  annotate("text", x = 95, y = 50,
           label = "RMSE = 21.45\nMAE = 17.24",
           fontface = "bold", size = 4.5, hjust = 0) +
  scale_x_continuous(limits = c(35, 125), breaks = c(40, 60, 80, 100, 120)) +
  scale_y_continuous(limits = c(20, 175), breaks = c(40, 80, 120, 160)) +
  labs(
    x = "Observed Excess Body Weight at Year 5 (kg)",
    y = "Predicted Excess Body Weight at Year 5 (kg)"
  ) +
  theme_classic(base_size = 15) +
  theme(axis.line = element_line(linewidth = 0.8))

ggsave("figsx_predicted_vs_observed_rmse.png", p, width = 5, height = 4, dpi = 800, bg = "white")

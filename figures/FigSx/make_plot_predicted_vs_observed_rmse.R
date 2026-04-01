library(ggplot2)
library(svglite)

df = read.csv("data_predicted_vs_observed_rmse.csv")

p = ggplot(df, aes(x = observed, y = predicted)) +
  geom_point(color = "#0072B2", size = 2.5, alpha = 0.8) +
  geom_smooth(method = "lm", se = FALSE,
              color = "#E69F00", linetype = "dashed", linewidth = 1.1) +
  annotate("text", x = 95, y = 50,
           label = "RMSE = 21.45\nMAE = 17.24",
           fontface = "bold", size = 4.2, hjust = 0) +
  scale_x_continuous(limits = c(35, 125), breaks = c(40, 60, 80, 100, 120)) +
  scale_y_continuous(limits = c(20, 175), breaks = c(40, 80, 120, 160)) +
  labs(
    x = "Observed Excess Body Weight at Year 5 (kg)",
    y = "Predicted Excess Body Weight at Year 5 (kg)"
  ) +
  theme_classic(base_size = 14) +
  theme(axis.line = element_line(linewidth = 0.8))

ggsave("figsx_predicted_vs_observed_rmse.svg", p, width = 5, height = 4)

library(ggplot2)

# Predicted vs Observed EBW (Excess Body Weight) at Year 5
# RMSE = 21.45, MAE = 17.24
# Each point is one subject; dashed orange line is OLS fit

df = read.csv("data_predicted_vs_observed_rmse.csv")

rmse_val = 21.45
mae_val  = 17.24

p = ggplot(df, aes(x = observed, y = predicted)) +
  geom_point(color = "#4393C3", size = 2.5, alpha = 0.8) +
  geom_smooth(method = "lm", se = FALSE,
              color = "#E08B30", linetype = "dashed", linewidth = 1.1) +
  annotate(
    "text",
    x = 95, y = 48,
    label = paste0("RMSE = ", rmse_val, "\nMAE = ", mae_val),
    fontface = "bold",
    size = 4.5,
    hjust = 0
  ) +
  scale_x_continuous(
    limits = c(35, 125),
    breaks = c(40, 60, 80, 100, 120)
  ) +
  scale_y_continuous(
    limits = c(20, 175),
    breaks = c(40, 80, 120, 160)
  ) +
  labs(
    x = "Observed EBW at Year 5",
    y = "Predicted EBW at Year 5"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid.minor = element_blank(),
    axis.title = element_text(size = 14),
    axis.text  = element_text(size = 12)
  )

ggsave("plot_predicted_vs_observed_rmse.png", p, width = 5, height = 4, dpi = 800)

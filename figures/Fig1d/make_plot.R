library(ggplot2)
library(svglite)

df = read.csv("data.csv")
df$patient_id = factor(df$patient_id, levels = c("10365", "11473", "12471", "13744", "14382", "14492"))

p = ggplot(df, aes(x = time_months)) +
  geom_line(aes(y = ebw_observed, color = "Observed"), linewidth = 0.9) +
  geom_point(aes(y = ebw_observed, color = "Observed"), size = 2.5, alpha = 0.8) +
  geom_line(aes(y = ebw_spline, color = "B-Spline Fit"), linewidth = 0.9) +
  geom_point(aes(y = ebw_spline, color = "B-Spline Fit"), size = 2.5, alpha = 0.8) +
  facet_wrap(~ patient_id, ncol = 3) +
  scale_color_manual(
    values = c("Observed" = "#0072B2", "B-Spline Fit" = "#D55E00"),
    name = NULL
  ) +
  scale_x_continuous(breaks = c(0, 20, 40, 60), limits = c(0, 62)) +
  scale_y_continuous(breaks = c(0, 30, 60, 90, 120), limits = c(0, 130)) +
  labs(x = "Time (Months)", y = "Excess Body Weight (kg)") +
  theme_minimal(base_size = 14) +
  theme(
    strip.background = element_rect(fill = "grey85", color = NA),
    strip.text = element_text(size = 11, color = "black"),
    legend.position = "bottom",
    panel.grid.major = element_line(color = "grey88", linewidth = 0.4),
    panel.grid.minor = element_blank()
  )

ggsave("fig1d.svg", p, width = 7, height = 5)

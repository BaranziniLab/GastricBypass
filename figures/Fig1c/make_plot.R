library(ggplot2)
library(svglite)

df = read.csv("data.csv")
df$patient_id = factor(df$patient_id, levels = c("10365", "11473", "12471", "13744", "14382", "14492"))
df$series = factor(df$series, levels = c("Observed", "Linear Fit"))

p = ggplot(df, aes(x = time_months)) +
  geom_line(aes(y = ebw, color = series, group = series), linewidth = 0.9) +
  geom_point(aes(y = ebw, color = series), size = 2.5, alpha = 0.8) +
  facet_wrap(~ patient_id, ncol = 3) +
  scale_color_manual(
    values = c("Observed" = "#0072B2", "Linear Fit" = "#D55E00"),
    name = NULL
  ) +
  scale_x_continuous(breaks = c(0, 10, 20, 30), limits = c(0, 36)) +
  scale_y_continuous(breaks = c(30, 60, 90, 120), limits = c(0, 130)) +
  labs(x = "Time (months)", y = "EBW (kg)") +
  theme_minimal(base_size = 14) +
  theme(
    strip.background = element_rect(fill = "grey85", color = NA),
    strip.text = element_text(size = 11, color = "black"),
    legend.position = "bottom",
    panel.grid.major = element_line(color = "grey88", linewidth = 0.4),
    panel.grid.minor = element_blank()
  )

ggsave("fig1c.svg", p, width = 7, height = 5)

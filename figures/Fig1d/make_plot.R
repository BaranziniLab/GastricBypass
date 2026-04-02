library(ggplot2)

df = read.csv("data.csv")
df$patient_id = factor(df$Subject, levels = c("10365", "11473", "12471", "13744", "14382", "14492"))
df$series = factor(ifelse(df$Modality == "Predicted", "B-Spline Fit", "Observed"),
                   levels = c("Observed", "B-Spline Fit"))
df$ebw = df$EBW
df$time_months = df$Time

p = ggplot(df, aes(x = time_months)) +
  geom_line(aes(y = ebw, color = series, group = series), linewidth = 0.8) +
  geom_point(aes(y = ebw, color = series), size = 3, alpha = 0.8) +
  facet_wrap(~ patient_id, ncol = 3) +
  scale_color_manual(
    values = c("Observed" = "#0072B2", "B-Spline Fit" = "#D55E00"),
    name = NULL
  ) +
  scale_x_continuous(breaks = c(0, 20, 40, 60), limits = c(0, 62)) +
  scale_y_continuous(breaks = c(0, 30, 60, 90, 120), limits = c(0, 130)) +
  labs(x = "Time (months)", y = "EBW (kg)") +
  theme_linedraw(base_size = 15) +
  theme(
    strip.background = element_rect(fill = "grey85", color = NA),
    strip.text = element_text(size = 12, color = "black"),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )

ggsave("fig1d.png", p, width = 7, height = 5, dpi = 800, bg = "white")

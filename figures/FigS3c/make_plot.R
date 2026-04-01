library(ggplot2)
library(svglite)

df = read.csv("data.csv", stringsAsFactors = FALSE)
df$sex = factor(df$sex, levels = c("Male", "Female"))

sex_colors = c("Male" = "#0072B2", "Female" = "#CC79A7")

p = ggplot(df, aes(x = time, y = ebw, group = subject_id, color = sex)) +
  geom_line(linewidth = 0.5, alpha = 0.6) +
  scale_color_manual(values = sex_colors, name = "Sex") +
  scale_x_continuous(breaks = c(0, 12, 24, 36, 48, 60, 72, 84)) +
  scale_y_continuous(breaks = c(0, 50, 100, 150)) +
  labs(
    x = "Time Since Surgery (Months)",
    y = "Excess Body Weight (kg)"
  ) +
  theme_classic(base_size = 14) +
  theme(
    legend.position = "top",
    axis.line = element_line(linewidth = 0.8)
  )

ggsave("figs3c.svg", p, width = 5, height = 4)

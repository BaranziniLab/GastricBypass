library(ggplot2)
library(dplyr)
library(svglite)

df = read.csv("data.csv", stringsAsFactors = FALSE)
df$group = factor(df$group, levels = c("SWL", "RGN"))

group_colors = c("SWL" = "#0072B2", "RGN" = "#E69F00")

df_mean = df |>
  group_by(group, time_months) |>
  summarise(ebw_kg = mean(ebw_kg), .groups = "drop")

p = ggplot(df, aes(x = time_months, y = ebw_kg, color = group)) +
  geom_line(aes(group = subject_id), linewidth = 0.4, alpha = 0.4) +
  geom_line(data = df_mean, aes(group = group), linewidth = 1.4, alpha = 1.0) +
  scale_x_continuous(
    name   = "Time Since Surgery (Months)",
    breaks = c(0, 12, 24, 36, 48)
  ) +
  scale_y_continuous(name = "Excess Body Weight (kg)") +
  scale_color_manual(
    values = group_colors,
    labels = c("SWL" = "Sustained Weight Loss", "RGN" = "Weight Regain"),
    name = "Outcome Group"
  ) +
  theme_classic(base_size = 14) +
  theme(
    legend.position  = "bottom",
    legend.title     = element_text(face = "bold"),
    axis.line        = element_line(linewidth = 0.8),
    plot.margin      = margin(8, 12, 8, 8)
  )

ggsave("figsy.svg", p, width = 6, height = 5)

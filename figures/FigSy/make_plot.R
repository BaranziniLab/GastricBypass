library(ggplot2)
library(dplyr)

# ── Load data ──────────────────────────────────────────────────────────────────
df = read.csv("data.csv", stringsAsFactors = FALSE)

df$group = factor(df$group, levels = c("SWL", "RGN"))

# ── Colors ─────────────────────────────────────────────────────────────────────
# Steel blue for Sustained Weight Loss; gold/amber for Weight Regain
group_colors = c(
  "SWL" = "#4682B4",   # steel blue
  "RGN" = "#E6A817"    # gold / amber
)

# ── Group mean trajectory ──────────────────────────────────────────────────────
df_mean = df |>
  group_by(group, time_months) |>
  summarise(ebw_kg = mean(ebw_kg), .groups = "drop")

# ── Plot ───────────────────────────────────────────────────────────────────────
p = ggplot(df, aes(x = time_months, y = ebw_kg, color = group)) +

  # Individual spaghetti lines
  geom_line(
    aes(group = subject_id),
    linewidth = 0.4,
    alpha     = 0.5
  ) +

  # Individual subject points (small, semi-transparent)
  geom_point(size = 0.8, alpha = 0.45) +

  # Group mean trajectory on top
  stat_summary(
    fun      = mean,
    geom     = "line",
    linewidth = 1.2,
    alpha    = 1.0
  ) +

  # Axis labels and legend title
  scale_x_continuous(
    name   = "Time since surgery (months)",
    breaks = c(0, 12, 24, 36, 48)
  ) +
  scale_y_continuous(name = "Excess Body Weight (kg)") +

  scale_color_manual(
    values = group_colors,
    labels = c(
      "SWL" = "Sustained Weight Loss",
      "RGN" = "Weight Regain"
    ),
    name = "Outcome Group"
  ) +

  theme_classic(base_size = 14) +
  theme(
    legend.position   = "bottom",
    legend.title      = element_text(face = "bold"),
    panel.grid.major  = element_line(color = "grey90", linewidth = 0.3),
    plot.margin       = margin(8, 12, 8, 8)
  )

# ── Save ───────────────────────────────────────────────────────────────────────
ggsave("plot.png", p, width = 6, height = 5, dpi = 800)
message("Saved plot.png")

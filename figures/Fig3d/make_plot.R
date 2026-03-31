library(ggplot2)

d = read.csv("data.csv")

# Fix factor order so variables read top-to-bottom as in original
var_order = c("MetRS (per SD)", "Sex", "Baseline EBW", "Age")
d$variable = factor(d$variable, levels = var_order)
d$model    = factor(d$model,    levels = c("Model1", "Model2", "Model3", "Model4"))

p = ggplot(d, aes(x = estimate, y = variable)) +
  geom_vline(xintercept = 1, linetype = "dashed", colour = "grey40", linewidth = 0.7) +
  geom_errorbarh(
    aes(xmin = ci_low, xmax = ci_high),
    height    = 0.2,
    linewidth = 0.9,
    colour    = "#2166AC"
  ) +
  geom_point(
    size   = 3,
    colour = "#2166AC",
    alpha  = 0.9
  ) +
  scale_x_continuous(
    breaks = c(0, 1, 2, 3, 5),
    trans  = "log",
    limits = c(0.3, 6)
  ) +
  facet_wrap(~ model, nrow = 1) +
  labs(
    x = "Odds Ratio (log scale)",
    y = NULL
  ) +
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.minor  = element_blank(),
    panel.grid.major.y = element_blank(),
    strip.text        = element_text(face = "bold"),
    axis.title.x      = element_text(face = "bold"),
    panel.spacing     = unit(1, "lines")
  )

ggsave("plot.png", p, width = 9, height = 3.5, dpi = 800)

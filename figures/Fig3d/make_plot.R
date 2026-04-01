library(ggplot2)
library(svglite)

d = read.csv("data.csv")
var_order = c("MetRS (per SD)", "Sex", "Baseline EBW", "Age")
d$variable = factor(d$variable, levels = var_order)
d$model    = factor(d$model,    levels = c("Model1", "Model2", "Model3", "Model4"))

p = ggplot(d, aes(x = estimate, y = variable)) +
  geom_vline(xintercept = 1, linetype = "dashed", colour = "grey50", linewidth = 0.7) +
  geom_errorbarh(
    aes(xmin = ci_low, xmax = ci_high),
    height = 0.2, linewidth = 0.9, colour = "#0072B2"
  ) +
  geom_point(size = 3, colour = "#0072B2", alpha = 0.9) +
  scale_x_continuous(
    breaks = c(0, 1, 2, 3, 5),
    trans  = "log",
    limits = c(0.3, 6)
  ) +
  facet_wrap(~ model, nrow = 1) +
  labs(x = "Odds Ratio (Log Scale)", y = NULL) +
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.minor   = element_blank(),
    panel.grid.major.y = element_blank(),
    strip.text         = element_text(face = "bold"),
    panel.spacing      = unit(1, "lines")
  )

ggsave("fig3d.svg", p, width = 9, height = 3.5)

library(ggplot2)
library(dplyr)
library(here)
setwd(here::here("figures/Fig3b"))

d = read.csv("data.csv") |>
  arrange(model, one_minus_specificity) |>
  group_by(model) |>
  mutate(sensitivity = cummin(sensitivity)) |>
  ungroup() |>
  distinct(model, one_minus_specificity, .keep_all = TRUE) |>
  arrange(model, desc(one_minus_specificity))

model_cols = c(
  "MetRS + covariates" = "#0072B2",
  "Covariates only"    = "#E69F00"
)

p = ggplot(d, aes(x = one_minus_specificity, y = sensitivity, colour = model, group = model)) +
  annotate("segment", x = 1, y = 0, xend = 0, yend = 1,
           colour = "grey70", linewidth = 0.7) +
  geom_step(direction = "vh", linewidth = 0.8) +
  scale_colour_manual(
    values = model_cols,
    labels = c(
      "MetRS + covariates" = "MetRS + covariates (AUC: 0.744)",
      "Covariates only"    = "Covariates only (AUC: 0.6)"
    )
  ) +
  scale_x_reverse(limits = c(1, 0), breaks = seq(1, 0, -0.2)) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
  labs(x = "1 \u2013 Specificity", y = "Sensitivity", colour = NULL) +
  theme_linedraw(base_size = 15) +
  theme(
    legend.position   = c(1.0, 0.02),
    legend.justification = c(1, 0),
    legend.background = element_rect(fill = "transparent", colour = NA),
    legend.key.width  = unit(1.2, "cm"),
    panel.grid.minor  = element_blank()
  )

ggsave("fig3b.png", p, width = 5, height = 4, dpi = 800, bg = "white")

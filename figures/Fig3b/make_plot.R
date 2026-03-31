library(ggplot2)
library(RColorBrewer)

d = read.csv("data.csv")

# Colours: blue for MetRS + covariates, gold for Covariates only
model_cols = c(
  "MetRS + covariates" = "#2166AC",
  "Covariates only"    = "#D4A017"
)

# Labels for legend showing AUC
legend_labels = c(
  "MetRS + covariates" = "MetRS + covariates (AUC: 0.744)",
  "Covariates only"    = "Covariates only (AUC: 0.6)"
)

p = ggplot(d, aes(x = one_minus_specificity, y = sensitivity,
                  colour = model, group = model)) +
  # reference diagonal
  geom_abline(slope = 1, intercept = 0, colour = "grey70", linewidth = 0.7) +
  geom_line(linewidth = 0.9) +
  # AUC annotations on the plot
  annotate("text", x = 0.44, y = 0.83, label = "AUC: 0.744",
           colour = "#2166AC", size = 4.5, hjust = 0) +
  annotate("text", x = 0.44, y = 0.68, label = "AUC: 0.600",
           colour = "#D4A017", size = 4.5, hjust = 0) +
  scale_colour_manual(values = model_cols, labels = legend_labels) +
  scale_x_reverse(limits = c(1, 0), breaks = seq(1, 0, -0.2)) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
  labs(
    x      = "1 \u2013 Specificity",
    y      = "Sensitivity",
    colour = NULL
  ) +
  theme_classic(base_size = 14) +
  theme(
    legend.position   = c(0.38, 0.15),
    legend.background = element_rect(fill = "white", colour = NA),
    legend.key.width  = unit(1.2, "cm")
  )

ggsave("plot.png", p, width = 5, height = 4, dpi = 800)

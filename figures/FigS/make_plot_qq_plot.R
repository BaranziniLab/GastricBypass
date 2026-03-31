library(ggplot2)

df = read.csv("data_qq_plot.csv", stringsAsFactors = FALSE)

# Genomic inflation factor annotated in figure
lambda_val = 1.87

# Reference line: identity (expected = observed)
ref_line = data.frame(x = c(0, 3.2), y = c(0, 3.2))

p = ggplot(df, aes(x = expected, y = observed)) +
  geom_line(
    data = ref_line, aes(x = x, y = y),
    linetype = "dashed",
    color = "gray50",
    linewidth = 0.9,
    inherit.aes = FALSE
  ) +
  geom_point(
    color = "#3A87C8",
    size = 2.5,
    alpha = 0.8
  ) +
  annotate(
    "text",
    x = 1.9, y = 4.2,
    label = paste0("\u03bb = ", lambda_val),
    color = "#CC6600",
    size = 5,
    fontface = "italic"
  ) +
  scale_x_continuous(
    breaks = 0:3,
    limits = c(0, 3.2),
    expand = c(0.01, 0)
  ) +
  scale_y_continuous(
    breaks = 0:4,
    limits = c(0, 4.7),
    expand = c(0.01, 0)
  ) +
  labs(
    title = "QQ Plot: Metabolite-outcome associations",
    x = expression("Expected" ~ -log[10](p)),
    y = expression("Observed" ~ -log[10](p))
  ) +
  theme_classic(base_size = 14) +
  theme(
    panel.grid.major = element_line(color = "gray90", linewidth = 0.5),
    axis.line = element_line(color = "black", linewidth = 0.8)
  )

ggsave("plot_qq_plot.png", p, width = 5, height = 4, dpi = 800)

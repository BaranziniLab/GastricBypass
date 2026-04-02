library(ggplot2)

df = read.csv("data_qq_plot.csv", stringsAsFactors = FALSE)
lambda_val = 1.87
ref_line = data.frame(x = c(0, 3.2), y = c(0, 3.2))

p = ggplot(df, aes(x = expected, y = observed)) +
  geom_line(data = ref_line, aes(x = x, y = y),
            linetype = "dashed", color = "grey50", linewidth = 0.8, inherit.aes = FALSE) +
  geom_point(color = "#0072B2", size = 3, alpha = 0.8) +
  annotate("text", x = 1.9, y = 4.2,
           label = paste0("\u03bb = ", lambda_val),
           color = "#D55E00", size = 5, fontface = "italic") +
  scale_x_continuous(breaks = 0:3, limits = c(0, 3.2), expand = c(0.01, 0)) +
  scale_y_continuous(breaks = 0:4, limits = c(0, 4.7), expand = c(0.01, 0)) +
  labs(
    x = expression("Expected" ~ -log[10](italic(p))),
    y = expression("Observed" ~ -log[10](italic(p)))
  ) +
  theme_classic(base_size = 15) +
  theme(axis.line = element_line(linewidth = 0.8))

ggsave("figs_qq_plot.png", p, width = 5, height = 4, dpi = 800, bg = "white")

library(ggplot2)

df = read.csv("data_pvalue_histogram.csv", stringsAsFactors = FALSE)

# Expected count under uniform null: 541 metabolites / 50 bins = 10.82
expected_count = 541 / 50

p = ggplot(df, aes(x = bin_mid, y = count)) +
  geom_col(
    width = 0.02,
    fill = "#3A87C8",
    color = NA,
    alpha = 0.9
  ) +
  geom_hline(
    yintercept = expected_count,
    linetype = "dashed",
    color = "#CC6600",
    linewidth = 1.0
  ) +
  annotate(
    "text",
    x = 0.72, y = expected_count + 1.3,
    label = "Expected under null",
    color = "#CC6600",
    fontface = "italic",
    size = 4.2
  ) +
  scale_x_continuous(
    breaks = c(0.00, 0.25, 0.50, 0.75, 1.00),
    labels = c("0.00", "0.25", "0.50", "0.75", "1.00"),
    expand = c(0.01, 0)
  ) +
  scale_y_continuous(
    breaks = seq(0, 25, by = 5),
    expand = c(0, 0),
    limits = c(0, 27)
  ) +
  labs(
    title = "Distribution of association p-values (541 metabolites)",
    x = "P-value",
    y = "Count"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black", linewidth = 0.5)
  )

ggsave("plot_pvalue_histogram.png", p, width = 5, height = 4, dpi = 800)

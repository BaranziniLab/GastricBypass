library(ggplot2)
library(here)
setwd(here::here("figures/FigS"))

df = read.csv("data_pvalue_histogram.csv", stringsAsFactors = FALSE)
expected_count = 541 / 50

p = ggplot(df, aes(x = bin_mid, y = count)) +
  geom_col(width = 0.02, fill = "darkgray", color = NA, alpha = 0.85) +
  geom_hline(yintercept = expected_count, linetype = "dashed",
             color = "black", linewidth = 0.8) +
  annotate("text", x = 0.72, y = expected_count + 1.3,
           label = "Expected under null", color = "black",
           fontface = "italic", size = 4.5) +
  scale_x_continuous(
    breaks = c(0.00, 0.25, 0.50, 0.75, 1.00),
    labels = c("0.00", "0.25", "0.50", "0.75", "1.00"),
    expand = c(0.05, 0.05)
  ) +
  scale_y_continuous(breaks = seq(0, 25, by = 5), expand = c(0, 0), limits = c(0, 27)) +
  labs(x = "P-Value", y = "Number of Metabolites") +
  theme_classic(base_size = 15) +
  theme(axis.line = element_line(linewidth = 0.8))

ggsave("figs_pvalue_histogram.png", p, width = 5.5, height = 4, dpi = 800, bg = "white")

library(ggplot2)
library(here)
setwd(here::here("figures/Fig4a"))

df = read.csv("data.csv")
df$group = factor(df$group, levels = c("SWL", "RGN"))

fill_cols = c("SWL" = "#0072B2", "RGN" = "#E69F00")

p = ggplot(df, aes(x = group, fill = group)) +
  geom_boxplot(
    aes(ymin = ymin, lower = lower, middle = middle, upper = upper, ymax = ymax),
    stat = "identity", width = 0.55, color = "black", linewidth = 0.8, outlier.shape = NA
  ) +
  annotate("segment", x = 1, xend = 2, y = 2.7, yend = 2.7, linewidth = 0.8) +
  annotate("segment", x = 1, xend = 1, y = 2.7, yend = 2.5, linewidth = 0.8) +
  annotate("segment", x = 2, xend = 2, y = 2.7, yend = 2.5, linewidth = 0.8) +
  annotate("text", x = 1.5, y = 2.95, label = "p == 0.028", parse = TRUE, size = 5) +
  scale_fill_manual(values = fill_cols) +
  scale_x_discrete(limits = c("SWL", "RGN")) +
  scale_y_continuous(breaks = c(-2, 0, 2)) +
  labs(x = NULL, y = "MetRS") +
  theme_classic(base_size = 15) +
  theme(legend.position = "none", axis.line = element_line(linewidth = 0.8))

ggsave("fig4a.png", p, width = 5, height = 4, dpi = 800, bg = "white")

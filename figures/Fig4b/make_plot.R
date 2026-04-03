library(ggplot2)
library(here)
setwd(here::here("figures/Fig4b"))

df = read.csv("data.csv")
df$group = factor(df$group, levels = c("Lean", "Obese"))

fill_cols = c("Lean" = "#56B4E9", "Obese" = "#D55E00")

p = ggplot(df, aes(x = group, fill = group)) +
  geom_boxplot(
    aes(ymin = ymin, lower = lower, middle = middle, upper = upper, ymax = ymax),
    stat = "identity", width = 0.55, color = "black", linewidth = 0.8, outlier.shape = NA
  ) +
  annotate("segment", x = 1, xend = 2, y = 3.3, yend = 3.3, linewidth = 0.8) +
  annotate("segment", x = 1, xend = 1, y = 3.3, yend = 3.1, linewidth = 0.8) +
  annotate("segment", x = 2, xend = 2, y = 3.3, yend = 3.1, linewidth = 0.8) +
  annotate("text", x = 1.5, y = 3.6, label = "p == 0.011", parse = TRUE, size = 5) +
  scale_fill_manual(values = fill_cols) +
  scale_y_continuous(breaks = c(-2, 0, 2, 4), limits = c(NA, 4.0)) +
  labs(x = NULL, y = "MetRS") +
  theme_classic(base_size = 18) +
  theme(legend.position = "none", axis.line = element_line(linewidth = 0.8))

ggsave("fig4b.png", p, width = 5, height = 4, dpi = 800, bg = "white")

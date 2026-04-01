library(ggplot2)
library(svglite)

d = read.csv("data.csv")
d$group = factor(d$group, levels = c("SWL", "RGN"))

fill_cols = c("SWL" = "#0072B2", "RGN" = "#E69F00")

p = ggplot(d, aes(x = group, fill = group)) +
  geom_boxplot(
    aes(ymin = whisker_low, lower = q1, middle = median, upper = q3, ymax = whisker_high),
    stat = "identity", width = 0.5, linewidth = 0.8, outlier.shape = NA
  ) +
  annotate("segment", x = 1, xend = 2, y = 3.7, yend = 3.7, linewidth = 0.7) +
  annotate("segment", x = 1, xend = 1, y = 3.5, yend = 3.7, linewidth = 0.7) +
  annotate("segment", x = 2, xend = 2, y = 3.5, yend = 3.7, linewidth = 0.7) +
  annotate("text", x = 1.5, y = 3.9, label = "p = 1.2\u00d710\u207b\u00b9\u2070", size = 4) +
  scale_fill_manual(values = fill_cols) +
  scale_x_discrete(
    limits = c("SWL", "RGN"),
    labels = c("SWL" = "Sustained Weight Loss", "RGN" = "Weight Regain")
  ) +
  labs(x = NULL, y = "Metabolite Risk Score") +
  theme_classic(base_size = 14) +
  theme(legend.position = "none", axis.line = element_line(linewidth = 0.8))

ggsave("fig3a.svg", p, width = 5, height = 4)

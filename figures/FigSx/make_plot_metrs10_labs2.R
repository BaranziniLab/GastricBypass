library(ggplot2)
library(here)
setwd(here::here("figures/FigSx"))

df = read.csv("data_metrs10_labs2.csv")
df$group = factor(df$group, levels = c("SWL", "RGN"))

fill_cols = c("SWL" = "#0072B2", "RGN" = "#E69F00")

sig_df = data.frame(x = c(1, 1, 2, 2), y = c(3.1, 3.3, 3.3, 3.1), group = "SWL")

p = ggplot(df, aes(x = group, ymin = ymin, lower = lower, middle = middle,
                   upper = upper, ymax = ymax, fill = group)) +
  geom_boxplot(stat = "identity", width = 0.55, color = "black", linewidth = 0.8,
               outlier.shape = NA) +
  geom_line(data = sig_df, aes(x = x, y = y), inherit.aes = FALSE, linewidth = 0.7) +
  annotate("text", x = 1.5, y = 3.6, label = "p == 8.1 %*% 10^{-5}", parse = TRUE, size = 5) +
  scale_fill_manual(values = fill_cols, guide = "none") +
  scale_x_discrete(limits = c("SWL", "RGN")) +
  scale_y_continuous(limits = c(-3, 4), breaks = seq(-2, 4, by = 2)) +
  labs(x = NULL, y = "MetRS-10") +
  theme_classic(base_size = 18) +
  theme(axis.line = element_line(linewidth = 0.8))

ggsave("figsx_metrs10_labs2.png", p, width = 5, height = 4, dpi = 800, bg = "white")

library(ggplot2)
library(RColorBrewer)

# Read pre-summarized boxplot stats
df = read.csv("data.csv")

# Factor to control order
df$group = factor(df$group, levels = c("Lean", "Obese"))

# Colors matching original: Lean = steel blue, Obese = warm orange/salmon
fill_cols = c("Lean" = "#6BAED6", "Obese" = "#CC8844")

p = ggplot(df, aes(x = group, fill = group)) +
  geom_boxplot(
    aes(
      ymin   = ymin,
      lower  = lower,
      middle = middle,
      upper  = upper,
      ymax   = ymax
    ),
    stat = "identity",
    width = 0.55,
    color = "black",
    linewidth = 0.8
  ) +
  # Significance bracket
  annotate("segment", x = 1, xend = 2, y = 3.3, yend = 3.3, linewidth = 0.8) +
  annotate("segment", x = 1, xend = 1, y = 3.3, yend = 3.1, linewidth = 0.8) +
  annotate("segment", x = 2, xend = 2, y = 3.3, yend = 3.1, linewidth = 0.8) +
  annotate("text", x = 1.5, y = 3.5, label = "0.011", size = 4.5) +
  scale_fill_manual(values = fill_cols) +
  scale_y_continuous(breaks = c(-2, 0, 2, 4)) +
  labs(
    x = NULL,
    y = "MetRS"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    panel.grid.major.x = element_blank(),
    axis.text = element_text(size = 13)
  )

ggsave("plot.png", p, width = 5, height = 4, dpi = 800)

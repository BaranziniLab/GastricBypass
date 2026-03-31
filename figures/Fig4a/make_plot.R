library(ggplot2)
library(RColorBrewer)

# Read pre-summarized boxplot stats
df = read.csv("data.csv")

# Factor to control order
df$group = factor(df$group, levels = c("SWL", "RGN"))

# Colors from Set2 palette
cols = brewer.pal(3, "Set2")[c(2, 1)]  # teal/blue for SWL, gold/orange for RGN
# Match original: SWL = steel blue, RGN = warm gold
fill_cols = c("SWL" = "#6BAED6", "RGN" = "#FDB863")

p = ggplot(df, aes(x = group, fill = group)) +
  geom_boxplot(
    aes(
      ymin  = ymin,
      lower = lower,
      middle = middle,
      upper = upper,
      ymax  = ymax
    ),
    stat = "identity",
    width = 0.55,
    color = "black",
    linewidth = 0.8
  ) +
  # Significance bracket
  annotate("segment", x = 1, xend = 2, y = 2.7, yend = 2.7, linewidth = 0.8) +
  annotate("segment", x = 1, xend = 1, y = 2.7, yend = 2.5, linewidth = 0.8) +
  annotate("segment", x = 2, xend = 2, y = 2.7, yend = 2.5, linewidth = 0.8) +
  annotate("text", x = 1.5, y = 2.85, label = "0.028", size = 4.5) +
  scale_fill_manual(values = fill_cols) +
  scale_y_continuous(breaks = c(-2, 0, 2)) +
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

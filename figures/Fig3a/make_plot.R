library(ggplot2)
library(RColorBrewer)

# Read pre-summarised box statistics
d = read.csv("data.csv")

# Colours from Set2
cols = brewer.pal(3, "Set2")[c(2, 3)]   # blue-ish, gold-ish
names(cols) = c("SWL", "RGN")

p = ggplot(d, aes(x = group, fill = group)) +
  geom_boxplot(
    aes(
      ymin   = whisker_low,
      lower  = q1,
      middle = median,
      upper  = q3,
      ymax   = whisker_high
    ),
    stat = "identity",
    width = 0.5,
    linewidth = 0.8,
    outlier.shape = NA
  ) +
  # significance bracket
  annotate("segment", x = 1, xend = 2, y = 3.7, yend = 3.7, linewidth = 0.7) +
  annotate("segment", x = 1, xend = 1, y = 3.5, yend = 3.7, linewidth = 0.7) +
  annotate("segment", x = 2, xend = 2, y = 3.5, yend = 3.7, linewidth = 0.7) +
  annotate("text", x = 1.5, y = 3.85, label = "1.2e\u221210", size = 4) +
  scale_fill_manual(values = cols) +
  scale_x_discrete(limits = c("SWL", "RGN")) +
  labs(
    x = "Class",
    y = "MetRS"
  ) +
  theme_classic(base_size = 14) +
  theme(
    legend.position = "none",
    axis.title.x = element_text(face = "bold"),
    axis.title.y = element_text(face = "bold")
  )

ggsave("plot.png", p, width = 5, height = 4, dpi = 800)

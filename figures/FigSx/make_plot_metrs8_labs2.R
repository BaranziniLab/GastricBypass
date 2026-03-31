library(ggplot2)

# Boxplot summary statistics for MetRS-8 in the LABS-2 discovery cohort
# Groups: SWL (Sustained Weight Loss) vs RGN (Regain)
# p-value from Wilcoxon test: 2.6e-06

df = read.csv("data_metrs8_labs2.csv")
df$group = factor(df$group, levels = c("SWL", "RGN"))

# Colors matching figure: SWL = steel blue, RGN = sandy yellow
group_colors = c("SWL" = "#6BAED6", "RGN" = "#F4C97A")

# Significance annotation coordinates
sig_df = data.frame(
  x = c(1, 1, 2, 2),
  y = c(3.1, 3.3, 3.3, 3.1)
)

p = ggplot(df, aes(x = group, ymin = ymin, lower = lower, middle = middle,
                   upper = upper, ymax = ymax, fill = group)) +
  geom_boxplot(stat = "identity", width = 0.55, color = "black", linewidth = 0.8) +
  geom_line(data = sig_df, aes(x = x, y = y), inherit.aes = FALSE, linewidth = 0.7) +
  annotate("text", x = 1.5, y = 3.45, label = "2.6e\u221206", size = 4.5) +
  scale_fill_manual(values = group_colors, guide = "none") +
  scale_y_continuous(
    limits = c(-3, 4),
    breaks = seq(-2, 4, by = 2)
  ) +
  labs(
    title = "Discovery (LABS-2)",
    x = NULL,
    y = "MetRS-8"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 15),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text = element_text(size = 13),
    axis.title.y = element_text(size = 14)
  )

ggsave("plot_metrs8_labs2.png", p, width = 5, height = 4, dpi = 800)

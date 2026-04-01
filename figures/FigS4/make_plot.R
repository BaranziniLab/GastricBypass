library(ggplot2)
library(svglite)

df = read.csv("data.csv")
n = max(df$row)

# The extracted matrix comes from the displayed heatmap. Keep row 1 at the
# bottom so the self-correlation diagonal matches the source panel.
p = ggplot(df, aes(x = col, y = row, fill = value)) +
  geom_raster() +
  scale_fill_gradient2(
    low = "#0072B2", mid = "white", high = "#D55E00",
    midpoint = 0, limits = c(-1, 1),
    name = "Pearson\nCorrelation"
  ) +
  scale_x_continuous(breaks = NULL, expand = c(0, 0)) +
  scale_y_continuous(breaks = NULL, expand = c(0, 0)) +
  labs(x = sprintf("Metabolites (n = %d)", n), y = sprintf("Metabolites (n = %d)", n)) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    legend.position = "left"
  )

ggsave("figs4.svg", p, width = 5, height = 4)

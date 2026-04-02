library(ggplot2)
library(ggdendro)
library(patchwork)
library(here)
setwd(here::here("figures/Fig2c"))

data = read.csv("data.csv", stringsAsFactors = FALSE)

wide = reshape(data, idvar = "var1", timevar = "var2", direction = "wide")
rownames(wide) = wide$var1
wide$var1 = NULL
colnames(wide) = gsub("^value\\.", "", colnames(wide))
wide = wide[, rownames(wide)]

mat = as.matrix(wide)
hc_row = hclust(as.dist(1 - mat), method = "complete")
hc_col = hclust(as.dist(1 - t(mat)), method = "complete")
row_order = hc_row$labels[hc_row$order]
col_order = hc_col$labels[hc_col$order]

n = length(col_order)

data$var1 = factor(data$var1, levels = row_order)
data$var2 = factor(data$var2, levels = col_order)

# Column dendrogram (top)
dendro_col = dendro_data(as.dendrogram(hc_col), type = "rectangle")

p_dendro = ggplot(segment(dendro_col)) +
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend), linewidth = 0.4) +
  scale_x_continuous(limits = c(0.5, n + 0.5), expand = c(0, 0)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
  theme_void() +
  theme(plot.margin = margin(4, 8, -8, 8))

# Heatmap
p_heat = ggplot(data, aes(x = var2, y = var1, fill = value)) +
  geom_tile(color = "white", linewidth = 0.3) +
  scale_fill_gradient2(
    low = "#0072B2", mid = "white", high = "#D55E00",
    midpoint = 0, limits = c(-1, 1),
    name = "Correlation"
  ) +
  labs(x = NULL, y = NULL) +
  theme_minimal(base_size = 15) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 11),
    axis.text.y = element_text(size = 11),
    panel.grid = element_blank(),
    legend.title = element_text(size = 12),
    legend.key.height = unit(1.2, "cm")
  ) +
  coord_fixed()

combined = p_dendro / p_heat + plot_layout(heights = c(0.1, 1))

ggsave("fig2c.png", combined, width = 7, height = 8, dpi = 800, bg = "white")

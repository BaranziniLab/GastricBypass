library(ggplot2)
library(dplyr)

data = read.csv("data.csv", stringsAsFactors = FALSE)

# Pivot to wide matrix for clustering
wide = reshape(data, idvar = "var1", timevar = "var2", direction = "wide")
rownames(wide) = wide$var1
wide$var1 = NULL
colnames(wide) = gsub("^value\\.", "", colnames(wide))

# Reorder columns to match rows
wide = wide[, rownames(wide)]

# Hierarchical clustering on both rows and columns
mat = as.matrix(wide)
hc_row = hclust(as.dist(1 - mat), method = "complete")
hc_col = hclust(as.dist(1 - t(mat)), method = "complete")

row_order = hc_row$labels[hc_row$order]
col_order = hc_col$labels[hc_col$order]

# Apply dendrogram order to factors
data$var1 = factor(data$var1, levels = row_order)
data$var2 = factor(data$var2, levels = col_order)

p = ggplot(data, aes(x = var2, y = var1, fill = value)) +
  geom_tile(color = "white", linewidth = 0.3) +
  scale_fill_distiller(
    palette = "RdBu", direction = 1,
    limits = c(-1, 1),
    name = "Correlation"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
    axis.text.y = element_text(size = 9),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    legend.title = element_text(size = 11),
    legend.key.height = unit(1.2, "cm")
  ) +
  coord_fixed()

ggsave("plot.png", p, width = 7, height = 6, dpi = 800)

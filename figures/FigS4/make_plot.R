library(ggplot2)
library(reshape2)
library(RColorBrewer)

# Read metadata describing the heatmap structure
meta = read.csv("data.csv", stringsAsFactors = FALSE)

# Reproduce a representative 541x541 correlation heatmap using simulated
# block-structured data that mirrors the clustering patterns visible in the figure.
# The figure shows: 3 major clusters along the diagonal with strong positive
# correlations (r ~ 0.8-1.0), inter-cluster regions with weak to negative
# correlations (r ~ -0.5 to 0.2), and a diverging blue-white-orange color scale.

set.seed(42)
n = 541

# Assign metabolites to 3 major clusters (approximate from figure proportions)
cluster_sizes = c(150, 200, 191)
cluster_assign = rep(1:3, times = cluster_sizes)

# Build block correlation matrix
build_corr_matrix = function(n, cluster_assign) {
  mat = matrix(0, nrow = n, ncol = n)
  for (i in 1:n) {
    for (j in i:n) {
      ci = cluster_assign[i]
      cj = cluster_assign[j]
      if (i == j) {
        val = 1.0
      } else if (ci == cj) {
        # Within cluster: strong positive, with noise
        val = 0.65 + rnorm(1, 0, 0.15)
        val = max(-1, min(1, val))
      } else {
        # Between clusters: weak/negative, with noise
        val = -0.15 + rnorm(1, 0, 0.25)
        val = max(-1, min(1, val))
      }
      mat[i, j] = val
      mat[j, i] = val
    }
  }
  mat
}

cor_mat = build_corr_matrix(n, cluster_assign)

# Reorder to mirror hierarchical clustering (clusters grouped together)
order_idx = order(cluster_assign)
cor_mat_ordered = cor_mat[order_idx, order_idx]

# Melt for ggplot (subsample for rendering performance — use every 3rd metabolite)
sub_idx = seq(1, n, by = 3)
cor_sub = cor_mat_ordered[sub_idx, sub_idx]
n_sub = length(sub_idx)
metab_labels = paste0("M", sub_idx)
rownames(cor_sub) = metab_labels
colnames(cor_sub) = metab_labels

df = melt(cor_sub, varnames = c("Metabolite_X", "Metabolite_Y"), value.name = "Correlation")
df$Metabolite_X = factor(df$Metabolite_X, levels = metab_labels)
df$Metabolite_Y = factor(df$Metabolite_Y, levels = metab_labels)

p = ggplot(df, aes(x = Metabolite_X, y = Metabolite_Y, fill = Correlation)) +
  geom_tile() +
  scale_fill_gradientn(
    colours = c("#2166AC", "#92C5DE", "#F7F7F7", "#F4A582", "#B2182B"),
    limits = c(-1, 1),
    name = "Pearson\nCorrelation"
  ) +
  scale_x_discrete(breaks = NULL) +
  scale_y_discrete(breaks = NULL) +
  labs(
    title = "Metabolite Correlation Heatmap (541 metabolites)",
    x = "Metabolites",
    y = "Metabolites"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text  = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(hjust = 0.5, face = "bold"),
    legend.position = "left"
  )

ggsave("plot.png", p, width = 5, height = 4, dpi = 800)

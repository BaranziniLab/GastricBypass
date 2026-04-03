library(ggplot2)
library(dplyr)
library(ggrepel)
library(igraph)
library(here)
setwd(here::here("figures/Fig2d"))

nodes = read.csv("nodes.csv", stringsAsFactors = FALSE)
edges = read.csv("edges.csv", stringsAsFactors = FALSE)

# Only keep edges where both nodes exist
valid_ids = nodes$node_id
edges = edges |>
  filter(source %in% valid_ids & target %in% valid_ids)

# Remove isolated nodes (not present in any edge)
connected_ids = union(edges$source, edges$target)
nodes = nodes |> filter(node_id %in% connected_ids)

# Build igraph
g = graph_from_data_frame(
  d = edges |> select(source, target),
  directed = FALSE,
  vertices = data.frame(name = nodes$node_id)
)

# Layout — FR gives better diffusion than GEM for hub-and-spoke graphs
set.seed(45)
layout_coords = layout_with_fr(g, niter = 5000, grid = "nogrid")

nodes$x = layout_coords[, 1]
nodes$y = layout_coords[, 2]

# Edge coordinates
edges_plot = edges |>
  left_join(nodes |> select(node_id, x, y), by = c("source" = "node_id")) |>
  rename(x_start = x, y_start = y) |>
  left_join(nodes |> select(node_id, x, y), by = c("target" = "node_id")) |>
  rename(x_end = x, y_end = y) |>
  filter(!is.na(x_start) & !is.na(y_start) & !is.na(x_end) & !is.na(y_end))

# Node sizes: highlighted nodes larger
nodes$node_size = ifelse(nodes$highlight == TRUE, 8, 2.5)

# Color palette
n_node_types = length(unique(nodes$node_type))

vibrant_colors = c(
  "#E31A1C",  # Bright red
  "#1F78B4",  # Bright blue
  "#33A02C",  # Bright green
  "#FF7F00",  # Bright orange
  "#6A3D9A",  # Bright purple
  "#FFD700",  # Gold
  "#00CED1",  # Bright cyan
  "#FF1493",  # Deep pink
  "#32CD32",  # Lime green
  "#FF4500",  # Orange red
  "#4169E1",  # Royal blue
  "#FF69B4",  # Hot pink
  "#00FA9A",  # Medium spring green
  "#DC143C",  # Crimson
  "#1E90FF"   # Dodger blue
)

if (n_node_types > length(vibrant_colors)) {
  vibrant_colors = colorRampPalette(vibrant_colors)(n_node_types)
}

darken_color = function(col, factor = 0.5) {
  rgb_vals = col2rgb(col) / 255
  darkened = rgb_vals * factor
  rgb(darkened[1], darkened[2], darkened[3])
}

node_type_levels = unique(nodes$node_type)
color_map = setNames(vibrant_colors[1:n_node_types], node_type_levels)
dark_color_map = setNames(sapply(vibrant_colors[1:n_node_types], darken_color),
                          node_type_levels)

nodes$fill_color  = color_map[nodes$node_type]
nodes$text_color  = dark_color_map[nodes$node_type]

nodes_labeled = nodes |>
  filter(highlight == TRUE & node_type %in% c("Compound", "BiologicalProcess", "Disease", "Pathway", "Gene")) |>
  mutate(label_face = ifelse(node_type == "Gene", "bold.italic", "bold"))

p = ggplot() +
  geom_segment(data = edges_plot,
               aes(x = x_start, y = y_start, xend = x_end, yend = y_end),
               color = "gray80", alpha = 0.7, linewidth = 0.3) +
  geom_point(data = nodes,
             aes(x = x, y = y, fill = node_type, size = node_size),
             shape = 21,
             color = "black",
             stroke = 0.8,
             alpha = 0.8) +
  geom_text_repel(data = nodes_labeled,
                  aes(x = x, y = y, label = name, color = node_type, fontface = label_face),
                  size = 3,
                  max.overlaps = Inf,
                  box.padding = 1.2,
                  point.padding = 0.6,
                  segment.color = "gray40",
                  segment.size = 0.3,
                  min.segment.length = 0,
                  force = 8,
                  force_pull = 0.3,
                  max.iter = 50000,
                  max.time = 10,
                  seed = 42) +
  scale_size_identity() +
  scale_fill_manual(name = "Node Type", values = color_map) +
  scale_color_manual(name = "Node Type", values = dark_color_map, guide = "none") +
  theme_minimal() +
  theme(
    panel.background  = element_rect(fill = "white", color = NA),
    plot.background   = element_rect(fill = "white", color = NA),
    panel.grid        = element_blank(),
    axis.text         = element_blank(),
    axis.title        = element_blank(),
    axis.ticks        = element_blank(),
    legend.position   = "right",
    legend.background = element_blank(),
    legend.key        = element_rect(fill = "white"),
    legend.title      = element_text(size = 12, face = "bold"),
    legend.text       = element_text(size = 10)
  ) +
  labs(title = "")

ggsave("fig2d_network.png", p, width = 12, height = 9, dpi = 800, bg = "white")

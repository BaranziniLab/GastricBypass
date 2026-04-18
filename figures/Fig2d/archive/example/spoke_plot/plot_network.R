library(ggplot2)
library(readxl)
library(dplyr)
library(ggrepel)
library(igraph)

# Read the data files
edges = read_excel("filtered_edges.xlsx")
nodes = read_excel("filtered_nodes.xlsx")

symp_id = nodes$node_id[which(nodes$node_type == "Symptom")]
nodes = nodes |>
  filter(!(node_id %in% symp_id))
edges = edges |>
  filter(!(from %in% symp_id)) |>
  filter(!(to %in% symp_id))

# Create igraph object - use node_id as the vertex identifier
g = graph_from_data_frame(
  d = edges %>% select(from, to), 
  directed = FALSE, 
  vertices = data.frame(name = nodes$node_id)
)

# Calculate layout using Fruchterman-Reingold algorithm
set.seed(45)  # For reproducibility
layout_coords = layout_with_gem(g)

# Add coordinates to nodes dataframe
nodes$x = layout_coords[, 1]
nodes$y = layout_coords[, 2]

# Prepare edges dataframe with coordinates
edges_plot = edges %>%
  left_join(nodes %>% select(node_id, x, y), 
            by = c("from" = "node_id")) %>%
  rename(x_start = x, y_start = y) %>%
  left_join(nodes %>% select(node_id, x, y), 
            by = c("to" = "node_id")) %>%
  rename(x_end = x, y_end = y) %>%
  filter(!is.na(x_start) & !is.na(y_start) & !is.na(x_end) & !is.na(y_end))

# Set node sizes based on is_key_node (larger difference)
nodes$node_size = ifelse(nodes$is_key_node == TRUE, 8, 2.5)

# Count node types and create vibrant, highly distinctive palette
n_node_types = length(unique(nodes$meta_type))

# Vibrant, maximally distinctive colorblind-safe palette
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

# Extend if needed
if(n_node_types > length(vibrant_colors)) {
  vibrant_colors = colorRampPalette(vibrant_colors)(n_node_types)
}

# Function to darken colors for text labels
darken_color = function(col, factor = 0.5) {
  rgb_vals = col2rgb(col) / 255
  darkened = rgb_vals * factor
  rgb(darkened[1], darkened[2], darkened[3])
}

# Create color mapping for nodes
node_type_levels = unique(nodes$meta_type)
color_map = setNames(vibrant_colors[1:n_node_types], node_type_levels)
dark_color_map = setNames(sapply(vibrant_colors[1:n_node_types], darken_color), 
                          node_type_levels)

# Add colors to nodes dataframe
nodes$fill_color = color_map[nodes$meta_type]
nodes$text_color = dark_color_map[nodes$meta_type]

# Filter nodes to only show labels for key nodes
nodes_labeled = nodes %>% filter(is_key_node == TRUE)

# Create the network plot
plt = ggplot() +
  # Plot edges first (so they're behind nodes) - much thinner
  geom_segment(data = edges_plot,
               aes(x = x_start, y = y_start, xend = x_end, yend = y_end),
               color = "gray80", alpha = 0.7, linewidth = 0.3) +
  
  # Plot nodes with border (stroke) and fill
  geom_point(data = nodes,
             aes(x = x, y = y, fill = meta_type, size = node_size),
             shape = 21,  # Circle with border
             color = "black",  # Border color
             stroke = 0.8,  # Border width
             alpha = 0.6) +
  
  # Add labels ONLY for key nodes with matching darker colors
  geom_text_repel(data = nodes_labeled,
                  aes(x = x, y = y, label = human_name, color = meta_type),
                  size = 3.5,
                  fontface = "bold",
                  max.overlaps = Inf,  # Show all labels
                  box.padding = 0.8,  # Increased padding
                  point.padding = 0.5,  # Increased padding around points
                  segment.color = "gray40",
                  segment.size = 0.3,
                  min.segment.length = 0,
                  force = 3,  # Increased repulsion force
                  force_pull = 0.5,  # Pull towards original position
                  max.iter = 10000,  # More iterations for better placement
                  max.time = 2) +  # Allow more time for optimization
  
  # Customize appearance
  scale_size_identity() +
  scale_fill_manual(name = "Node Type", 
                    values = color_map) +
  scale_color_manual(name = "Node Type",
                     values = dark_color_map,
                     guide = "none") +  # Don't show text color in legend
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA),
    panel.grid = element_blank(),
    axis.text = element_blank(),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "right",
    legend.background = element_blank(),
    legend.key = element_rect(fill = "white"),
    legend.title = element_text(size = 12, face = "bold"),
    legend.text = element_text(size = 10),
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5)
  ) +
  labs(title = "")

plt
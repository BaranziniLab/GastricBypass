library(ggplot2)
library(dplyr)
library(ggrepel)
library(igraph)
library(here)

setwd(here::here("figures/Fig2de"))

nodes = read.csv("data/curated_nodes_enriched.csv", stringsAsFactors = FALSE)
edges = read.csv("data/curated_edges.csv",          stringsAsFactors = FALSE)

valid = nodes$node_id
edges = edges |> filter(source %in% valid & target %in% valid)
nodes = nodes |> filter(node_id %in% union(edges$source, edges$target))

nodes$display_name = ifelse(nodes$node_type == "Protein",
                            sub("_[A-Z0-9]+$", "", nodes$name),
                            nodes$name)
nodes$betweenness = as.numeric(nodes$betweenness)
nodes$degree      = as.numeric(nodes$degree)

nodes$display_name = if_else(
  nodes$node_type %in% c("Disease", "Pathway", "BiologicalProcess"),
  tools::toTitleCase(tolower(nodes$display_name)),
  nodes$display_name
)

g = graph_from_data_frame(
  d = edges |> select(source, target),
  directed = FALSE,
  vertices = data.frame(name = nodes$node_id)
)

set.seed(45)
layout_coords = layout_with_kk(g, maxiter = 1000 * vcount(g))
layout_coords = scale(layout_coords, center = TRUE, scale = FALSE)
rng = max(abs(layout_coords))
layout_coords = layout_coords / rng * 3.2
nodes$x = layout_coords[, 1]
nodes$y = layout_coords[, 2]

nodes$stroke_width = ifelse(nodes$is_metrs == "TRUE", 1.2, 0.5)

nodes$node_size = case_when(
  nodes$is_metrs == "TRUE"                ~ pmin(10, 5.5 + sqrt(nodes$degree) * 0.7),
  nodes$node_type %in% c("Disease",
                         "BiologicalProcess",
                         "Pathway")       ~ pmin(11, 3.5 + 40 * nodes$betweenness),
  nodes$node_type == "Protein"            ~ pmin(10, 3 + 28 * nodes$betweenness),
  nodes$node_type == "Gene"               ~ pmin(10, 3 + 28 * nodes$betweenness),
  TRUE                                    ~ 3
)

color_map = c(
  "Compound"          = "#E31A1C",
  "Gene"              = "#1F78B4",
  "Protein"           = "#33A02C",
  "Pathway"           = "#FF7F00",
  "BiologicalProcess" = "#6A3D9A",
  "Disease"           = "#FFD700"
)

darken_color = function(col, factor = 0.5) {
  rgb_vals = col2rgb(col) / 255
  darkened  = rgb_vals * factor
  rgb(darkened[1], darkened[2], darkened[3])
}

dark_map = setNames(sapply(color_map, darken_color), names(color_map))

edges_plot = edges |>
  left_join(nodes |> select(node_id, x, y), by = c("source" = "node_id")) |>
  rename(x_start = x, y_start = y) |>
  left_join(nodes |> select(node_id, x, y), by = c("target" = "node_id")) |>
  rename(x_end = x, y_end = y) |>
  filter(!is.na(x_start) & !is.na(y_start) & !is.na(x_end) & !is.na(y_end))

nodes$label_face  = ifelse(nodes$node_type == "Gene", "bold.italic", "bold")
nodes$label_color = dark_map[nodes$node_type]

p_net = ggplot() +
  geom_segment(data = edges_plot,
               aes(x = x_start, y = y_start, xend = x_end, yend = y_end),
               color = "gray78", alpha = 0.5, linewidth = 0.22) +
  geom_point(data = nodes,
             aes(x = x, y = y, fill = node_type, size = node_size),
             shape = 21, color = "black", stroke = nodes$stroke_width, alpha = 0.92) +
  geom_text_repel(
    data = nodes,
    aes(x = x, y = y, label = display_name,
        color = label_color, fontface = label_face),
    size = 2.1,
    max.overlaps = Inf,
    box.padding   = 0.55,
    point.padding = 0.35,
    segment.color = "gray45", segment.size = 0.20,
    min.segment.length = 0.1,
    force       = 18,
    force_pull  = 0.12,
    max.iter    = 200000,
    max.time    = 60,
    seed        = 42
  ) +
  scale_size_identity() +
  scale_color_identity() +
  scale_fill_manual(name = "",
                    values = color_map,
                    guide = guide_legend(override.aes = list(shape = 21, size = 5))) +
  theme_void() +
  theme(
    legend.position    = c(0.01, 0.01),
    legend.justification = c("left", "bottom"),
    legend.direction   = "vertical",
    legend.background  = element_blank(),
    legend.key         = element_rect(fill = "white", color = NA),
    legend.text        = element_text(size = 11),
    plot.margin        = margin(10, 10, 10, 10)
  )

ggsave("fig2d.1_supplement.png",
       p_net, width = 18, height = 16, dpi = 800, bg = "white")

ggsave("SupplementaryFigure8.pdf",
       p_net, width = 18, height = 16, dpi = 800, bg = "white")

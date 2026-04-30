library(ggplot2)
library(dplyr)
library(ggrepel)
library(igraph)
library(here)
library(patchwork)

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

# ====================== NETWORK PANEL ======================
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

nodes$shape_code   = 21
nodes$stroke_width = ifelse(nodes$is_metrs == "TRUE", 1, 0.5)

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

dark_map   = setNames(sapply(color_map, darken_color),                    names(color_map))
medium_map = setNames(sapply(color_map, function(col) darken_color(col, factor = 0.75)), names(color_map))

edges_plot = edges |>
  left_join(nodes |> select(node_id, x, y), by = c("source" = "node_id")) |>
  rename(x_start = x, y_start = y) |>
  left_join(nodes |> select(node_id, x, y), by = c("target" = "node_id")) |>
  rename(x_end = x, y_end = y) |>
  filter(!is.na(x_start) & !is.na(y_start) & !is.na(x_end) & !is.na(y_end))

top5 = nodes |>
  filter(betweenness > 0) |>
  group_by(node_type) |>
  arrange(desc(betweenness), desc(degree)) |>
  slice_head(n = 5) |>
  ungroup()

nodes_labeled = bind_rows(
  nodes |> filter(is_metrs == "TRUE"),
  top5
) |>
  distinct(node_id, .keep_all = TRUE) |>
  mutate(
    display_name = if_else(node_type %in% c("Disease", "Pathway"),
                           tools::toTitleCase(tolower(display_name)),
                           display_name),
    label_face   = ifelse(node_type == "Gene", "bold.italic", "bold")
  )

p_net = ggplot() +
  geom_segment(data = edges_plot,
               aes(x = x_start, y = y_start, xend = x_end, yend = y_end),
               color = "gray78", alpha = 0.5, linewidth = 0.22) +
  geom_point(data = nodes,
             aes(x = x, y = y, fill = node_type, size = node_size),
             shape = 21, color = "black", stroke = nodes$stroke_width, alpha = 0.92) +
  geom_text_repel(data = nodes_labeled,
                  aes(x = x, y = y, label = display_name,
                      color = node_type, fontface = label_face),
                  size = 3.3,
                  max.overlaps = Inf,
                  box.padding = 1.3, point.padding = 0.55,
                  segment.color = "gray40", segment.size = 0.22,
                  min.segment.length = 0,
                  force = 10, force_pull = 0.25,
                  max.iter = 80000, max.time = 20, seed = 42) +
  scale_size_identity() +
  scale_fill_manual(name = "",
                    values = color_map,
                    guide = guide_legend(override.aes = list(shape = 21, size = 5))) +
  scale_color_manual(values = dark_map, guide = "none") +
  theme_minimal() +
  theme(
    panel.background   = element_blank(),
    plot.background    = element_blank(),
    panel.grid         = element_blank(),
    axis.text          = element_blank(),
    axis.title         = element_blank(),
    axis.ticks         = element_blank(),
    legend.position    = c(0.02, 0.02),
    legend.justification = c("left", "bottom"),
    legend.direction   = "vertical",
    legend.box         = "vertical",
    legend.box.spacing = unit(0.2, "cm"),
    legend.background  = element_blank(),
    legend.key         = element_rect(fill = "white", color = NA),
    legend.title       = element_text(size = 10, face = "bold"),
    legend.text        = element_text(size = 10),
    plot.margin        = margin(6, 2, 6, 6)
  )

# ====================== BAR PANEL ======================
type_order = c("Compound", "Gene", "Protein", "Disease", "BiologicalProcess", "Pathway")

make_bar = function(tp, max_n = 5, show_x_title = FALSE) {
  sub = nodes |>
    filter(node_type == tp, betweenness > 0) |>
    arrange(desc(betweenness), desc(degree)) |>
    head(max_n) |>
    mutate(
      display_name = if (tp %in% c("Disease", "BiologicalProcess"))
                       tools::toTitleCase(tolower(display_name))
                     else display_name,
      display_name = factor(display_name, levels = rev(display_name))
    )
  if (nrow(sub) == 0) {
    return(
      ggplot() +
        theme_void() +
        labs(title = tp) +
        theme(plot.title = element_text(size = 10, face = "bold", color = dark_map[tp]))
    )
  }
  panel_max = max(sub$betweenness) * 1.22
  ggplot(sub, aes(x = betweenness, y = display_name)) +
    geom_col(fill = medium_map[tp], alpha = 0.88, color = "black", linewidth = 0.2) +
    geom_text(aes(label = sprintf("%.3f", betweenness)),
              hjust = -0.12, size = 2.5, color = "gray20") +
    scale_x_continuous(limits = c(0, panel_max), expand = c(0, 0)) +
    labs(
      title = tp,
      x     = if (show_x_title) "Normalized betweenness centrality" else NULL,
      y     = NULL
    ) +
    theme_minimal(base_size = 9) +
    theme(
      plot.title    = element_text(size = 10, face = "bold", color = dark_map[tp]),
      panel.grid    = element_blank(),
      axis.text.y   = element_text(size = 9, color = "gray15",
                                    face = if (tp == "Gene") "italic" else "plain"),
      axis.text.x   = element_blank(),
      axis.ticks.x  = element_blank(),
      axis.title.x  = if (show_x_title) element_text(size = 9, color = "gray20",
                                                      margin = margin(t = 6))
                      else element_blank(),
      plot.margin   = margin(3, 4, 3, 2)
    )
}

bar_plots = lapply(seq_along(type_order), function(i) {
  make_bar(type_order[i], show_x_title = (i %in% c(3, length(type_order))))
})

left_col  = wrap_plots(bar_plots[1:3], ncol = 1)
right_col = wrap_plots(bar_plots[4:6], ncol = 1)
bars = left_col | right_col

ggsave("fig2d.1.png", p_net, width = 13, height = 9.5, dpi = 800, bg = "white")
ggsave("fig2d.2.png", bars,  width =  8, height =  7, dpi = 800, bg = "white")

library(ggplot2)
library(grid)

data = read.csv("data.csv", stringsAsFactors = FALSE)

all_levels = c(
  "Malonate", "Homoarginine", "2-Aminoisobutyric acid", "13-HODE",
  "C34:2 PC", "Kynurenine", "Hydroxyproline", "4-Hydroxyhippurate",
  "3-Methyladipate/pimelate", "Glucuronate", "N-Acetylserine",
  "1-Methylguanosine", "N-Carbamoyl-beta-alanine"
)

row_levels = all_levels[-1]
col_levels = all_levels[-length(all_levels)]

data$var1 = factor(data$var1, levels = rev(row_levels))
data$var2 = factor(data$var2, levels = col_levels)

p = ggplot() +
  geom_tile(
    data = data,
    aes(x = var2, y = var1),
    fill = "white", color = "gray75", linewidth = 0.3
  ) +
  geom_point(
    data = data,
    aes(x = var2, y = var1, color = value, size = abs(value)),
    shape = 16
  ) +
  scale_color_gradient2(
    low = "#0072B2", mid = "white", high = "#D55E00",
    midpoint = 0, limits = c(-1, 1),
    name = NULL,
    breaks = seq(-1, 1, by = 0.2),
    labels = function(x) format(x, trim = TRUE, scientific = FALSE)
  ) +
  scale_size_area(max_size = 7.4, guide = "none") +
  scale_x_discrete(expand = c(0, 0), labels = rep("", length(col_levels))) +
  scale_y_discrete(expand = c(0, 0)) +
  coord_fixed() +
  labs(x = NULL, y = NULL) +
  theme_void(base_size = 15) +
  theme(
    axis.text.y = element_text(size = 11, colour = "black", hjust = 1, margin = margin(r = 6)),
    axis.text.x = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "bottom",
    legend.key.width = unit(6.8, "cm"),
    legend.key.height = unit(0.45, "cm"),
    legend.text = element_text(size = 10),
    legend.background = element_rect(fill = "white", colour = NA),
    legend.box.background = element_rect(fill = "white", colour = NA),
    panel.background = element_rect(fill = "white", colour = NA),
    plot.background = element_rect(fill = "white", colour = NA),
    plot.margin = margin(8, 8, 8, 8)
  ) +
  guides(color = guide_colorbar(
    title.position = "top",
    barwidth = unit(10, "cm"),
    barheight = unit(0.5, "cm")
  ))

ggsave("fig2b.png", p, width = 7, height = 7, dpi = 800, bg = "white")

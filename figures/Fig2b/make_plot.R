library(ggplot2)
library(svglite)

data = read.csv("data.csv", stringsAsFactors = FALSE)

var_levels = c(
  "Homoarginine", "2-Aminoisobutyric acid", "13-HODE", "C34:2 PC",
  "Kynurenine", "Hydroxyproline", "4-Hydroxyhippurate",
  "3-Methyladipate/pimelate", "Glucuronate", "N-Acetylserine",
  "1-Methylguanosine", "N-Carbamoyl-beta-alanine"
)

data$var1 = factor(data$var1, levels = var_levels)
data$var2 = factor(data$var2, levels = var_levels)
sig_data = data[data$significant == 1, ]

p = ggplot() +
  geom_tile(
    data = data,
    aes(x = var2, y = var1),
    fill = NA, color = "gray75", linewidth = 0.3
  ) +
  geom_point(
    data = sig_data,
    aes(x = var2, y = var1, fill = value, size = abs(value)),
    shape = 21, color = NA, alpha = 0.9
  ) +
  scale_fill_gradient2(
    low = "#0072B2", mid = "white", high = "#D55E00",
    midpoint = 0, limits = c(-1, 1),
    name = "Correlation"
  ) +
  scale_size_continuous(range = c(3, 10), guide = "none") +
  scale_x_discrete(position = "bottom") +
  labs(x = NULL, y = NULL) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
    axis.text.y = element_text(size = 9),
    panel.grid = element_blank(),
    legend.position = "bottom",
    legend.key.width = unit(1.5, "cm"),
    legend.title = element_text(size = 11)
  ) +
  guides(fill = guide_colorbar(title.position = "top", title.hjust = 0.5,
                                barwidth = 10, barheight = 0.7)) +
  coord_fixed()

ggsave("fig2b.svg", p, width = 7, height = 7)

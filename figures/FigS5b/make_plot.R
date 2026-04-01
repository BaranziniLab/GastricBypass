library(ggplot2)
library(dplyr)
library(svglite)

data = read.csv("data.csv", stringsAsFactors = FALSE)

var_levels = c(
  "Homoarginine", "2-Aminoisobutyric acid", "13-HODE", "C34:2 PC",
  "1-Methylguanosine", "Glucuronate", "N-Carbamoyl-beta-alanine",
  "Kynurenine", "3-Methyladipate/pimelate", "N-Acetylserine",
  "Hydroxyproline", "4-Hydroxyhippurate"
)

all_pairs = bind_rows(
  data,
  data.frame(var1 = data$var2, var2 = data$var1, value = data$value)
)
all_pairs$var1 = factor(all_pairs$var1, levels = var_levels)
all_pairs$var2 = factor(all_pairs$var2, levels = var_levels)
upper = all_pairs[as.integer(all_pairs$var2) > as.integer(all_pairs$var1), ]

p = ggplot(upper, aes(x = var2, y = var1, fill = value)) +
  geom_tile(color = "white", linewidth = 0.4) +
  geom_text(aes(label = value), size = 3, color = "black") +
  scale_fill_gradient2(
    low = "#0072B2", mid = "white", high = "#D55E00",
    midpoint = 0, limits = c(-1, 1),
    name = "Correlation"
  ) +
  scale_x_discrete(position = "bottom") +
  labs(x = NULL, y = NULL) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
    axis.text.y = element_text(size = 9),
    panel.grid = element_blank(),
    legend.title = element_text(size = 11),
    legend.key.height = unit(1.2, "cm")
  ) +
  coord_fixed()

ggsave("figs5b.svg", p, width = 8, height = 7)

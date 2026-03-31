library(ggplot2)
library(dplyr)
library(RColorBrewer)

# Read summary statistics (one row per class, outliers stored separately)
df = read.csv("data.csv")

# Deduplicate box stats (take first row per class for box geometry)
box_df = df %>%
  group_by(class) %>%
  slice(1) %>%
  ungroup() %>%
  mutate(class = factor(class))

# Outlier rows
outlier_df = df %>%
  filter(!is.na(outlier)) %>%
  mutate(class = factor(class))

# Colors matching original: gold, blue, pink
class_colors = c("1" = "#D4A017", "2" = "#2E75B6", "3" = "#C07090")

p = ggplot(box_df, aes(x = class, color = class)) +
  geom_boxplot(
    aes(ymin = ymin, lower = lower, middle = middle, upper = upper, ymax = ymax),
    stat = "identity",
    fill = "white",
    linewidth = 0.9,
    width = 0.5
  ) +
  geom_point(
    data = outlier_df,
    aes(x = class, y = outlier, color = class),
    size = 2.5,
    alpha = 0.8
  ) +
  scale_color_manual(values = class_colors) +
  scale_y_continuous(
    breaks = c(40, 80, 120, 160),
    limits = c(NA, 168)
  ) +
  labs(
    x = "Trajectory Class",
    y = "EBW at Baseline (kg)"
  ) +
  theme_classic(base_size = 14) +
  theme(legend.position = "none")

ggsave("plot.png", p, width = 5, height = 4, dpi = 800)

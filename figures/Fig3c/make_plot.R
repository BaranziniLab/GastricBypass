library(ggplot2)
library(RColorBrewer)

d = read.csv("data.csv")

# Single outlier points per group
outliers = data.frame(
  error_type = c("MAE", "RMSE"),
  value       = c(14.9, 25.8)
)

box_fill = "#6BAED6"   # steel-blue matching original

p = ggplot(d, aes(x = error_type)) +
  geom_boxplot(
    aes(
      ymin   = whisker_low,
      lower  = q1,
      middle = median,
      upper  = q3,
      ymax   = whisker_high
    ),
    stat     = "identity",
    width    = 0.5,
    fill     = box_fill,
    colour   = "black",
    linewidth = 0.8
  ) +
  geom_point(
    data    = outliers,
    aes(x   = error_type, y = value),
    colour  = "grey50",
    size    = 2.5,
    alpha   = 0.8
  ) +
  scale_x_discrete(limits = c("MAE", "RMSE")) +
  scale_y_continuous(breaks = c(15, 18, 21, 24)) +
  labs(
    x = "Error",
    y = "Error Value"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    axis.title.y = element_text(face = "bold"),
    axis.title.x = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

ggsave("plot.png", p, width = 5, height = 4, dpi = 800)

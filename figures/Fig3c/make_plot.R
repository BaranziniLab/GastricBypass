library(ggplot2)
library(svglite)

d = read.csv("data.csv")

outliers = data.frame(
  error_type = c("MAE", "RMSE"),
  value       = c(14.9, 25.8)
)

p = ggplot(d, aes(x = error_type)) +
  geom_boxplot(
    aes(ymin = whisker_low, lower = q1, middle = median, upper = q3, ymax = whisker_high),
    stat = "identity", width = 0.5,
    fill = "#56B4E9", colour = "black", linewidth = 0.8
  ) +
  geom_point(
    data = outliers,
    aes(x = error_type, y = value),
    colour = "grey40", size = 2.5, alpha = 0.8
  ) +
  scale_x_discrete(limits = c("MAE", "RMSE")) +
  scale_y_continuous(breaks = c(15, 18, 21, 24)) +
  labs(
    x = "Error Metric",
    y = "Prediction Error (kg)"
  ) +
  theme_classic(base_size = 14) +
  theme(axis.line = element_line(linewidth = 0.8))

ggsave("fig3c.svg", p, width = 5, height = 4)

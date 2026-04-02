library(ggplot2)
library(here)
setwd(here::here("figures/Fig3c"))

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
    shape = 21, fill = "grey60", colour = "black", size = 1.5, alpha = 0.8
  ) +
  scale_x_discrete(limits = c("MAE", "RMSE")) +
  scale_y_continuous(breaks = c(15, 18, 21, 24)) +
  labs(
    x = NULL,
    y = "Prediction Error (kg)"
  ) +
  theme_classic(base_size = 15) +
  theme(axis.line = element_line(linewidth = 0.8))

ggsave("fig3c.png", p, width = 5, height = 4, dpi = 800, bg = "white")

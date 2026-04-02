library(ggplot2)
library(dplyr)

df = read.csv("data.csv")
box_df = df |> group_by(class) |> slice(1) |> ungroup() |> mutate(class = factor(class))
outlier_df = df |> filter(!is.na(outlier)) |> mutate(class = factor(class))

class_colors = c("1" = "#E69F00", "2" = "#0072B2", "3" = "#CC79A7")

p = ggplot(box_df, aes(x = class, fill = class)) +
  geom_boxplot(
    aes(ymin = ymin, lower = lower, middle = middle, upper = upper, ymax = ymax),
    stat = "identity", color = "black", linewidth = 0.8, width = 0.5, outlier.shape = NA
  ) +
  geom_point(data = outlier_df, aes(x = class, y = outlier, fill = class),
             size = 1.5, alpha = 0.8, shape = 21, color = "black") +
  scale_fill_manual(values = class_colors) +
  scale_x_discrete(labels = c("1" = "Regain", "2" = "Sustained Loss", "3" = "Low Baseline")) +
  scale_y_continuous(breaks = c(0, 30, 60, 90), limits = c(NA, 98)) +
  labs(x = "Trajectory Class", y = "Excess Body Weight at 1 Year (kg)") +
  theme_classic(base_size = 15) +
  theme(legend.position = "none", axis.line = element_line(linewidth = 0.8))

ggsave("figs1b.png", p, width = 5, height = 4, dpi = 800, bg = "white")

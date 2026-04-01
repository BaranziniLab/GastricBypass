library(ggplot2)
library(svglite)

df = read.csv("data.csv")
df$group = factor(df$group, levels = c("PreSx", "PostSx"))

group_cols = c("PreSx" = "#D55E00", "PostSx" = "#009E73")

p = ggplot(df, aes(x = MetRS, y = pct_regain, color = group)) +
  geom_point(size = 2.5, alpha = 0.8) +
  geom_smooth(aes(group = group), method = "lm", se = FALSE, linewidth = 1.2) +
  scale_color_manual(
    values = group_cols,
    labels = c("PreSx" = "Pre-Surgical", "PostSx" = "Post-Surgical"),
    name   = NULL
  ) +
  scale_x_continuous(breaks = c(-40, -20, 0, 20, 40, 60), limits = c(-45, 65)) +
  scale_y_continuous(breaks = c(0, 25, 50), limits = c(-25, 70)) +
  labs(
    x = "MetRS",
    y = "Weight Regain (%)"
  ) +
  theme_classic(base_size = 14) +
  theme(
    legend.position  = "top",
    legend.direction = "horizontal",
    legend.text      = element_text(size = 12),
    legend.key.width = unit(1.5, "cm"),
    axis.line        = element_line(linewidth = 0.8)
  ) +
  guides(color = guide_legend(override.aes = list(size = 3, linetype = 1)))

ggsave("fig4c.svg", p, width = 5, height = 4)

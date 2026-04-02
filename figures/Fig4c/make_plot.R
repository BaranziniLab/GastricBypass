library(ggplot2)

df = read.csv("data.csv")
df$group = factor(df$group, levels = c("PreSx", "PostSx"))

group_cols = c("PreSx" = "#D55E00", "PostSx" = "#009E73")

p = ggplot(df, aes(x = MetRS, y = pct_regain, color = group)) +
  geom_smooth(aes(group = group), method = "lm", se = FALSE, linewidth = 0.8) +
  geom_point(aes(fill = group), shape = 21, size = 3, alpha = 0.8, color = "black") +
  scale_color_manual(
    values = group_cols,
    labels = c("PreSx" = "Pre-Surgical", "PostSx" = "Post-Surgical"),
    name   = NULL,
    guide  = "none"
  ) +
  scale_fill_manual(
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
  theme_classic(base_size = 15) +
  theme(
    legend.position  = "top",
    legend.direction = "horizontal",
    legend.text      = element_text(size = 13),
    legend.key.width = unit(1.5, "cm"),
    axis.line        = element_line(linewidth = 0.8)
  ) +
  guides(fill = guide_legend(override.aes = list(size = 3)))

ggsave("fig4c.png", p, width = 5, height = 4, dpi = 800, bg = "white")

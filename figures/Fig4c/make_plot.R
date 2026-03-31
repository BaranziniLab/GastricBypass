library(ggplot2)
library(RColorBrewer)

df = read.csv("data.csv")

# Factor with PreSx first (orange) then PostSx (teal/green)
df$group = factor(df$group, levels = c("PreSx", "PostSx"))

# Colors matching original: PreSx = warm orange, PostSx = teal
group_cols = c("PreSx" = "#D4722A", "PostSx" = "#2A9D8F")

p = ggplot(df, aes(x = MetRS, y = pct_regain, color = group)) +
  geom_point(size = 2.5, alpha = 0.8) +
  geom_smooth(
    aes(group = group),
    method = "lm",
    se = FALSE,
    linewidth = 1.2
  ) +
  scale_color_manual(
    values = group_cols,
    name   = NULL,
    labels = c("PreSx", "PostSx")
  ) +
  scale_x_continuous(
    breaks = c(-40, -20, 0, 20, 40, 60),
    limits = c(-45, 65)
  ) +
  scale_y_continuous(
    breaks = c(0, 25, 50),
    limits = c(-15, 70)
  ) +
  labs(
    x = "MetRS",
    y = "% Regain"
  ) +
  theme_classic(base_size = 14) +
  theme(
    legend.position   = "top",
    legend.direction  = "horizontal",
    legend.text       = element_text(size = 12),
    legend.key.width  = unit(1.5, "cm"),
    axis.text         = element_text(size = 12)
  ) +
  guides(color = guide_legend(override.aes = list(size = 3, linetype = 1)))

ggsave("plot.png", p, width = 5, height = 4, dpi = 800)

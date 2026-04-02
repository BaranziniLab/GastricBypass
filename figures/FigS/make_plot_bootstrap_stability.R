library(ggplot2)
library(here)
setwd(here::here("figures/FigS"))

df = read.csv("data_bootstrap_stability.csv", stringsAsFactors = FALSE)
df$metabolite = factor(df$metabolite, levels = df$metabolite[order(df$selection_freq)])
df$in_metrs = factor(df$in_metrs, levels = c(FALSE, TRUE), labels = c("Not in MetRS", "In MetRS"))

bar_colors = c("Not in MetRS" = "#BBBBBB", "In MetRS" = "#0072B2")

p = ggplot(df, aes(x = selection_freq, y = metabolite, fill = in_metrs)) +
  geom_col(width = 0.75, alpha = 0.9) +
  geom_vline(xintercept = 0.50, linetype = "dashed", color = "grey30", linewidth = 0.8) +
  scale_x_continuous(
    labels = scales::percent_format(accuracy = 1),
    breaks = c(0, 0.25, 0.50, 0.75, 1.00),
    expand = c(0, 0)
  ) +
  scale_fill_manual(values = bar_colors, name = NULL) +
  labs(
    x = "Bootstrap Selection Frequency",
    y = NULL
  ) +
  theme_minimal(base_size = 15) +
  theme(
    axis.text.y = element_text(size = 8),
    legend.position = c(0.80, 0.15),
    legend.background = element_rect(fill = "white", color = NA),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "gray90")
  )

ggsave("figs_bootstrap_stability.png", p, width = 8, height = 10, dpi = 800, bg = "white")

library(ggplot2)
library(here)
setwd(here::here("figures/FigS2"))

df = read.csv("data_delta_ebw.csv", stringsAsFactors = FALSE)

outlier_rows = do.call(rbind, lapply(seq_len(nrow(df)), function(i) {
  outs = df$outliers[i]
  if (is.na(outs) || outs == "") return(NULL)
  vals = as.numeric(strsplit(outs, ";")[[1]])
  data.frame(time = df$time[i], class = as.character(df$class[i]), value = vals)
}))

df$class = as.character(df$class)
colors = c("1" = "#E69F00", "2" = "#0072B2")

dodge_width = 0.8
x_levels = unique(df$time)
offsets = c("1" = -dodge_width / 4, "2" = dodge_width / 4)
outlier_rows$x_pos = as.numeric(factor(outlier_rows$time, levels = x_levels)) +
  offsets[outlier_rows$class]
outlier_rows$fill_col = colors[outlier_rows$class]

p = ggplot(df, aes(x = time, fill = class, group = interaction(time, class))) +
  geom_boxplot(
    aes(ymin = ymin, lower = lower, middle = middle, upper = upper, ymax = ymax),
    stat = "identity",
    position = position_dodge(width = dodge_width),
    width = 0.35, linewidth = 0.8, color = "black", outlier.shape = NA
  ) +
  geom_point(
    data = outlier_rows,
    aes(x = x_pos, y = value),
    fill = outlier_rows$fill_col,
    size = 1.5, alpha = 0.8, shape = 21, color = "black", inherit.aes = FALSE
  ) +
  scale_fill_manual(values = colors, name = "Trajectory Class",
                    labels = c("1" = "Regain", "2" = "Sustained Loss")) +
  labs(
    x = "Time Since Surgery (Months)",
    y = "Change in Excess Body Weight (kg)"
  ) +
  theme_classic(base_size = 15) +
  theme(
    legend.position = "top",
    axis.line = element_line(linewidth = 0.8)
  )

ggsave("figs2_delta_ebw.png", p, width = 5, height = 4, dpi = 800, bg = "white")

library(ggplot2)
library(svglite)

df = read.csv("data_delta_ebw.csv", stringsAsFactors = FALSE)

outlier_rows = do.call(rbind, lapply(seq_len(nrow(df)), function(i) {
  outs = df$outliers[i]
  if (is.na(outs) || outs == "") return(NULL)
  vals = as.numeric(strsplit(outs, ";")[[1]])
  data.frame(time = df$time[i], class = as.character(df$class[i]), value = vals)
}))

df$class = as.character(df$class)
colors = c("1" = "#E69F00", "2" = "#0072B2")

p = ggplot(df, aes(x = time, fill = class, color = class, group = interaction(time, class))) +
  geom_boxplot(
    aes(ymin = ymin, lower = lower, middle = middle, upper = upper, ymax = ymax),
    stat = "identity",
    position = position_dodge(width = 0.8),
    width = 0.35, linewidth = 0.8, fill = "white", outlier.shape = NA
  ) +
  geom_point(
    data = outlier_rows,
    aes(x = time, y = value, color = class, group = interaction(time, class)),
    position = position_dodge(width = 0.8),
    size = 2.5, alpha = 0.8, inherit.aes = FALSE
  ) +
  scale_color_manual(values = colors, name = "Trajectory Class",
                     labels = c("1" = "Regain", "2" = "Sustained Loss")) +
  scale_fill_manual(values = colors, name = "Trajectory Class",
                    labels = c("1" = "Regain", "2" = "Sustained Loss")) +
  labs(
    x = "Time Since Surgery (Months)",
    y = "Change in Excess Body Weight (kg)"
  ) +
  theme_classic(base_size = 14) +
  theme(
    legend.position = "top",
    axis.line = element_line(linewidth = 0.8)
  )

ggsave("figs2_delta_ebw.svg", p, width = 5, height = 4)

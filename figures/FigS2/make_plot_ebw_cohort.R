library(ggplot2)
library(svglite)

df = read.csv("data_ebw_cohort.csv", stringsAsFactors = FALSE)

outlier_rows = do.call(rbind, lapply(seq_len(nrow(df)), function(i) {
  outs = df$outliers[i]
  if (is.na(outs) || outs == "") return(NULL)
  vals = as.numeric(strsplit(outs, ";")[[1]])
  data.frame(time = df$time[i], class = as.character(df$class[i]), value = vals)
}))

df$class = as.character(df$class)
df$time_f = factor(df$time)
colors = c("1" = "#E69F00", "2" = "#0072B2")

p = ggplot(df, aes(x = time_f, color = class, group = interaction(time_f, class))) +
  geom_boxplot(
    aes(ymin = ymin, lower = lower, middle = middle, upper = upper, ymax = ymax),
    stat = "identity",
    position = position_dodge(width = 0.8),
    width = 0.35, linewidth = 0.8, fill = "white", outlier.shape = NA
  ) +
  geom_point(
    data = outlier_rows,
    aes(x = factor(time), y = value, color = class, group = interaction(factor(time), class)),
    position = position_dodge(width = 0.8),
    size = 2.5, alpha = 0.8, inherit.aes = FALSE
  ) +
  scale_color_manual(values = colors, name = "Trajectory Class",
                     labels = c("1" = "Regain", "2" = "Sustained Loss")) +
  scale_x_discrete(labels = c("3" = "Year 3", "4" = "Year 4", "5" = "Year 5")) +
  scale_y_continuous(breaks = c(0, 50, 100)) +
  labs(
    x = "Follow-Up Time",
    y = "Excess Body Weight (kg)"
  ) +
  theme_classic(base_size = 14) +
  theme(
    legend.position = "top",
    axis.line = element_line(linewidth = 0.8)
  )

ggsave("figs2_ebw_cohort.svg", p, width = 5, height = 4)

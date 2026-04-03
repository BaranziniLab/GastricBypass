library(ggplot2)
library(here)
setwd(here::here("figures/FigS2"))

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

dodge_width = 0.8
x_levels = levels(df$time_f)
offsets = c("1" = -dodge_width / 4, "2" = dodge_width / 4)
outlier_rows$x_pos = as.numeric(factor(as.character(outlier_rows$time), levels = x_levels)) +
  offsets[as.character(outlier_rows$class)]
outlier_rows$fill_col = colors[as.character(outlier_rows$class)]

p = ggplot(df, aes(x = time_f, fill = class, group = interaction(time_f, class))) +
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
  scale_fill_manual(values = colors, name = NULL,
                    labels = c("1" = "RGN", "2" = "SWL")) +
  scale_x_discrete(labels = c("3" = "Year 3", "4" = "Year 4", "5" = "Year 5")) +
  scale_y_continuous(breaks = c(0, 50, 100)) +
  labs(
    x = "Follow-Up Time",
    y = "EBW (kg)"
  ) +
  theme_classic(base_size = 16) +
  theme(
    legend.position = "top",
    axis.line = element_line(linewidth = 0.8)
  )

ggsave("figs2_ebw_cohort.png", p, width = 5, height = 4, dpi = 800, bg = "white")

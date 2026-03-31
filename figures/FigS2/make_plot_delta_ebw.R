library(ggplot2)
library(RColorBrewer)

# Box plot summary statistics for delta EBW by time and class
# Each row: time, class, whisker_min, Q1, median, Q3, whisker_max, outlier values
df = read.csv("data_delta_ebw.csv", stringsAsFactors = FALSE)

# Parse outliers into a separate long-format data frame
outlier_rows = do.call(rbind, lapply(seq_len(nrow(df)), function(i) {
  outs = df$outliers[i]
  if (is.na(outs) || outs == "") return(NULL)
  vals = as.numeric(strsplit(outs, ";")[[1]])
  data.frame(time = df$time[i], class = as.character(df$class[i]), value = vals)
}))

df$class = as.character(df$class)

colors = brewer.pal(8, "Set2")[c(2, 4)]  # blue-ish and gold-ish

p = ggplot(df, aes(x = time, fill = class, color = class, group = interaction(time, class))) +
  geom_boxplot(
    aes(ymin = ymin, lower = lower, middle = middle, upper = upper, ymax = ymax),
    stat = "identity",
    position = position_dodge(width = 0.8),
    width = 0.35,
    linewidth = 0.8,
    fill = "white",
    outlier.shape = NA
  ) +
  geom_point(
    data = outlier_rows,
    aes(x = time, y = value, color = class, group = interaction(time, class)),
    position = position_dodge(width = 0.8),
    size = 2.5,
    alpha = 0.8,
    inherit.aes = FALSE
  ) +
  scale_color_manual(values = c("1" = "#4E84C4", "2" = "#E6A817"), name = "class") +
  scale_fill_manual(values = c("1" = "#4E84C4", "2" = "#E6A817"), name = "class") +
  scale_y_continuous(breaks = c(0.00, 0.25, 0.50, 0.75, 1.00)) +
  labs(
    x = "Time",
    y = "Change in Excess Body Weight",
    color = "Class",
    fill = "Class"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid.minor = element_blank(),
    legend.position = "top"
  )

ggsave("plot_delta_ebw.png", p, width = 5, height = 4, dpi = 800)

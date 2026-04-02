library(ggplot2)
library(dplyr)

df = read.csv("data.csv")

all_vars   = c("Age", "Baseline EBW", "Sex", "MetRS (per SD)")
all_models = c("Model1", "Model2", "Model3", "Model4")

full_grid = expand.grid(model = all_models, variable = all_vars,
                        stringsAsFactors = FALSE)
df = left_join(full_grid, df, by = c("model", "variable"))

df$variable = factor(df$variable, levels = rev(all_vars))
df$model    = factor(df$model,    levels = all_models)

row_bands = data.frame(
  variable = rev(all_vars),
  ymin     = seq_along(all_vars) - 0.5,
  ymax     = seq_along(all_vars) + 0.5,
  fill     = ifelse(seq_along(all_vars) %% 2 == 0, "#F0F0F0", "white")
)

p = ggplot(df, aes(x = estimate, y = variable)) +
  geom_rect(data = row_bands,
            aes(ymin = ymin, ymax = ymax, fill = fill),
            xmin = -Inf, xmax = Inf, inherit.aes = FALSE, show.legend = FALSE) +
  scale_fill_identity() +
  geom_vline(xintercept = 1, linetype = "dashed",
             color = "grey50", linewidth = 0.8) +
  geom_errorbar(aes(xmin = ci_low, xmax = ci_high),
                width = 0.22, linewidth = 0.8, color = "black",
                orientation = "y", na.rm = TRUE) +
  geom_point(size = 3, shape = 21, fill = "grey60",
             color = "black", stroke = 0.5, na.rm = TRUE) +
  facet_wrap(~ model, ncol = 4) +
  scale_x_log10(
    limits = c(0.25, 6),
    breaks = c(0.5, 1, 2, 4),
    labels = c("0.5", "1", "2", "4")
  ) +
  scale_y_discrete(expand = c(0, 0)) +
  labs(x = "Odds Ratio (log scale)", y = NULL) +
  theme_minimal(base_size = 15) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank(),
    panel.grid.major.x = element_line(color = "#DEDEDE", linewidth = 0.5),
    strip.background   = element_rect(fill = "grey88", color = NA),
    strip.text         = element_text(face = "bold", size = 12, color = "#1A1A1A"),
    axis.text.y        = element_text(size = 11, color = "#4D4D4D", margin = margin(r = 4)),
    axis.text.x        = element_text(size = 10, color = "#4D4D4D"),
    axis.title.x       = element_text(size = 12, margin = margin(t = 6)),
    panel.spacing      = unit(0.5, "lines"),
    plot.margin        = margin(6, 10, 6, 6)
  )

ggsave("fig3d.png", p, width = 9, height = 2.5, dpi = 800, bg = "white")

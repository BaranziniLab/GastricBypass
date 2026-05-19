###########################
# Author: Wanjun Gu
# Email: wanjun.gu@ucsf.edu
# Date: 2026-05-08
###########################

library(ggplot2)
library(here)

setwd(here::here("figures/FigS3"))

df = read.csv("ebw_metab_cohort_site.csv", stringsAsFactors=FALSE)

df$time = as.numeric(sub("ebw\\.", "", df$name))
df = df[df$time <= 84, ]
df$ebw = df$ebw / 2.20462

df$class_lab = factor(ifelse(df$class == 1, "RGN", "SWL"), levels=c("RGN", "SWL"))
df$sex_lab = factor(ifelse(df$sex == 1, "Male", "Female"), levels=c("Male", "Female"))
df$site_lab = factor(paste0("Site ", df$SITE_ID))

baseline = df[df$time == 0, c("id", "ebw")]
names(baseline) = c("id", "ebw_0")
df = merge(df, baseline, by="id", all.x=TRUE)
df$pct_loss = (df$ebw - df$ebw_0) / df$ebw_0 * 100

class_cols = c("RGN" = "#E69F00", "SWL" = "#0072B2")
sex_cols = c("Male" = "#56B4E9", "Female" = "#CC79A7")

site_levels = levels(df$site_lab)
site_cols = setNames(
  c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00",
    "#A65628", "#F781BF", "#009E73", "#999999")[seq_along(site_levels)],
  site_levels
)

x_breaks = c(0, 12, 24, 36, 48, 60, 72, 84)

base_theme = theme_linedraw(base_size=15) +
  theme(legend.position="top",
        legend.title=element_blank(),
        panel.grid.minor=element_blank())

p_a = ggplot(df, aes(x=time, y=ebw, group=id, color=class_lab)) +
  geom_line(linewidth=0.8, alpha=0.8) +
  scale_color_manual(values=class_cols) +
  scale_x_continuous(breaks=x_breaks) +
  labs(x="Time (months)", y="EBW (kg)") +
  base_theme

p_b = ggplot(df, aes(x=time, y=pct_loss, group=id, color=class_lab)) +
  geom_line(linewidth=0.8, alpha=0.8) +
  scale_color_manual(values=class_cols) +
  scale_x_continuous(breaks=x_breaks) +
  labs(x="Time (months)", y="Percent EBW Loss (%)") +
  base_theme

p_c = ggplot(df, aes(x=time, y=ebw, group=id, color=sex_lab)) +
  geom_line(linewidth=0.8, alpha=0.8) +
  scale_color_manual(values=sex_cols) +
  scale_x_continuous(breaks=x_breaks) +
  labs(x="Time (months)", y="EBW (kg)") +
  base_theme

p_d = ggplot(df, aes(x=time, y=ebw, group=id, color=site_lab)) +
  geom_line(linewidth=0.8, alpha=0.8) +
  scale_color_manual(values=site_cols) +
  scale_x_continuous(breaks=x_breaks) +
  labs(x="Time (months)", y="EBW (kg)") +
  theme_linedraw(base_size=15) +
  theme(legend.position="top",
        legend.title=element_blank(),
        panel.grid.minor=element_blank()) +
  guides(color=guide_legend(nrow=3, byrow=TRUE))

ggsave("figs3a_ebw_class.png", p_a, width=6, height=5, dpi=800, bg="white")
ggsave("figs3b_pct_ebw_loss.png", p_b, width=6, height=5, dpi=800, bg="white")
ggsave("figs3c_ebw_sex.png", p_c, width=6, height=5, dpi=800, bg="white")
ggsave("figs3d_ebw_site.png", p_d, width=6, height=5.8, dpi=800, bg="white")

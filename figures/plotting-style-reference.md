# Plotting Style Reference

This document defines the canonical style for all ggplot2 figures in this project.

---

## 1. Assignment Operator

Always use `=`, never `<-`.

```r
d = read_excel("data.xlsx")
p = ggplot(...)
```

---

## 2. Themes by Plot Type

### Boxplot / Bar chart (categorical x-axis)
```r
theme_classic(base_size = 15) +
theme(
  axis.text.x = element_text(angle = 45, hjust = 1),
  legend.position = "none"
)
```

### Horizontal bar chart (e.g., genus abundance)
```r
theme_minimal(base_size = 15) +
theme(
  axis.text.y = element_text(size = 13, face = "italic"),
  axis.text.x = element_text(size = 13),
  legend.position = "top",
  panel.grid.major.x = element_line(color = "gray90"),
  panel.grid.minor.x = element_line(color = "gray95"),
  panel.grid.major.y = element_blank()
)
```

### Stacked bar chart / composition plot
```r
theme_minimal(base_size = 15) +
theme(
  axis.text.x = element_text(size = 15, angle = 45, hjust = 1),
  axis.title.y = element_text(size = 15),
  legend.position = "right",
  panel.grid.major.x = element_blank()
)
```

### Line / time-course plot
```r
theme_linedraw(base_size = 15) +
theme(
  legend.position = "right",
  legend.title = element_blank(),
  panel.grid.minor = element_blank()
)
```

### PCoA / PCA / ordination scatter plot
```r
theme_linedraw(base_size = 15) +
theme(
  panel.grid.major = element_line(colour = "grey90"),
  panel.grid.minor = element_blank(),
  legend.position = "right"
)
```

### Faceted bar chart (many small panels)
```r
theme_minimal(base_size = 15) +
theme(
  axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
  strip.text = element_text(size = 10, face = "bold"),
  legend.position = "top"
)
```

### Network / alluvial (void)
```r
theme_void()
```

---

## 3. Points

```r
geom_point(aes(fill = group), shape = 21, size = 3, alpha = 0.8, color = "black")
```

- `shape = 21`: filled circle with border
- `size = 3`
- `alpha = 0.8`
- `color = "black"`: border color
- `fill`: interior color mapped to group

---

## 4. Lines and Error Bars

```r
geom_line(linewidth = 0.8)
geom_errorbar(linewidth = 0.5, width = 0.3)
```

---

## 5. Boxplots

```r
geom_boxplot(aes(fill = group), outlier.shape = NA, alpha = 0.3) +
geom_point(aes(fill = group), shape = 21, size = 3, alpha = 0.8,
           color = "black", position = position_dodge2(0.3))
```

- Always suppress outliers with `outlier.shape = NA`
- Plot individual points separately with jitter or dodge
- Box fill uses group colors at `alpha = 0.3`

---

## 6. Bar Charts

```r
geom_bar(stat = "identity", color = "black", linewidth = 0.2)
# or for stacked:
geom_bar(stat = "identity", position = "stack", color = "black", linewidth = 0.2)
```

---

## 7. Saving Figures

- Always `dpi = 800` if applicable
- Always `bg = "white"`
- Use `.svg` format if possible, otherwise use `.png` format

---

## 8. Miscellaneous

- `base_size = 15` in all theme calls
- `text = element_text(size = 15)` can be omitted when `base_size = 15` is set
- Use relative file paths, not hardcoded absolute paths
- Clean legend titles with `labs(fill = "", color = "")` (empty string removes title)

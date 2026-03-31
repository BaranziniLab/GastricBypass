# Figures Explained — Gastric Bypass Metabolomics Study

**Study:** Baseline metabolomic profile as potential biomarker for weight change after Roux-en-Y gastric bypass (RYGB) surgery
**Cohort:** LABS-2 (discovery), post-RYGB clinical cohort (validation), Estonian Biobank (external), Framingham Heart Study (GWAS)
**Key outcome:** Percent excess body weight at year 5 (%EBW5) — higher values mean less effective surgery (poor weight loss or regain)
**Key construct:** MetRS (Metabolite Risk Score) — a 13-metabolite weighted composite score; higher MetRS = higher predicted weight regain risk

---

## Main Figures

---

### Fig1a — EBW Trajectories by Latent Class (Full LABS-2 Cohort, n=1,590)

**What it shows:** The three distinct long-term weight trajectory groups identified by latent class growth mixture modeling (LCGMM) over 7 years after RYGB surgery.

- **X-axis:** Time post-surgery in years (approximately 0.25 to 6.5 years)
- **Y-axis:** Excess Body Weight (EBW) in kg — EBW = measured weight minus ideal body weight at BMI 25 kg/m²; higher = more obesity burden remaining
- **Lines:** Mean EBW trajectory for each class over time
- **Ribbons/shading:** 95% confidence intervals around each class mean

**Colors / Classes:**
| Color | Class | n | Description |
|-------|-------|---|-------------|
| Blue | Class 1 | 100 (6.3%) | Modest initial loss then **weight regain** — starts ~101 kg EBW, ends ~72 kg at year 5 |
| Gold | Class 2 | 108 (6.8%) | **Sustained weight loss** — drops to ~29 kg EBW by year 5 |
| Pink | Class 3 | 1,382 (86.9%) | Lower baseline EBW (~58 kg), modest and sustained loss — the "typical" majority |

**Context:** Class 3 was excluded from metabolomic analysis because its lower baseline EBW would confound metabolite comparisons. Only Classes 1 and 2 (comparable baseline, divergent outcomes) were profiled.

---

### Fig1c — Observed vs. Linear Regression Fit (6 Representative Patients)

**What it shows:** Demonstrates how poorly a simple linear model captures the non-linear dynamics of post-surgery weight change in individual patients.

- **X-axis:** Months post-surgery (0 to 36 months)
- **Y-axis:** Excess Body Weight (EBW) in kg
- **Facets:** 6 individual patient IDs shown in separate panels
- **Blue line/points:** Observed EBW measurements at clinic visits
- **Red line:** Linear regression fit — a straight line forced through the trajectory

**Context:** The linear fit misses the rapid early weight loss followed by plateau/regain. R² = 0.58. This motivates the use of a spline model (Fig1d).

---

### Fig1d — Observed vs. B-Spline Fit with Knots (6 Representative Patients)

**What it shows:** The improved broken-stick (b-spline) model that accurately captures the non-linear weight trajectory by allowing slope changes at 6, 12, and 24 months.

- **X-axis:** Months post-surgery (0 to 60 months)
- **Y-axis:** EBW in kg
- **Facets:** Same 6 patients as Fig1c
- **Blue line/points:** Observed EBW
- **Red line:** B-spline fit — curves to match the rapid early loss and later stabilization/regain

**Context:** The spline model achieves R² = 0.98 vs. 0.58 for linear. Knots placed at 6, 12, and 24 months capture the early post-op rapid loss, the plateau phase, and the long-term trajectory. Used to interpolate EBW at exactly 5 years for all participants.

---

### Fig1e — Predicted vs. Observed EBW (Cross-Validation)

**What it shows:** Internal validation of the b-spline model — how well model-predicted EBW values match the actual observed values across all patients.

- **X-axis:** Observed EBW (kg), ranging ~−10 to ~125 kg
- **Y-axis:** Predicted (model-estimated) EBW (kg), same range
- **Points:** Each dot = one observation (patient × time point); grey with outlined stroke
- **Dashed orange line:** Identity reference line (perfect prediction; slope = 1, intercept = 0) — points on this line mean the model is exactly correct

**What to look for:** Points cluster tightly along the diagonal, indicating high model accuracy. Scatter around the line reflects residual error. RMSE and MAE values (see FigSx) quantify this scatter.

---

### Fig2 (Supplemental) — Correlation Plot of 13 MetRS Metabolites (ggcorrplot)

**What it shows:** Pairwise Pearson correlations among the 13 metabolites included in the MetRS.

- **Layout:** Upper-triangle matrix; each cell shows two metabolites' correlation
- **Color scale:** Diverging RdBu (Red–White–Blue)
  - **Red:** Positive correlation (metabolites rise and fall together)
  - **Blue:** Negative correlation (one rises when the other falls)
  - **White/pale:** Near-zero correlation
- **Numbers in cells:** Correlation coefficient (range −1 to +1)
- **Rows/Columns:** The 13 MetRS metabolites (e.g., BAIBA, kynurenine, 3-methyladipate, glucuronate, etc.)

**Context:** Low inter-metabolite correlations confirm that the 13 metabolites capture independent signals. DMGV was excluded from MetRS because it correlated too strongly with BAIBA (r = −0.56).

---

### Fig2b — Corrplot of MetRS Metabolites (Circle Style)

**What it shows:** Same 13-metabolite pairwise correlation matrix as Fig2, but displayed in the classic corrplot circle style.

- **Layout:** Lower triangle of the correlation matrix
- **Circle size:** Proportional to the absolute value of the correlation — larger circles = stronger correlation
- **Circle fill color:** RdBu diverging palette
  - **Red circles:** Positive correlation
  - **Blue circles:** Negative correlation
- **Empty cells:** Pairs with near-zero or non-significant correlation
- **Color bar (bottom):** Maps fill color to correlation value (−1 to +1)

---

### Fig2c — Heatmap of MetRS Metabolites (Clustered)

**What it shows:** A clustered heatmap of the correlation matrix for the 13 MetRS metabolites, with rows and columns reordered by hierarchical clustering to group similar metabolites together.

- **Rows and Columns:** The 13 MetRS metabolites
- **Cell color:** Diverging RdBu palette — **red** = high positive correlation, **blue** = high negative correlation, **white** = near zero
- **Dendrograms (if shown):** Hierarchical clustering tree indicating which metabolites are most similar
- **Diagonal:** Always 1.0 (each metabolite perfectly correlates with itself)

**Context:** Clustering reveals metabolite "modules" — groups of metabolites with similar patterns. This can suggest shared biological pathways (e.g., lipids clustering together, amino acids clustering together).

---

### Fig3a — MetRS Boxplot: Weight Regain vs. Sustained Weight Loss (LABS-2 Discovery)

**What it shows:** Comparison of MetRS values between the two phenotype groups in the discovery cohort — the primary result demonstrating the score's discriminative ability.

- **X-axis:** Two groups — **SWL** (Sustained Weight Loss, n=80) and **RGN** (Regain, n=80)
- **Y-axis:** MetRS value (standardized units; higher = greater predicted regain risk)
- **Box:** Interquartile range (IQR, 25th–75th percentile)
- **Middle line:** Median
- **Whiskers:** 1.5× IQR
- **Dots beyond whiskers:** Outlier observations

**Colors:**
- **Blue (steel blue):** SWL group — lower MetRS (median ~0.45)
- **Gold:** RGN group — higher MetRS (median ~−0.55; note: score direction means RGN is lower, reflecting inverse coding — check original figure)
- **Bracket + p-value:** Wilcoxon test, p = 1.2×10⁻¹⁰ — highly significant difference

**Context:** By definition, higher MetRS predicts weight regain. This plot confirms the score separates the two outcome groups strongly.

---

### Fig3b — ROC Curves: MetRS vs. Clinical Variables Alone

**What it shows:** Receiver Operating Characteristic (ROC) curves evaluating how well MetRS (added to clinical variables) vs. clinical variables alone can classify who will regain weight vs. sustain loss.

- **X-axis:** 1 − Specificity (False Positive Rate), ranging 0 to 1 — note: axis typically shown reversed (1 → 0, left to right) to display the curve in the conventional upper-left bow shape
- **Y-axis:** Sensitivity (True Positive Rate), ranging 0 to 1
- **Diagonal reference line:** Random classifier (AUC = 0.50) — a model with no predictive ability

**Colors / Curves:**
| Color | Model | AUC |
|-------|-------|-----|
| Blue | MetRS + Clinical covariates | 0.744 |
| Gold | Clinical covariates only (age, sex, BMI) | 0.600 |

**Context:** The AUC increase from 0.60 → 0.75 (p < 0.001 by likelihood ratio test) quantifies the incremental value of the metabolomic score beyond what clinical information alone can predict.

---

### Fig3c — Cross-Validation Error Boxplot (MAE and RMSE)

**What it shows:** Distribution of prediction errors from 100 repetitions of 10-fold cross-validation of the MetRS regression model — quantifying model stability and fit.

- **X-axis:** Error metric — **MAE** (Mean Absolute Error) and **RMSE** (Root Mean Squared Error)
- **Y-axis:** Error value (same units as %EBW5 or EBW in kg)
- **Box:** IQR across the 100 CV repetitions
- **Whiskers:** 1.5× IQR
- **Outlier dots:** Individual CV repetitions with unusually high or low error

**Values:**
- MAE: median ~17.6 kg (range ~14.9–18.6)
- RMSE: median ~21.2 kg (range ~18.5–25.8)

**Context:** The tight distributions confirm that model performance is stable across different cross-validation splits, reducing concern about overfitting. RMSE > MAE indicates some influence of large residuals (typical in weight data with outliers).

---

### Fig3d — Forest Plot: MetRS and Clinical Predictors Across 4 Models

**What it shows:** Odds Ratios (ORs) with 95% confidence intervals for each predictor of weight regain, across four nested logistic regression models. Each model adds more predictors.

- **X-axis:** Odds Ratio on log scale — vertical line at OR = 1.0 is the null (no effect)
  - Points to the **right** (OR > 1): predictor associated with *increased* odds of weight regain
  - Points to the **left** (OR < 1): associated with *lower* odds of weight regain
- **Y-axis:** Predictors — Age, Baseline EBW, Sex, **MetRS per SD**
- **Points:** Point estimate (OR)
- **Horizontal bars:** 95% confidence intervals — if bar does not cross OR=1, the association is statistically significant
- **Facets:** Models 1–4 (progressively adjusted)

**Key result:** MetRS per SD: OR ~2.8 (95% CI: 1.7–4.2) — each standard deviation increase in MetRS is associated with ~2.8× greater odds of weight regain, adjusting for clinical covariates. This effect is consistent across all model specifications.

---

### Fig4a — MetRS-10 Boxplot: Post-RYGB Validation Cohort (Brigham & Women's)

**What it shows:** External validation of the MetRS in an independent cohort evaluated a median of 7.2 years post-surgery, using a 10-metabolite version of the score (MetRS-10; 3 metabolites unavailable on that platform).

- **X-axis:** Two groups — **SWL** (Sustained Weight Loss, n=14) and **RGN** (Regain, n=21)
- **Y-axis:** MetRS-10 value (standardized)
- **Box:** IQR; middle line = median
- **Colors:** Steel blue = SWL; Gold = RGN
- **Bracket:** p = 0.028 (Wilcoxon test)

**Context:** Despite a smaller sample and a reduced 10-metabolite score, MetRS-10 still significantly distinguishes regainers from sustainers — supporting generalizability of the score to a real-world post-surgical setting.

---

### Fig4b — MetRS-8 Boxplot: Estonian Biobank (Lean vs. Obese)

**What it shows:** Tests whether the MetRS reflects features of general adiposity in a non-surgical, population-based cohort. Uses MetRS-8 (8 of 13 metabolites available in this platform).

- **X-axis:** Two groups — **Lean** (BMI ~18 kg/m², n~100) and **Obese** (BMI ~40 kg/m², n~100)
- **Y-axis:** MetRS-8 value
- **Colors:** Steel blue = Lean; Warm orange = Obese
- **Bracket:** p = 0.011

**Context:** Higher MetRS-8 in obese individuals (who were never operated on) suggests the metabolomic signature captures intrinsic biological features of obesity, not just surgical response. This raises the possibility that the score reflects a pre-existing metabolic phenotype that predisposes both to obesity and to poor surgical outcomes.

---

### Fig4c — MetRS vs. Percent Weight Regain Scatter Plot

**What it shows:** Continuous relationship between MetRS score and the magnitude of weight regain, with separate regression lines for two sub-groups.

- **X-axis:** MetRS score (continuous, standardized)
- **Y-axis:** % Weight Regain (percent of maximum weight loss that was regained — higher = more regain)
- **Points:** Individual subjects (~86 total), colored by sub-group
- **Lines:** Linear regression fit per group (no SE band)

**Colors / Groups:**
| Color | Group | Description |
|-------|-------|-------------|
| Warm orange | PreSx | Pre-surgical assessment context (shallower slope) |
| Teal | PostSx | Post-surgical assessment context (steeper slope) |

**Context:** Each SD increase in MetRS is associated with ~12.93% greater weight regain (95% CI: 7.01–18.85, p < 0.001). The scatter confirms a dose-response relationship, not just a binary group difference.

---

## Supplemental Figures

---

### FigS (Bootstrap Stability) — Bootstrap Selection Frequency of Metabolites

**What it shows:** How consistently each of the 58 candidate metabolites was selected across 100 bootstrap repetitions of the stepwise regression — a measure of feature stability.

- **X-axis:** Selection frequency (0 to 1; i.e., 0% to 100% of bootstrap iterations)
- **Y-axis:** Metabolite names, ordered from highest to lowest selection frequency
- **Dashed vertical line at 0.5:** 50% selection threshold — metabolites above this line were selected in the majority of bootstrap runs
- **Colors:**
  - **Gray bars:** Metabolites NOT included in the final 13-metabolite MetRS
  - **Steel blue bars:** Metabolites included in the MetRS (13 total)

**Context:** Kynurenine (100% frequency) is the most stably selected metabolite. The 13 MetRS metabolites generally show higher selection frequencies, validating that the final model captures robust rather than spurious associations.

---

### FigS (P-value Histogram) — Distribution of Metabolite Association P-values

**What it shows:** The distribution of p-values from linear regression of all 541 metabolites against %EBW5. Used to assess whether the data show genuine signal above what would be expected by chance.

- **X-axis:** P-value (0 to 1, binned into 50 equal bins of width 0.02)
- **Y-axis:** Count of metabolites per bin
- **Bars:** Each bin's count — enrichment of low p-values relative to uniform distribution indicates true signal
- **Dashed orange horizontal line:** Expected count per bin under the null hypothesis (541 metabolites ÷ 50 bins = ~10.8 per bin)
- **Annotation:** "Expected under null" in orange

**Context:** Enrichment of p-values near 0 (bars much taller than the null line on the left side) confirms that many metabolites are genuinely associated with weight outcomes, justifying the metabolite selection pipeline.

---

### FigS (Q-Q Plot) — Quantile-Quantile Plot of GWAS P-values

**What it shows:** Compares the observed distribution of −log₁₀(p-values) from the GWAS to the expected distribution under the null hypothesis of no association — a standard genomic inflation diagnostic.

- **X-axis:** Expected −log₁₀(p) under the null (theoretical quantiles from a uniform distribution)
- **Y-axis:** Observed −log₁₀(p) from the actual GWAS
- **Gray dashed diagonal:** Identity line — points on this line fit the null perfectly
- **Points above the diagonal:** More significant than expected by chance; extreme upper-right points represent true genetic associations
- **λ = 1.87 (annotated in orange):** Genomic inflation factor — values > 1 indicate either true polygenic signal or technical inflation

**Context:** The general departure from the diagonal at the upper tail confirms genome-wide significant loci (e.g., AGXT2, SLC7A5). The genomic inflation factor λ = 1.87 is moderate-to-high, consistent with polygenic trait architecture or population stratification.

---

### FigS1a — EBW Distribution at Baseline by Trajectory Class

**What it shows:** Boxplots of baseline (pre-surgery) EBW across the 3 LCGMM trajectory classes, confirming comparable baseline weights between Classes 1 and 2.

- **X-axis:** Trajectory class (Class 1, Class 2, Class 3)
- **Y-axis:** Baseline EBW (kg)
- **Colors:** Gold = Class 1 (Regain); Blue = Class 2 (Sustained Loss); Pink = Class 3 (Lower baseline)

**Key finding:** Classes 1 and 2 have overlapping baseline EBW (~88–115 kg IQR), while Class 3 is significantly lower (~45–65 kg IQR). This supports the rationale for excluding Class 3 from metabolomic comparisons.

---

### FigS1b — EBW Distribution at 1 Year Post-Surgery by Trajectory Class

**What it shows:** EBW distributions at the 1-year follow-up visit, showing early post-surgical differences between trajectory classes.

- **X-axis:** Trajectory class (1, 2, 3)
- **Y-axis:** EBW at 1 year (kg)
- **Colors:** Same as FigS1a (Gold/Blue/Pink)

**Context:** By year 1, Classes 1 and 2 have already begun to diverge. Class 2 (sustained loss) shows lower EBW. Class 3 shows the lowest absolute values due to lower baseline.

---

### FigS1c — EBW Distribution at 5 Years Post-Surgery by Trajectory Class

**What it shows:** EBW distributions at the 5-year timepoint — the primary outcome endpoint — demonstrating the maximal divergence between Classes 1 and 2.

- **X-axis:** Trajectory class (1, 2, 3)
- **Y-axis:** EBW at 5 years (kg)
- **Colors:** Gold = Class 1; Blue = Class 2; Pink = Class 3

**Key finding:** Class 1 retains high EBW (~62–78 kg IQR), Class 2 has dramatically lower EBW (~18–42 kg IQR), and Class 3 is intermediate (~12–32 kg IQR). The large separation between Classes 1 and 2 at year 5 is the phenotypic contrast that the MetRS was designed to predict.

---

### FigS2 (Delta EBW) — Change in EBW at Years 3, 4, 5 by Class

**What it shows:** Boxplots of the *change* in EBW (delta EBW) relative to baseline at years 3, 4, and 5 post-surgery, split by trajectory class.

- **X-axis:** Time point (year 3 / d.36, year 4 / d.48, year 5 / d.60)
- **Y-axis:** Delta EBW (kg; negative = weight loss from baseline, positive = weight regain above baseline)
- **Colors:** Blue = Class 1 (Regain group — less negative delta, i.e., regaining weight); Gold = Class 2 (Sustained Loss — more negative delta)

**Context:** The increasing divergence between classes over time (especially years 4–5) motivates using year 5 as the primary outcome and confirms that the two groups have meaningfully different trajectories beyond the initial surgical period.

---

### FigS2 (EBW Cohort) — Absolute EBW at Years 3, 4, 5 by Class

**What it shows:** Boxplots of absolute EBW at years 3, 4, and 5 for the two extreme trajectory classes.

- **X-axis:** Time point (years 3, 4, 5)
- **Y-axis:** EBW in kg
- **Colors:** Blue = Class 1 (Regain); Gold = Class 2 (Sustained Loss)

**Context:** Shows that Class 1's absolute EBW remains substantially higher and increases over follow-up, while Class 2's EBW stays low and continues declining slightly.

---

### FigS3 — Spaghetti Plot of Individual EBW Trajectories (All Subjects)

**What it shows:** Individual-level weight trajectories over time for all subjects in the metabolomics subset (n=160), colored by outcome group — reveals the heterogeneity within each group.

- **X-axis:** Months post-surgery (0 to ~84 months)
- **Y-axis:** EBW (kg)
- **Each line:** One individual patient's EBW over time
- **Colors:**
  - **Gold:** Weight Regain group (RGN) — lines that bottom out then rise
  - **Steel blue:** Sustained Weight Loss group (SWL) — lines that continue declining or plateau low

**Context:** The spaghetti plot reveals that both groups have substantial within-group heterogeneity. Some RGN individuals never fully lost weight; others lost substantially but regained. The MetRS aims to predict this variability from pre-surgical metabolomics alone.

---

### FigS3a — EBW Trajectories by Trajectory Class

**What it shows:** Same individual trajectories as FigS3 but faceted or colored to highlight Class 1 vs. Class 2 membership explicitly.

- **X-axis:** Months (0–84)
- **Y-axis:** EBW (kg)
- **Colors:** Gold = Weight Regain class; Steel blue = Sustained Weight Loss class

---

### FigS3c — EBW Trajectories by Sex

**What it shows:** Individual EBW trajectories split by biological sex, to confirm that sex does not drive the weight trajectory groups (sensitivity analysis).

- **X-axis:** Months (0–84)
- **Y-axis:** EBW (kg)
- **Colors:**
  - **Steel blue:** Male subjects
  - **Pink:** Female subjects
- **Lines:** Individual spaghetti lines per subject

**Context:** Both males and females appear in both regain and sustained loss groups, and the manuscript states that weight trajectories were not significantly influenced by sex (also shown in FigS7b PLS-DA).

---

### FigS4 — Heatmap of All 541 Metabolites

**What it shows:** A large correlation heatmap of all 541 high-confidence metabolites retained after QC, organized by hierarchical clustering to reveal broad co-variation structure across the metabolome.

- **Rows and Columns:** 541 metabolites (individual labels not legible at this scale)
- **Cell color:** Diverging blue–white–red palette
  - **Red:** Strong positive correlation between two metabolites
  - **White:** Near-zero correlation
  - **Blue:** Strong negative correlation
- **Clustering:** Rows and columns are reordered by hierarchical clustering, creating visible block structure — blocks of red indicate groups of co-regulated metabolites (e.g., lipid classes, amino acid families)
- **Color scale:** −1 to +1 (Pearson correlation)

**Context:** This view of the full metabolome reveals the modular structure of circulating metabolites. The 62 metabolites nominally associated with %EBW5 were drawn from across this landscape, and the 13 MetRS metabolites were selected to capture non-redundant signal from diverse metabolic modules.

---

### FigS5 — Correlation Plot of 62 Nominally Significant Metabolites

**What it shows:** Pairwise correlations among the 62 metabolites that were nominally associated with %EBW5 (p < 0.05), used to identify highly correlated pairs for exclusion from the stepwise model.

- **Layout:** Lower-triangle correlation matrix (54 unique metabolites visible due to redundancy collapsing)
- **Cell color:** RdBu diverging palette (**red** = positive correlation, **blue** = negative)
- **Axes:** Metabolite names, rotated 90° on x-axis
- **Color scale bar:** −1 to +1

**Context:** This plot directly motivated the exclusion of DMGV from the final MetRS due to its strong negative correlation with BAIBA (r = −0.56). Other visible clusters (e.g., lysophosphatidylcholines grouping together) reflect the shared biosynthetic origins of related lipid species.

---

### FigS6b — PLS-DA Score Plot: Estonian Biobank (Lean vs. Obese)

**What it shows:** Partial Least Squares Discriminant Analysis (PLS-DA) scores plot projecting the metabolomic profiles of Estonian Biobank subjects into a 2D space that maximally separates lean vs. obese individuals.

- **X-axis:** X-variate 1 (Component 1) — the latent metabolomic axis most predictive of obesity status; label includes % variance explained
- **Y-axis:** X-variate 2 (Component 2) — second most predictive axis; label includes % variance explained
- **Points:** Each dot = one individual's metabolomic profile projected into PLS-DA space
  - **Circles, Steel blue:** Lean individuals (BMI ~18 kg/m²)
  - **Triangles, Burnt orange:** Obese individuals (BMI ~40 kg/m²)
- **Ellipses:** 95% confidence ellipses per group — overlap indicates mixed classification, separation indicates good discrimination

**Context:** Separation of lean and obese groups in PLS-DA space confirms that the MetRS metabolites (a subset of the full metabolomic profile) capture biologically meaningful variation relevant to adiposity even outside the surgical setting.

---

### FigS7b — PLS-DA Score Plot: Post-RYGB Cohort (SWL vs. RGN, 2 Groups)

**What it shows:** PLS-DA scores comparing metabolomic profiles of sustained weight loss vs. weight regain individuals in the post-RYGB clinical validation cohort.

- **X-axis:** X-variate 1 (~7% variance explained)
- **Y-axis:** X-variate 2 (~20% variance explained)
- **Points:**
  - **Circles, Teal-green:** SWL (Sustained Weight Loss, n=14)
  - **Triangles, Gold/orange:** RGN (Regain, n=21)
- **Ellipses:** 95% confidence ellipses per group

**Context:** Even in a small validation cohort assessed ~7 years post-surgery, the metabolomic profiles partially separate by weight outcome, validating that the biological signal captured by MetRS is detectable in an independent clinical context.

---

### FigSx — MetRS Density Plot (Distribution of Scores by Outcome Group)

**What it shows:** Kernel density curves showing the full distribution of MetRS scores in the SWL and RGN groups, illustrating the degree of overlap and separation between groups.

- **X-axis:** MetRS score (standardized; higher = more weight regain risk)
- **Y-axis:** Density (probability density, area under each curve = 1)
- **Filled curves:** Overlapping density distributions for each group
- **Colors:**
  - **Blue:** SWL group — distribution shifted left (lower MetRS, centered ~+0.35)
  - **Yellow/Gold:** RGN group — distribution shifted right (higher MetRS, centered ~−0.65; note scoring direction)

**Context:** While the group means differ significantly (Fig3a), the density plot reveals substantial overlap, reflecting the reality that no single biomarker perfectly classifies all individuals. The overlap also motivates use of MetRS as a continuous risk predictor rather than a binary cutoff.

---

### FigSx — MetRS-10 Boxplot in LABS-2 Cohort

**What it shows:** Performance of the 10-metabolite reduced MetRS (MetRS-10, missing 3 metabolites not detected in the validation platform) when applied back to the LABS-2 discovery cohort — assessing how much predictive information is lost with fewer metabolites.

- **X-axis:** SWL vs. RGN groups
- **Y-axis:** MetRS-10 value
- **Colors:** Steel blue = SWL; Gold = RGN
- **Significance:** p = 8.1×10⁻⁵

**Context:** MetRS-10 remains highly significant in LABS-2, confirming that the 10-metabolite version retains most of the predictive signal of the full 13-metabolite score.

---

### FigSx — MetRS-8 Boxplot in LABS-2 Cohort

**What it shows:** Same as MetRS-10 boxplot but for the 8-metabolite version used in the Estonian Biobank.

- **X-axis:** SWL vs. RGN
- **Y-axis:** MetRS-8 value
- **Significance:** p = 2.6×10⁻⁶ (more significant than MetRS-10, possibly due to metabolite composition)

**Context:** The MetRS-8 still strongly discriminates outcome groups in LABS-2, supporting its validity when applied to the Estonian Biobank cohort.

---

### FigSx — Predicted vs. Observed EBW with RMSE Annotation

**What it shows:** Scatter plot of MetRS-predicted %EBW5 vs. the actual observed %EBW5 at year 5, with model error metrics annotated — a direct visualization of model fit.

- **X-axis:** Observed EBW at Year 5 (kg), range ~40–120 kg
- **Y-axis:** Predicted EBW at Year 5 (kg), range ~40–165 kg
- **Points:** Individual subjects (~85 total); each dot = one person
- **Dashed orange regression line:** OLS fit through the scatter (slope ≈ 1 ideally; deviations indicate systematic over/under-prediction)
- **Annotation (upper left):**
  - **RMSE = 21.45 ± 1.32** — average magnitude of prediction error in kg
  - **MAE = 17.24 ± 1.10** — median absolute error in kg

**Context:** Both RMSE and MAE are reported ± SD from 100 repetitions of 10-fold cross-validation, demonstrating stable model performance. An RMSE of ~21 kg on an EBW range of ~40–165 kg represents moderate-to-good predictive accuracy for a molecular biomarker in a complex surgical outcome.

---

## Summary of Key Variables

| Term | Definition |
|------|-----------|
| EBW | Excess Body Weight = measured weight − ideal body weight (at BMI 25 kg/m²), in kg |
| %EBW5 | Percent of baseline EBW remaining at year 5 — higher = worse surgical outcome |
| MetRS | Metabolite Risk Score — weighted sum of 13 standardized metabolite z-scores; higher = more regain risk |
| MetRS-10 | MetRS with 10 metabolites (3 unavailable in post-RYGB validation cohort) |
| MetRS-8 | MetRS with 8 metabolites (5 unavailable in Estonian Biobank) |
| SWL | Sustained Weight Loss group (Class 2 in LCGMM) |
| RGN | Regain group (Class 1 in LCGMM) |
| RYGB | Roux-en-Y Gastric Bypass surgery |
| LABS-2 | Longitudinal Assessment of Bariatric Surgery study (discovery cohort, n=1,590 / metabolomics n=160) |
| AUC | Area Under the ROC Curve — ranges 0.5 (random) to 1.0 (perfect classification) |
| LCGMM | Latent Class Growth Mixture Modeling — statistical method to find trajectory subgroups |
| PLS-DA | Partial Least Squares Discriminant Analysis — supervised dimensionality reduction for group separation |
| MAE | Mean Absolute Error (in same units as outcome) |
| RMSE | Root Mean Squared Error (penalizes large errors more than MAE) |

# Edit Notes — Med_Met_11May26_WG.docx

Reviewer pass on `submissions/med/manuscript/Med_Met_11May26_WG.docx` against
the figure files in `submissions/med/figures/`, the supplement in
`submissions/med/supplement/`, and the SPOKE network data in
`figures/Fig2de/data/`.

Scope: (1) figure / supplement reference accuracy, (2) collation of author
comments (focus: Rany Salem ≥ May 2026), (3) writing / clarity review,
(4) verification of the network analysis claims against the underlying edges,
(5) citation gaps with suggested references.

Cross-reference key for the figure files actually in the submission folder:

| File on disk                                | Actual content                                                                         |
| ------------------------------------------- | -------------------------------------------------------------------------------------- |
| `Figure1.pdf`                               | A trajectories, B flowchart, C linear fit, D B-spline fit, E pred vs obs, F workflow   |
| `Figure2.pdf`                               | A MetRS table, B clustered correlation heatmap, C bridge-node bar charts, D network    |
| `Figure3.pdf`                               | A MetRS SWL/RGN boxplot, B MAE/RMSE, C ROC, D forest plots                             |
| `Figure4.pdf`                               | A post-RYGB MetRS SWL/RGN, B Estonia Lean/Obese, C MetRS vs %regain, D–G Manhattans    |
| `SupplementaryFigure1.pdf`                  | EBW at baseline / 1 yr / 5 yr by trajectory class                                      |
| `SupplementaryFigure2.pdf`                  | A/B Year 3–5 EBW + change, C/D individual trajectories, E by sex, F by surgical site   |
| `SupplementaryFigure3.pdf`                  | Single large 541×541 metabolite correlation heatmap                                    |
| `SupplementaryFigure4.pdf`                  | A bootstrap selection bar, B p-value histogram, C Q–Q plot (λ = 1.87)                  |
| `SupplementaryFigure5.pdf`                  | Estonia Biobank: A demographics, B PLS-DA Lean/Obese, C MetRS-10 (SWL/RGN labels)      |
| `SupplementaryFigure6.pdf`                  | Post-RYGB cohort: A demographics, B PLS-DA SWL/RGN, C MetRS-8                          |
| `SupplementaryFigure7.pdf`                  | FHS GWAS: A FHS demographics, B significant-hits table, C–E LocusZoom plots            |
| `SupplementaryFigure8.pdf`                  | **DOES NOT EXIST** in the submission folder                                            |

The manuscript text uses Supp Fig. numbers that diverge from this on-disk
order from Supp Fig. 3 onward — see §1B below.

---

## 1. Figure-reference inconsistencies

### 1A. Main-figure panel mismatches

**Figure 2 — panel labels in the legend do not match the file.**

> *(Legend, in tracked-comment span):* "Figure 2. … a. Metabolites included in the MetRS, b. Bubble plot depicting Pearson correlation coefficients … c. Hierarchical clustering heatmap …"
> *(Legend, separate paragraph):* "**Figure 2E**. Top bridge nodes per node type by normalized betweenness centrality."

The figure file `Figure2.pdf` has exactly four panels — A metabolite table,
B clustered correlation heatmap, C the bridge-node bar charts, D the
network. There is no separate "bubble plot" panel and no panel E. The legend
text describes a two-correlation-panel layout (b bubble + c heatmap) that no
longer exists, and labels the bar-chart panel "2E" when it is in fact panel
C, while leaving the network panel without an explicit "d" label.

The body text already uses `Fig. 2d` for the network ("Fig. 2d", network
section) and `Fig. 2 a-c` for the MetRS scoring panels — so the **body text
matches the four-panel layout**; the **legend is what is out of sync**.

> **Action:** Rewrite the Figure 2 legend to: a = metabolite table, b =
> correlation heatmap (drop the bubble-plot half-sentence), c = bridge-node
> bar charts, d = network plot. This also resolves Salem comment **#85** /
> Thaker comment **#86** (both flag B/C redundancy and recommend dropping B
> — the legend currently says they are two different visualizations, but the
> figure shows only one).

---

**Figure 3 — panels B and C are swapped between figure and legend/body.**

> *(Body):* "increasing the area under the receiver operating characteristic curve (AUC) from 0.60 to 0.75 (p < 0.001, **Fig. 3b**)"
> *(Body):* "consistent performance across 100 repetitions of 10-fold cross-validation (root mean squared error [RMSE] = 21.45 ± 1.32; mean absolute error [MAE] = 17.24 ± 1.10, **Fig. 3 c**)"
> *(Legend):* "b. Receiver Operating Characteristic (ROC) curves … c. Cross-validation performance metrics …"

`Figure3.pdf` actually shows panel B = MAE/RMSE prediction-error boxplots,
panel C = ROC curves. The figure is internally consistent with itself but
**inverted** relative to both the body text and the legend.

This also touches Salem comment **#43** ("Re-order so panel C is first?")
— Rany flagged that the *cross-validation panel comes before* the ROC in
the figure, which is exactly the mismatch above.

> **Action:** Decide on one ordering and apply it everywhere:
> either (a) re-export the figure with ROC as B and MAE/RMSE as C (matches
> current text), or (b) keep the figure as-is and swap "3b" ↔ "3c" in the
> body and in the legend.

---

**Figure 4 — panels A and B are swapped between figure and legend.**

> *(Legend):* "a. Mean MetRS values in lean and obese participants from Estonia Biobank …, b. MetRS in an independent post-RYGB clinical cohort (n=35) … (RGN) versus (SWL)"

`Figure4.pdf` actually shows panel A = post-RYGB SWL/RGN (p = 0.026),
panel B = Estonia Lean/Obese (p = 0.011). The **body text is correct**
("Fig. 4a, p=0.01" for post-RYGB regain; "Fig. 4 b" for Estonia obesity
comparison) — only the legend has them inverted.

> **Action:** Swap the descriptions of 4a and 4b in the legend. While there,
> tighten the legend wording ("Mean MetRS" for a boxplot is inaccurate — say
> "Distribution of MetRS").

---

**Figure 4 — manuscript text says 5 metabolites had GWS loci; only 4 Manhattans shown.**

> *(Body):* "The MetRS and five constituent metabolites — glucuronate, hippurate, kynurenine, BAIBA, and N-carbamoyl-β-alanine — were each associated with genome-wide significant loci"
> *(Legend):* "d. glucuronate, e. Kynurenine, f. Hippurate, and g. C34:2 Phosphatidyl choline"

Five metabolites are claimed to have GWS associations, but Fig. 4 d–g shows
four Manhattans and **C34:2 PC is not one of the five metabolites listed in
the body text**. BAIBA and N-carbamoyl-β-alanine Manhattans are missing
from the main figure. Either:

- the manuscript should drop the C34:2 PC Manhattan and move BAIBA / N-carbamoyl-β-alanine into Fig. 4 (consistent with the body text), **or**
- the body should be reworded to "five constituent metabolites … plus a Manhattan for C34:2 PC shown in Fig. 4g" with a justification (C34:2 PC is not one of the five with GWS loci according to the body, so this would also require a statement of what is being shown and why).

> **Action:** Reconcile body text ↔ legend ↔ figure on which metabolite
> Manhattans appear in Fig. 4. Move BAIBA / N-carbamoyl-β-alanine Manhattans
> to Fig. 4 if they belong in the main figure; otherwise restrict the body
> claim to the four metabolites that are actually plotted.

---

**Figure 1f referenced for two different things.**

> *(Body, Results §1):* "At year five, model-derived mean EBW was 72.4 ± 15.2 kg … in the weight regain group compared to 29.1 ± 20.8 kg … in the sustained weight loss group (**Fig. 1f**; see STAR Methods for trajectory modeling)."
> *(Body, Results §2):* "Percent excess body weight at year five (%EBW5) was defined as (EBW at year 5/baseline EBW) x 100, representing the proportion of baseline excess weight remaining five years after RYGB (**Fig. 1f**)."

`Figure1.pdf` panel F is the **workflow diagram** (study cohorts, MetRS
derivation, validation, GWAS). It does **not** display year-5 EBW means or
the %EBW5 definition. Both `Fig. 1f` citations are therefore incorrect.

This is precisely what drives Salem comments **#37, #38, #39** ("Not sure
why, but I first read this as change in EBW", "Does not clarify what %EBW5
means", "Maybe provide formula?") — Rany is reading the text and the figure
side-by-side and the figure isn't showing what the text claims.

> **Action:** Either (a) remove the `Fig. 1f` citations from these two
> sentences and report the year-5 means in text only, or (b) add a small
> panel to Fig. 1 (e.g., 1g) that shows the model-derived year-5 EBW
> distribution by group. Inline the explicit formula `%EBW5 = (EBW₅ /
> EBW₀) × 100` as Rany suggested.

### 1B. Supplemental-figure numbering is offset from supplemental figure 5 onward

Comparing body-text Supp. Fig. references to the files actually in
`submissions/med/figures/`:

| Body text claim                                       | Body refers to … | On-disk file with that content              |
| ----------------------------------------------------- | ---------------- | -------------------------------------------- |
| Class 1/2/3 EBW at baseline & 5 yr                    | Supp Fig 1       | `SupplementaryFigure1.pdf` ✓                |
| Sex / surgical-center stratification of trajectories  | Supp Fig 3 *(tracked-change ins.)* | actually in `SupplementaryFigure2.pdf` panels E, F |
| QC / metabolite-feature retention                     | Supp Fig 3       | no QC figure exists; SF3 is a 541-metabolite correlation heatmap |
| p-value histogram & Q–Q plot of 541 metabolites       | Supp Fig 4 (panels B, C) | `SupplementaryFigure4.pdf` ✓          |
| Bootstrap stability bar chart                         | Supp Fig 4 (panel A) | `SupplementaryFigure4.pdf` ✓            |
| Post-RYGB clinical cohort overview (n = 35)           | Supp Fig 5       | actually in `SupplementaryFigure6.pdf`      |
| MetRS-10 sensitivity in discovery (SWL vs RGN)        | Supp Fig 6a      | actually in `SupplementaryFigure5.pdf` panel C |
| MetRS-8 sensitivity in discovery                      | Supp Fig 6b      | actually in `SupplementaryFigure6.pdf` panel C |
| Estonian Biobank cohort overview (n = 198)            | Supp Fig 7       | actually in `SupplementaryFigure5.pdf`      |
| FHS demographics + GWAS overview + LocusZoom plots    | Supp Fig 8(a–e)  | actually in `SupplementaryFigure7.pdf`      |

**Pattern:** body-text "Supp Fig 5" ↔ on-disk SF6; body "Supp Fig 6" ↔ panels
inside SF5 and SF6; body "Supp Fig 7" ↔ on-disk SF5; body "Supp Fig 8" ↔
on-disk SF7. The post-RYGB and Estonia cohorts are swapped, the FHS GWAS is
off by one, and `SupplementaryFigure8.pdf` does not exist on disk.

This is referenced in Salem comments **#26** ("Should be supplemental figure
3 — which shows no diff by sex, but missing figure by center") and **#27**
("surgical center also missing from supplemental table 1b").

> **Action:** Renumber either the files or the text — *one* canonical
> mapping — and audit every "Supplemental Fig." citation in the body
> against it. Recommended renumbering, which preserves manuscript order:
>
> - Keep SF1, SF2, SF3 (correlation heatmap), SF4 as-is.
> - Swap on-disk SF5 ↔ SF6 so that post-RYGB cohort is SF5 and Estonia is SF7 (which requires intervening reorder — see below).
> - Better: re-export the files in the order the text expects (SF5 = post-RYGB, SF6 = MetRS-10/-8 sensitivity in discovery, SF7 = Estonia, SF8 = FHS GWAS), so the body-text citations become correct.
> - Add the "by surgical center" trajectory panel to SF3 (currently the trajectory-by-center plot only exists embedded as SF2 panel F — Rany's #26 and #27 comments call this out).
> - Add the missing supplemental figure that the text calls "Supp Fig X" for the LASSO sensitivity ("Supplemental Fig. [X]" with a literal `[X]` placeholder remains in line ~224 of the methods).

### 1C. Supplemental-table references

- `Supplemental_Tables.xlsx` contains 3 sheets: "Supplemental Table 1", "Supplemental Table 2", "Supplemental Table3" (note: third sheet name has no space — minor cosmetic fix).
- Manuscript body cites **Supplemental Table 1b** (tracked-change insertion by Rany at line ~41) — no such sub-table exists. Either add a Table 1b panel for surgical-center breakdown, or remove the reference.
- Manuscript also cites **Supplemental Table 3** (Vidhu V. Thaker tracked-change insertion in the network section: "Several biological modules structured the network (Supplemental Table 3)"). The sheet `Supplemental Table3` exists — confirm its contents match what the text needs (per-module list of nodes), and harmonise the sheet name to "Supplemental Table 3" (with space).

### 1D. Reference to `Supplemental Fig. 4` in the multiple-testing paragraph

> *(Body):* "(genomic inflation factor λ = 1.87), consistent with widespread metabolomic associations with post-surgical weight trajectory (Supplemental Fig. 4)."

Salem comment **#40** says: *"Double check - seems like this references Fig. 5c"*. The on-disk SupplementaryFigure4 panels B and C are the p-value histogram and the Q–Q plot at λ = 1.87, so **the reference is correct as-is** (Rany may have been reading an earlier version). The "Fig. 5c" guess is the Q–Q in the old layout. No change required, but worth flagging the comment as resolved in response.

---

## 2. Author comments — summary, context, and recommended actions

42 comments total: 34 Salem (R), 5 + 2 Thaker (V), 1 Gu (W). Listed below
grouped by theme; **bold dates are May 2026** per the prompt's focus.

### 2A. Substantive content / interpretation (Salem)

| # | Date | Anchor | Comment | Suggested action |
|---|------|--------|---------|------------------|
| 5 | **2026-05-07** | "...key MetRS metabolites" (abstract) | "Should the 'key' metabolite be listed?" | In the abstract, name the loci–metabolite pairs (AGXT2 / BAIBA; SLC7A5 / kynurenine) — keeps abstract scannable and addresses the comment in one sentence. |
| 17 | 2026-04-07 | "the **genetic** basis of key metabolites" | Offers to run LDSC on the GWAS results to estimate heritability of the identified metabolites. | Decision needed: include LDSC heritability estimates? If yes, this is a substantive new analysis; if no, reply to comment and note that heritability inference is deferred (in-text "polygenic" claim is currently unsupported by an h² estimate — see citations §5). |
| 18 | 2026-04-07 | "Class 3 had initial weight loss" | "Don't like the use of modest here — ~50 kg (~50% of EBW) is not modest" | Replace "more modest weight loss" with a specific number — e.g., "lower-baseline class with mean year-5 weight loss of ~50% of EBW (substantial, but on a much smaller pre-surgery EBW than Classes 1/2)". |
| 42 | **2026-05-07** | "regression coefficients" | "Cite my BMI MRS paper?" | Yes — cite Salem's BMI metabolite-risk-score paper as methodological precedent for constructing a weighted metabolite score from stepwise/penalized regression coefficients (see §5 below for likely citation). |
| 45 | 2026-04-08 | "The MetRS remained a strong predictor of weight regain across the unadjusted and adjusted models (Fig. 3d)" | "Simplify to: 'The MetRS remained a strong predictor of weight regain across unadjusted and adjusted models'" | Apply verbatim. |
| 49 / 50 | 2026-04-08 / 2026-04-22 | "(Supplemental Fig. 6a)" | Rany: "Why not table?" Vidhu: "Figure is a better visual representation." | Resolved by Vidhu — keep as figure; reply to comment. |
| 52 | 2026-04-25 | "D-glucuronic acid" (network results) | "In the figure, BAIBA, 13-HODE, L-homoarginine, and PC34:2 appear closer to GCG than D-glucuronic acid. Is this correct?" | **Substantive — see §4 below. The network *layout* in Fig. 2d does place BAIBA / 13-HODE / L-homoarginine visually closer to GCG; the *graph-distance* claim in the text is also incorrect (D-Gluc-A → GCG is path length 4, while BAIBA → PPARA → … → GCG is length 3).** Rewrite this paragraph. |
| 59 | 2026-04-08 | "variant rs13174300" | Provides gnomAD frequency, PheWAS hits at HugeAMP and UK Biobank PheWeb (URLs). | Largely incorporated by Wanjun in comment #60 (the rs13174300 paragraph is already in the manuscript). Add a citation/footnote pointer for gnomAD v4 and HugeAMP — see §5. |
| 62 | 2026-04-08 | "rs37376, rs163910, rs11749934" | "Were any of these associated with MetRS (even nominally?)" | Add one sentence reporting the p-values of these three AGXT2 variants in the MetRS GWAS, so the reader can see they are BAIBA-specific (consistent with the manuscript's claim of independent signals). |
| 63 | 2026-04-08 | same anchor | "Also, what is the LD between the four AGXT2 variants?" | Report pairwise r² (1000G EUR or FHS in-sample LD) among rs13174300 and rs37376 / rs163910 / rs11749934 — typically one line or a small table in `Supplemental Fig. 7` / 8. |
| 64 | **2026-05-07** | "Supplemental Fig. 8)," | "Action items: Add rsIDs to locus zoom — The ordering of the locus zoom plots needs to be modified, most significant to least (as they were discovered via conditional analysis)" | Re-render the LZ plots (currently SF7 c–e) so each plot is labeled with the lead rsID, and reorder by p-value (or by conditional iteration). |
| 70 | **2026-05-07** | "UK Biobank PheWeb analysis" | "References or website we can cite?" | Cite the PheWeb resource paper (Gagliano Taliun et al., 2020, *Nat Genet*) and the UK Biobank PheWeb URL — see §5. |
| 72 | 2026-04-08 | "rs9594030 near LINC00351 …" | "Organizing all the genetic results into a table would be helpful" | Add a Supplemental Table summarising all GWS independent signals: lead rsID, chr:pos, nearest gene, EA / OAF, β / SE, p, novelty status. |
| 74 | 2026-04-08 | "(Fig. 4d-g)" | "Should we replace manhattan plots with locus zoom plots for associated regions?" | Decision needed. Recommendation: keep Manhattans in Fig. 4 (whole-genome scan view) and put **regional** LZ plots in a supplementary figure — this is the conventional choice and matches what SF7 c–e already does. Reply to comment with this rationale. |
| 76 | **2026-05-07** | "that the operation only partially corrects" | "Speculative — not supported by results, please clarify" | Either remove "that the operation only partially corrects" or add a supporting clause. A defensible rewrite: "…a pre-existing cardiometabolic state whose biomarker signature persists at long-term follow-up, consistent with the post-RYGB cohort results in Fig. 4a." Tightens to what the data actually show. |
| 84 | **2026-05-08** | "Future studies should integrate the MetRS prospectively" | "Suggest foreshadowing our work by noting the need and potential of metabolite profiling at different time points (which will help distinguish future work from this paper)" | Add one sentence: "Future work will profile longitudinal post-surgical samples to disentangle the perioperative metabolic response from the preoperative MetRS signal." |
| 87 | 2026-04-09 | "current analysis included 1,590 participants …" | "Revise — Does not sound right" | Rephrase to: "The discovery analysis included 1,590 LABS-2 RYGB participants with complete 7-year weight follow-up and available baseline fasting plasma; the 160-participant metabolomic subset was sampled from this group as described below." |
| 88 | 2026-04-09 | "Given that 82.5 % of participants were female, the study was not powered to detect sex-specific metabolite associations …" | "Shouldn't we note in limitation section?" | Move that sentence (or duplicate a one-clause version) into the Discussion limitations paragraph. |

### 2B. Style / wording (Salem)

| # | Date | Anchor | Comment | Suggested action |
|---|------|--------|---------|------------------|
| 6 | 2026-04-07 | "weight regain" (abstract) | "Sounds like you're referring to criminal activities … why not regain?" | Reword "at risk for weight regain" (the existing wording is fine — Rany was reading "for weight" + "regain"; consider "at elevated risk of post-surgical weight regain"). |
| 7 | **2026-05-07** | "somewhat greater long-term weight loss" | "Why is this being qualified?" | The "somewhat" hedge is unnecessary — the cited meta-analyses (refs 6–8) show RYGB > SG by ~5–10 % EWL. Replace with "greater" and let the magnitude do the work, or quote the effect size. |
| 13 / 14 | 2026-04-07 / 2026-04-11 | "no clinically validated biomarkers" | Salem: ambiguous whether biological or clinical. Thaker: "This refers to measurable markers." | Replace "biomarkers" with "biological biomarkers" or "measurable molecular biomarkers" in this sentence so it doesn't conflict with the clinical predictors listed two clauses earlier. |
| 15 / 16 | 2026-04-07 / 2026-04-11 | "gut microbial activity" | Salem: activity or diversity? Thaker: activity. | The answer (activity, per Thaker) is now consistent — but consider rewording to "gut microbial activity and composition" to encompass both axes that downstream metabolite signatures reflect. |
| 25 | 2026-04-08 | "or surgical center" | "Supp Figure 3 does not support for surgical center" | Already actioned partially via a tracked insertion. See §1B for the missing surgical-center figure. |
| 26 | **2026-05-07** | "Supplemental Fig." | "Should be supplemental figure 3 — which shows no diff by sex, but missing figure by center — or is there a table we can reference?" | Same as #25 — generate the missing by-center panel (the data are in `figures/FigS3/ebw_metab_cohort_site.csv` per git status). |
| 27 | **2026-05-07** | "Supplemental Fig." | "Note: surgical center also missing from supplemental table 1b" | Add by-center counts to Supp Table 1 (no Table 1b yet). |
| 31 | **2026-05-07** | "Untargeted metabolomic" | "Confirm this is correct" — the tracked change is "Targeted and untargeted metabolomic" | The platform is untargeted LC-MS with reference-standard-confirmed identifications (MSI Level 1). That is not "targeted profiling". Revert to "Untargeted metabolomic profiling" and add "with confirmed identities for the 13 MetRS metabolites" if confirmation language is wanted. Do **not** keep "Targeted and untargeted" — it overstates the platform. |
| 41 | 2026-04-08 | "Fig" | "Need to be consistent: either 'Fig' or 'Fig.'" | Global search-and-replace to "Fig." (with period) — manuscript has both "Fig" and "Fig." forms; also unify "Fig. 2 a-c" vs "Fig. 2a–c" (use en-dash, no space). |
| 44 | **2026-05-07** | "Supplemental Fig. 4" | "Double check" | The reference is correct (bootstrap selection bar chart is panel A of SF4). Reply resolving. |
| 85 / 86 | 2026-04-08 / 2026-04-23 | Fig. 2 b/c bubble + heatmap text | Salem: drop panel B (redundant). Thaker: agree. | Apply — see §1A. |
| 89 | 2026-04-09 | "Michigan Imputation Server81" | Provides full citation for Das et al. 2016. | Add citation if not already in references — see §5. |

### 2C. Comments from Thaker (V)

- **#14, #16** — clarifications agreeing with the existing wording (biomarkers = measurable markers; microbial = activity). No further action.
- **#50** — agrees the MetRS-10 sensitivity is better as a figure than a table.
- **#52** — questions whether D-glucuronic acid really sits closer to GCG than BAIBA/13-HODE/L-homoarginine in the network figure. **Confirmed false** — see §4.
- **#61** — asks Wanjun to add the rs13174300 ancestry/PheWAS description. Wanjun complied in #60; the paragraph is now in-text.
- **#77** — *"Once again, is it correct to use D-glucuronic acid here, or should it be BAIBA, 13-HODE etc?"* — second instance of the same network-claim concern. **Substantive; see §4.**

### 2D. Comment from Gu

- **#60** — Wanjun's draft of the rs13174300 ancestry/PheWAS paragraph. Now in-manuscript. Confirm gnomAD coordinates: comment says "chr5:35,002,141–35,002,151" range and "rs13174300" position 35,002,146 — the deployed paragraph uses 35,002,146 ✓.

---

## 3. Writing, spelling, and clarity — actionable line edits

### 3A. Typos and copy-edit

| Location (search string)                                | Issue                                          | Fix                                       |
| ------------------------------------------------------- | ---------------------------------------------- | ----------------------------------------- |
| "broken-stick linear mixed-effects model with knots at **6.12. and 24 months**" (Results §1; also Methods §"Weight change trajectory modeling" says "6, 12, and 24 months") | Stray period inside the comma list — looks like an OCR/track-changes artifact | "knots at 6, 12, and 24 months"           |
| "**Iv**) Positive ion mode analyses … using C8-**reveresed** phase chromatography" (Methods, metabolite profiling) | Capitalisation + spelling                      | "iv) … C8 reversed-phase chromatography"  |
| "**Plasma metabolite and lipid profiles were measured using a four complimentary** liquid chromatography…" | "complimentary" → "complementary"; "a four" → "four" | "Plasma metabolite and lipid profiles were measured using four complementary liquid chromatography…" |
| "**Mass spectroscopic (MS) analyses**" (×3 in HILIC-pos paragraph) | "Spectroscopic" → "spectrometric"              | "Mass spectrometric (MS) analyses"        |
| Acknowledgements: "R01DK136134 to VT, and HL122515, **DK135868, DK135868** to RMS" | Duplicate grant number                         | List "DK135868" once; check whether the second was meant to be DK136796. |
| Methods §"Network Analysis": "Reactome pathways75, … standard bridge-node metric in network medicine**⁸⁴**" | Superscript jump (⁸⁴ inside a paragraph that otherwise uses 73–77) suggests the wrong reference number. | Verify reference numbering — likely "78" or "84" misplaced. |
| Methods §"Network Analysis": "Module identification and annotation … Disease Ontology terms76 … WikiPathways74, Gene Ontology73, Reactome75 **    77** as integrated within the SPOKE knowledge graph." | Stray whitespace + orphan superscript "77".    | Remove orphan "77" or attach it to the relevant resource. |
| Methods §"Network statistics": "**[Authors: specify software package, e.g., Python NetworkX v3.X or R igraph v1.5.X]**" | Placeholder text                              | Replace with "igraph R package v2.3.0" (this is what `make_curated_network_plot.R` actually uses). |
| Methods §"Metabolite risk score (MetRS) construction" and §"Model validation" | The paragraph beginning "Model performance was evaluated using repeated 10-fold cross-validation …" is **duplicated** (appears twice — once in MetRS construction §, once in Model validation §), and the equation paragraph "MetRS was computed for each participant as a weighted linear combination …" is also **duplicated** in those two sections. | Delete one copy of each. |
| Methods §Estonian Biobank Ethics: "approved under the **University of Tartu** biobank protocol"; Acknowledgements/STAR § Ethics statement: "Estonia Biobank under the **University of Turku** biobank protocol" | Two different universities cited for the same cohort. Tartu (Estonia) is the Estonian Biobank host; Turku is in Finland. | Standardise on "University of Tartu". |
| Manuscript uses both **"Estonia Biobank"** and **"Estonian Biobank"** (and "Estonia Biobank Obesity Extremes cohort") | Inconsistent | Pick one — "Estonian Biobank" is the official institution name. |
| Manuscript uses **"Supplemental"** and **"Supplementary"** interchangeably ("Supplemental Fig.", "Supplemental Table" vs "Supplementary Table 1b" insert) | Inconsistent | Cell Reports Medicine style is "Supplemental" — use that consistently. |
| Figure 4 legend: "Manhattan plots for the genome wide association study of the metabolites in the Framingham Heart Study cohort (**n = 1508**)" vs Methods (FHS): "Analysis was limited to individuals with available genomic data (**n = 1,613**)" | Sample-size inconsistency | Reconcile — 1,613 is in methods; 1,508 is in fig legend. State the analytic N used in GWAS and explain any further exclusion. |
| Methods Demographics: "Ancestry was predominantly European-descent (**[XX]**%)" | Placeholder | Fill in the actual percentage. |
| STAR Methods §"Annotation confidence": "both candidate identities (**HMDB0000555 and HMDB0000714**)" but the Supplemental Note says pimelic acid = HMDB0000857 and the data file lists Pimelic acid = HMDB00555 | The HMDB IDs do not match across the manuscript, the supplemental note, and the data. | Reconcile: 3-methyladipic acid = HMDB00555? Pimelic acid HMDB ID per HMDB is HMDB00714; confirm with HMDB and fix both the manuscript and the Supplemental Note so the IDs agree. |
| "Pre-surgery baseline fasting LABS-2 plasma samples were processed within 2 hours of collection" | OK as-is.                                    | —                                         |
| Methods §"GWAS analysis": "**GWAS Analyses** were performed on the MetRS" | "Analyses" should be lowercase                | "analyses"                                |
| Methods §"FHS genotyping …": "SNPs with excessive plate effects (p < 1 × 10−7) **or excessive deviation from Hardy-Weinberg equilibrium**" | Unicode minus sign vs ASCII minus is inconsistent across the manuscript | Unify to either Unicode "×" / "−" or HTML throughout. |
| Methods §"FHS genotyping": "imputed using the Michigan Imputation Server81 with the Haplotype Reference Consortium reference panel (HRC r1.1 2016)82" | Salem #89 supplied full Das et al. 2016 citation — add to reference list if not already present. | — |

### 3B. Clarity / structural

- **Abstract.** Apply Salem #5: name the metabolite–locus pairs. Current sentence "common variants in loci including AGXT2 and SLC7A5 associated with key MetRS metabolites" is uninformative without naming BAIBA / kynurenine.
- **Introduction final paragraph.** "We hypothesized that preoperative plasma metabolite profiles could identify signatures predictive of long-term weight trajectory following RYGB." Good — but the very next sentence "To test this, we profiled pre-surgery fasting plasma …" then describes everything that was done. Consider splitting into "what we did" (one sentence) and "what we found" (one or two sentences at the end of the intro). Reviewers expect a one-line preview of findings.
- **Results §"Metabolomic profiling and univariate associations".** The first sentence currently reads "Untargeted metabolomic was performed on preoperative fasting plasma using liquid chromatography…". After resolving Salem #31 it should read "Untargeted metabolomic profiling was performed on preoperative fasting plasma…" — "metabolomic was performed" is ungrammatical.
- **Results §"Construction and stability of the Metabolite Risk Score".** "AIC-based feature selection by stepwise regression" — say "AIC-based stepwise feature selection" (active wording).
- **Results §"Biological network context of MetRS metabolites".** Reorganise so that each named module names the metabolites first, the connecting bridge nodes second, and the disease anchor third (currently mixed order). See §4 for the substantive rewrite of the D-glucuronic acid module.
- **Discussion ¶3 ("Among the enriched modules, the bile acid/GLP-1 axis …").** The phrase "*FXR activation is increasingly recognized as a key mechanism by which bariatric surgery improves metabolic dysfunction beyond caloric restriction37*, and steatotic liver disease, which frequently co-occurs with obesity, predicts poor surgical response." is two sentences joined by "and" — split. Also add a citation for the "frequently co-occurs … predicts poor surgical response" clause (see §5).
- **Discussion ¶5 ("Beyond these network-level findings, several individual MetRS metabolites merit brief mention.").** This paragraph is dense — consider splitting into two paragraphs at "Lower preoperative levels of N-acetylserine …". Within it, each metabolite needs (i) directionality (higher in regain vs sustained), (ii) one mechanistic citation, (iii) one biological interpretation. Audit each — some currently lack the citation.
- **Discussion ¶6 ("Conversely, β-aminoisobutyric acid …").** "Although BAIBA has been shown to promote thermogenesis and improve glucose handling, its elevation here may reflect a compensatory response to early mitochondrial dysfunction or a maladaptive signal in this surgical context." — this is the paper's most counter-intuitive finding and deserves more careful treatment, including: (i) directional review of human BAIBA-BMI studies (see §5), (ii) acknowledgment that BAIBA is also higher in older subjects, (iii) a sentence on whether the regression coefficient is robust to leverage points / a few high-BAIBA outliers.
- **Discussion limitations ¶.** Move Salem #88 (female-skew → sex-specific power limitation) here.

---

## 4. Network analysis — claims-vs-data audit

Source: `figures/Fig2de/data/curated_nodes_enriched.csv` and
`curated_edges.csv` (the same files driving `make_curated_network_plot.R`,
which produces `fig2d.1.png` → `Figure2D` in the submission folder).

Verified totals match the manuscript:

- **169 nodes, 235 edges** ✓
- Node-type counts: 21 Compounds, 52 Genes, 32 Proteins, 38 Pathways, 14 Biological Processes, 12 Diseases ✓
- Top compound bridge: Malonic acid 0.268 (manuscript says 0.27) ✓
- Top disease bridge: obesity 0.361 (manuscript 0.36); T2DM 0.085 (manuscript 0.08) ✓
- L-kynurenine betweenness 0.169 ≈ 0.17 ✓; TDO2 0.123 ≈ 0.12 ✓
- D-Glucuronic Acid betweenness 0.120 ≈ 0.12 ✓
- GCG 0.165 ≈ 0.17 ✓
- NOS3 0.127 ≈ 0.13 ✓; L-Homoarginine 0.093 ≈ 0.09 ✓
- PPARG 0.125 ≈ 0.13 ✓; PPARA 0.100 ≈ 0.10 ✓
- Additional diseases present: steatotic liver disease (0.039), MASLD, MASH, atherosclerosis, cardiovascular system disease, cholestasis ✓

So the **topological summary statistics** are accurate. The **module-level
narrative claims**, however, contain several connectivity statements that
the underlying edges do **not** support.

### 4A. The bile-acid / GLP-1 module (D-glucuronic acid)

> **Results §"Biological network context":** "The first connected D-glucuronic acid (betweenness 0.12), to GCG (0.17), the highest-betweenness gene in the subgraph, and **through GCG reached the GLP-1 incretin pathway nodes, the bile-acid-sensing nuclear receptor NR1H4 (FXR), CYP7A1, FGF19, and GLP1R.**"
>
> **Discussion ¶3 (anchored by Thaker comment #77):** "D-glucuronic acid, the sugar donor for UDP-glucuronosyltransferase-mediated bile-acid conjugation, **connected directly to GCG** (the proglucagon gene encoding GLP-1), **GLP-1R, NR1H4 (FXR), CYP7A1, and FGF19**, recapitulating this circuit."

Empirically in the curated subgraph:

| Pair                                  | Shortest path                                                                          | Length |
| ------------------------------------- | -------------------------------------------------------------------------------------- | ------ |
| D-Glucuronic Acid → GCG               | D-Gluc-A → ABHDA_HUMAN → Malonic acid → obesity → GCG                                  | **4**  |
| D-Glucuronic Acid → NR1H4             | D-Gluc-A → ABHDA_HUMAN → Malonic acid → obesity → NR1H4                                | **4**  |
| D-Glucuronic Acid → CYP7A1            | D-Gluc-A → ABHDA_HUMAN → Malonic acid → obesity → CYP7A1                               | **4**  |
| D-Glucuronic Acid → FGF19             | … → CYP7A1 → regulation of bile-acid biosynthesis → FGF19                              | **6**  |
| D-Glucuronic Acid → GLP1R             | … → GCG → GLP-1 from intestine/pancreas … → GLP1R                                      | **6**  |
| GCG → NR1H4                           | GCG → type 2 diabetes mellitus → NR1H4                                                 | **2**  |
| GCG → CYP7A1                          | GCG → obesity → CYP7A1                                                                 | **2**  |
| GCG → FGF19                           | GCG → T2DM → NR1H4 → regulation of bile-acid biosynthesis → FGF19                      | **4**  |

D-Glucuronic Acid's **direct first-degree neighbors** are: UGT1A1, UGT1A3,
ABHDA_HUMAN, CD44_HUMAN, DPP4_HUMAN, IHH_HUMAN, UD11_HUMAN. **GCG is not
among them.** GCG's direct neighbors are GLP-1 from intestine/pancreas
pathway, GLP-1 secretion from intestine to portal vein, Hunger and satiety,
Thermogenesis, obesity, T2DM. **None of NR1H4, CYP7A1, FGF19, GLP1R is a
direct neighbor of GCG.**

The biologically coherent connection that *is* in the data is: **D-Glucuronic
Acid → UGT1A1 / UGT1A3** (UDP-glucuronosyltransferases — exactly the enzymes
implicated in bile-acid conjugation). UGT1A3 in particular is documented to
glucuronidate primary bile acids in humans. **The "circuit" the discussion
asserts is therefore not the actual edges in this subgraph; it is the
biological circuit one would draw on a textbook map.** The two are easy to
confuse but they are not the same.

This is precisely what Thaker comment **#52** and **#77** are asking, and
what Salem indirectly raised with comment #5 (which loci/metabolites are
"key").

> **Action — rewrite the D-glucuronic acid passages so the network text
> matches the network data.** Two options:
>
> 1. **Strict** ("only describe edges that exist"): "D-glucuronic acid
>    directly connects to the UDP-glucuronosyltransferases UGT1A1 and
>    UGT1A3, which catalyse the glucuronidation of bile acids; through the
>    obesity disease hub it is two steps away from NR1H4 (FXR), CYP7A1, and
>    GCG, situating glucuronate within a bile-acid / GLP-1 axis that the
>    network organises around the obesity hub."
> 2. **Lenient** ("describe a Steiner / shared-neighbor module"): "A
>    bile-acid / GLP-1 module emerged that contained D-glucuronic acid,
>    UGT1A1/UGT1A3 (glucuronidation), NR1H4 (FXR), CYP7A1, FGF19, GCG, and
>    GLP1R; these nodes were connected to one another via the obesity and
>    T2DM disease bridges and the bile-acid-biosynthesis-regulation
>    process node." This formulation keeps the biological "circuit" claim
>    without asserting direct edges that do not exist.
>
> Either option is defensible. The current phrasing "connected directly"
> and "through GCG reached" is not — both are factually incorrect for the
> curated subgraph.

### 4B. The kynurenine / tryptophan module

> **Results:** "anchored on L-kynurenine (0.17) and recovered the hepatic rate-limiting enzyme TDO2 (0.12) together with KYNU, KYAT3, and GOT2, and the tryptophan/kynurenine pathway nodes."

Direct neighbors of L-kynurenine: AATC_HUMAN, IDO1, IDO2, KAT3_HUMAN, KMO,
KYNU, KYNU_HUMAN, TDO2. **L-kynurenine → TDO2 ✓ and → KYNU ✓ direct.**
**L-kynurenine → KYAT3 is 2 hops (via KAT3_HUMAN), L-kynurenine → GOT2 is 3
hops** (L-kynurenine → KYNU → Tryptophan metabolism → GOT2). Calling KYAT3
and GOT2 "recovered together with" TDO2 and KYNU is a stretch.

> **Action:** Rewrite to: "anchored on L-kynurenine (0.17) and connecting
> directly to TDO2 (0.12), KYNU, IDO1/IDO2, KMO, and KAT3 (the gene encoding
> kynurenine aminotransferase 3); through the Tryptophan-metabolism pathway
> node it reached GOT2 and the broader kynurenine/NAD biosynthetic
> network." Same content, but accurate about which connections are direct.

### 4C. The malonic-acid / BAIBA / fatty-acid-oxidation module

> **Results:** "linked malonic acid (0.27) and β-aminoisobutyric acid (BAIBA) to PPARA and PPARG (betweenness 0.10 and 0.13, respectively), CPT1A, and fatty acid oxidation."

Empirically:

| Pair                          | Shortest path                                                                  | Length |
| ----------------------------- | ------------------------------------------------------------------------------ | ------ |
| Malonic acid → CPT1A          | Malonic acid → CPT1A                                                           | 1 ✓    |
| Malonic acid → PPARA          | Malonic acid → obesity → PPARA                                                 | 2      |
| Malonic acid → PPARG          | Malonic acid → obesity → PPARG                                                 | 2      |
| BAIBA → PPARA                 | BAIBA → PPARA                                                                  | 1 ✓    |
| BAIBA → PPARG                 | BAIBA → UCP2 → T2DM → PPARG                                                    | 3      |
| BAIBA → CPT1A                 | BAIBA → PPARA → positive regulation of fatty acid β-oxidation → CPT1A          | 3      |

Malonic acid → CPT1A and BAIBA → PPARA are direct. The other "linked to"
claims pass through obesity / T2DM / UCP2.

> **Action:** Reword to "Malonic acid connected directly to CPT1A,
> dicarboxylic-acid metabolism nodes, and the obesity hub; through obesity
> it linked to PPARA, PPARG, and the broader PPAR-signalling pathway. BAIBA
> connected directly to PPARA and UCP2 and through PPARA reached CPT1A and
> the fatty-acid-β-oxidation process node." This is accurate **and** does
> not weaken the biological interpretation.

### 4D. The NOS3 / homoarginine module

> **Results:** "centered on NOS3, endothelial nitric oxide synthase (betweenness 0.13) and connected to L-homoarginine (0.09)."

NOS3 direct neighbors include L-Homoarginine ✓. **This claim is supported
by the data — no change needed.**

### 4E. The pimelic / 3-methyladipic acid "fifth module"

> **Results:** "linked pimelic acid and 3-methyladipic acid, the two structural isomers comprising the composite MetRS feature (see STAR Methods), to fatty acid oxidation nodes **shared with the malonic acid/BAIBA module**."

In the actual graph:

- Pimelic acid direct neighbors: ODC_HUMAN, PTH_HUMAN, dicarboxylic fatty acid.
- 3-Methyladipic acid direct neighbors: dicarboxylic fatty acid only.
- Pimelic acid → Malonic acid is **8 hops**.
- Pimelic acid → CPT1A is **9 hops**.

The two isomers connect to each other through the `dicarboxylic fatty acid`
compound node, but they do **not** share fatty-acid-oxidation nodes with
the malonic-acid / BAIBA module in any meaningful network-distance sense.

> **Action:** Either (i) acknowledge that the pimelate/3-methyladipate
> sub-cluster sits at the periphery of the subgraph linked only via
> dicarboxylic-fatty-acid metabolism, with the fatty-acid-oxidation
> interpretation drawn from external biological literature rather than from
> the SPOKE topology (this matches what the Supplemental Note actually
> argues), or (ii) drop the "shared with the malonic acid/BAIBA module"
> phrase. Option (i) is more accurate.

### 4F. Figure-layout perception (Thaker #52)

Visual inspection of `figures/Fig2de/fig2d.1.png` confirms Thaker's
observation: BAIBA, 13-HODE, PC 34:2 and L-Homoarginine are rendered closer
to GCG than D-Glucuronic Acid is. This is the Kamada-Kawai layout
faithfully reflecting the graph distances above — i.e., the layout is
correct and the *text* is what needs to change.

### 4G. Other network-section minor edits

- Body says "the curated subgraph contained 169 nodes and 235 edges,
  distributed as 21 compounds, 52 genes, 32 human proteins, 38 pathways,
  14 biological processes, and 12 diseases" — order matches the script
  legend `c("Compound","Gene","Protein","Disease","BiologicalProcess","Pathway")`
  but counts in the manuscript follow Compound/Gene/Protein/Pathway/BioProc/Disease.
  Choose one consistent order (the figure legend uses the alphabetical
  legend order in the panel; the body text orders by node-class size).
  Currently they read coherently — flag only if reviewer raises it.

- "Betweenness centrality identified obesity (0.36) and type 2 diabetes
  mellitus (0.08) as the two highest-ranked disease bridge nodes" — true,
  but **steatotic liver disease (0.039)** is the third disease, and is
  worth naming since it is a major target of the Discussion's "MASLD/MASH"
  framing.

- "additional disease nodes present in the subgraph included steatotic
  liver disease, MASLD, MASH, cardiovascular disease, and atherosclerosis,
  though with substantially lower betweenness." → atherosclerosis (degree
  1) and cardiovascular system disease (degree 1) are pendant nodes; they
  arguably don't contribute to "modules" and could be removed from the
  rhetorical list.

---

## 5. Citations needed / suggested

Where I think a citation is missing or where a reviewer comment explicitly
asks for one. Citation suggestions are biased toward what would be widely
accepted in the bariatric / metabolomics literature; final selection is the
authors' call.

### 5A. From explicit comments

| Comment | Topic | Suggested citation |
| ------- | ----- | ------------------ |
| Salem #42 ("cite my BMI MRS paper") | Methodological precedent for constructing a weighted metabolite risk score from regression coefficients | Salem RM, Robinson JG, et al. "A polygenic and metabolite risk score for body mass index" (the most recent metabolite-risk-score paper from the Salem group). Ask Rany for the canonical citation. |
| Salem #70 ("UK Biobank PheWeb — references or website") | Source for the PheWeb result reported | Gagliano Taliun SA, VandeHaar P, Boughton AP, Welch RP, Taliun D, Schmidt EM, Zhou W, Nielsen JB, Willer CJ, Lee S, Fritsche LG, Boehnke M, Abecasis GR. *Exploring and visualizing large-scale genetic associations by using PheWeb.* Nat Genet 2020;52:550–552. URL: https://pheweb.org/UKB-TOPMed/ |
| Salem #89 (Michigan Imputation Server) | Imputation pipeline | Das S et al. *Next-generation genotype imputation service and methods.* Nat Genet 2016;48:1284–1287. Already in supplied list — add to reference list under [81]. |
| Salem #59 (rs13174300 ancestry / PheWAS) | gnomAD v4 and HugeAMP sources | gnomAD v4: Chen S et al. "A genomic mutational constraint map using variation in 76,156 human genomes." Nature 2024;625:92–100. HugeAMP / Common Metabolic Diseases Knowledge Portal: Costanzo MC et al. "The Type 2 Diabetes Knowledge Portal: An open access genetic resource…" Cell Metab 2023;35:695–710. |

### 5B. Where the manuscript makes claims that currently lack a supporting reference

| Location | Claim | Suggested reference |
| -------- | ----- | ------------------- |
| Intro ¶3, end: "minimal integration with complementary molecular or genetic data" | Generic statement about prior MBS metabolomics studies. | Add 1–2 representative MBS-metabolomics reviews — e.g., Ramos-Molina B, Castellano-Castillo D et al. "Multi-omics in obesity and bariatric surgery: state of the art and future perspectives." Obes Rev 2022, or Tabasi M et al. "Metabolomic signatures of bariatric surgery." |
| Results §"MetRS predicts long-term weight regain": "consistent with prior reports that younger age at surgery is a risk factor for long-term weight regain¹³" | One citation only — consider adding King WC et al. *JAMA* 2018 7-year weight outcomes in LABS-2. | King WC, Hinerman AS, Belle SH, Wahed AS, Courcoulas AP. *Comparison of the Performance of Common Measures of Weight Regain After Bariatric Surgery for Association With Clinical Outcomes.* JAMA 2018;320:1560–1569. |
| Discussion ¶3: "FXR activation is increasingly recognized as a key mechanism by which bariatric surgery improves metabolic dysfunction beyond caloric restriction³⁷" | Single citation for a strong claim. | Add Albaugh VL et al. *Bile acids and bariatric surgery.* Mol Aspects Med 2017, and Ryan KK et al. *FXR is a molecular target for the effects of vertical sleeve gastrectomy.* Nature 2014;509:183–188. |
| Discussion ¶3: "steatotic liver disease, which frequently co-occurs with obesity, predicts poor surgical response." | No citation. | Lassailly G et al. *Bariatric Surgery Provides Long-term Resolution of Nonalcoholic Steatohepatitis and Regression of Fibrosis.* Gastroenterology 2020;159:1290–1301. |
| Discussion ¶3: "the magnitude of the post-RYGB GLP-1 response varies substantially between individuals and independently predicts weight outcomes, yet the preoperative determinants of this variability remain poorly understood." | No citation. | le Roux CW et al. *Gut hormones as mediators of appetite and weight loss after Roux-en-Y gastric bypass.* Ann Surg 2007;246:780–785. AND Holst JJ et al. *Mechanisms in bariatric surgery: gut hormones, diabetes resolution, and weight loss.* Surg Obes Relat Dis 2018;14:708–714. |
| Discussion ¶4 (kynurenine): "IDO1- and TDO2-driven tryptophan catabolism is induced by adipose-tissue macrophage inflammation, and its circulating output tracks body-mass index and insulin resistance across human cohorts³⁸,³⁹." | Two citations present. | Confirm 38 / 39 are the intended ones (likely Mangge H et al. 2014 *Obesity*; Favennec M et al. 2015 *Obesity*). If not, replace with these. |
| Discussion ¶4 (BAIBA): "established role of BAIBA as an exercise-induced, PGC-1α-dependent myokine that amplifies PPARα signaling to drive white-adipose browning and hepatic β-oxidation⁴⁰." | One citation. | Add Roberts LD et al. *β-Aminoisobutyric acid induces browning of white fat and hepatic β-oxidation and is inversely correlated with cardiometabolic risk factors.* Cell Metab 2014;19:96–108. (Already cited in the Supplemental Note.) |
| Discussion ¶4 (homoarginine): "Low circulating homoarginine, an endogenous NOS substrate, is an independent risk marker for cardiovascular and renal mortality across multiple cohorts⁴⁴" | One citation. | Add März W et al. *Homoarginine, cardiovascular risk, and mortality.* Circulation 2010;122:967–975. |
| Discussion ¶5 (4-hydroxyhippuric acid): "linked to higher fruit and vegetable intake and improved metabolic profile⁴⁹,⁵⁰" | Two citations. | Confirm intended refs. Likely Pallister T et al. *Hippurate as a metabolomic marker of gut microbiome diversity: Modulation by diet and relationship to metabolic syndrome.* Sci Rep 2017;7:13670. |
| Discussion ¶5 (1-methylguanosine): "1-methylguanosine⁵⁴" | One ref. | Add Liu J et al. on RNA-modification metabolites and metabolic disease if a more specific reference is desired. |
| Discussion ¶5 (N-carbamoyl-β-alanine): "N-carbamoyl-β-alanine⁵⁵" | One ref. | Confirm — likely a pyrimidine catabolism reference. |
| Discussion ¶6 (BAIBA elevated in regain — counterintuitive): "Although BAIBA has been shown to promote thermogenesis and improve glucose handling, its elevation here may reflect a compensatory response …" | No supporting citation for the "compensatory response" interpretation. | Add Stautemas J et al. *Acute Aerobic Exercise Leads to Increased Plasma Levels of R- and S-β-Aminoisobutyric Acid in Humans.* Front Physiol 2019, AND a citation showing BAIBA rises with mitochondrial dysfunction in insulin-resistant states (e.g., Tanianskii DA et al. *β-Aminoisobutyric Acid as a Novel Regulator of Carbohydrate and Lipid Metabolism.* Nutrients 2019;11:524.) |
| Discussion ¶7: "consistent with the concept of a metabolic set point influenced by genetic factors" | No citation. | Add Müller MJ et al. *Is there evidence for a set point that regulates human body weight?* F1000 Med Rep 2010;2:59. |
| Discussion ¶8 (GLP-1 + bariatric, perioperative): "preoperatively to reduce liver volume and perioperative risk⁶⁵" / "postoperatively to mitigate weight regain⁶⁶" / "broad efficacy across metabolic, cardiovascular, and renal outcomes⁶⁷" | Three citations. | Confirm 65–67. Suggestions: Mok J et al. *Safety and Efficacy of Liraglutide as a Bridge to Bariatric Surgery* (perioperative); Mok J et al. or Wharton S et al. on GLP-1 receptor agonists for post-bariatric regain; Marso SP et al. *Liraglutide and Cardiovascular Outcomes in Type 2 Diabetes (LEADER).* NEJM 2016 — confirm or replace with intended refs. |
| Methods §"Network Analysis" — "the standard bridge-node metric in network medicine⁸⁴" | One reference. | If this is meant to point to Barabási A-L, Gulbahce N, Loscalzo J. *Network medicine: a network-based approach to human disease.* Nat Rev Genet 2011;12:56–68 — confirm. |

### 5C. Reviewer-likely-to-ask additions

- A short citation for **SPOKE** in the Results network paragraph (the
  reference is already in the Methods as ref 28; one in Results would help
  readers who don't reach the methods).
- A citation for **`brokenstick`** R package in the Methods (Hugo C et al.,
  Stat Med 2014, or the brokenstick CRAN paper). The package is named but
  not cited.
- A citation for **`MatchIt`** in the Methods (Ho DE, Imai K, King G, Stuart
  EA. *MatchIt: nonparametric preprocessing for parametric causal
  inference.* J Stat Softw 2011;42:1–28).

---

## 6. Summary punch-list (the highest-priority items)

In rough priority order — these are the items that should be settled before
the next round:

1. **Renumber supplemental figures** so body-text Supp Fig. 5/6/7/8 match
   on-disk files (or vice versa). Add the missing `SupplementaryFigure8.pdf`
   (FHS GWAS) or accept SF7 as the GWAS figure and update the text.
2. **Re-export Figure 3** so panels B and C match the body text (RMSE/MAE
   first or ROC first — pick one), and **re-export Figure 4** with the
   panels A↔B descriptions corrected in the legend.
3. **Rewrite the network-section sentences about D-glucuronic acid → GCG /
   NR1H4 / CYP7A1 / FGF19 / GLP1R** to match the actual graph edges (§4A).
   Apply the same fix to Discussion ¶3. Resolves Thaker #52 and #77.
4. **Reconcile the Figure 4 Manhattan panel set** (text claims 5 metabolites
   with GWS loci; figure shows 4, one of which — C34:2 PC — isn't in the
   list).
5. **Remove duplicated paragraphs** in the Methods (two copies of the
   model-validation paragraph and two of the MetRS equation paragraph).
6. **Fix the `Fig. 1f` references** in the Results paragraphs about year-5
   model-derived EBW and %EBW5 definition.
7. **Resolve the "Targeted and untargeted" tracked-change** (Salem #31) —
   revert to "Untargeted".
8. **Address all open May-2026 Salem comments** (#5, #7, #26, #27, #31, #40,
   #42, #44, #64, #70, #76, #84) — specific actions in §2.
9. **Sweep typos and inconsistencies** in §3A.
10. **Citation pass** (§5) — fill in missing references and confirm the
    seven explicit citation prompts from reviewer comments.

---

*Compiled from `Med_Met_11May26_WG.docx` + `submissions/med/figures/*` +
`submissions/med/supplement/*` + `figures/Fig2de/data/*`.*

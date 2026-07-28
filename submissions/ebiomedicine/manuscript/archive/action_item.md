# Action Items — CRM_met_23Apr26.docx

**Most recent manuscript:** `CRM_met_23Apr26.docx` (last modified Apr 24, 2026)
**Comments extracted from:** 40 comments by Rany Salem (Apr 7–9) and Vidhu Thaker (Apr 11–25)
**Separate documents to integrate:** `LC-MS_methods_042426.docx`, `Network Analysis Writeup.docx`

---

## 1. Content to Integrate from Separate Documents

### 1a. LC-MS Methods (`LC-MS_methods_042426.docx`)

The detailed metabolomics methods are **not currently in the main manuscript**. The manuscript currently has only a brief sentence mentioning LC-MS across four methods. The full detailed protocol (HILIC-pos, HILIC-neg, C18-neg, C8-pos instrument settings, column conditions, internal standards, TraceFinder/Progenesis processing) from `LC-MS_methods_042426.docx` must be added to the Methods section.

### 1b. Network Analysis (`Network Analysis Writeup.docx`)

The figure descriptions for **Fig 2D** (network graph) and **Fig 2E** (betweenness centrality bar charts) and associated Methods, Results, and Discussion paragraphs are in `Network Analysis Writeup.docx`. Verify that the current manuscript's Fig 2 legend and body text fully incorporate this content and that figure descriptions match the actual network figure.

### 1c. Supplemental Note (`supplement/Supplemental Note.docx`)

The biological interpretation of the composite MetRS feature **3-methyladipate/pimelate** exists as a standalone note. Confirm it is cited or referenced appropriately within the manuscript.

---

## 2. Figure Changes

### Fig 2: Remove Panel B

- **Salem (Apr 8):** "Panels B and C are redundant (displaying effectively the same information) — recommend dropping panel B (as there orders metabolites based on clustering scheme)."

- **Thaker (Apr 23):** "Agree with this suggestion."

- **Action:** Remove Fig 2B (Pearson correlation bubble plot). Renumber subsequent panels.

my opinion: already done , skip this one

### Fig 2D / Network: Verify Node Assignments

- **Thaker (Apr 25):** "In the figure, BAIBA, 13-HODE, L-homarginine, and PC34:2 appear closer to GCG than D-glucuronic acid. Is this correct?"

- **Thaker (Apr 25, on Discussion):** "Once again, is it correct to use D-glucuronic acid here, or should it be BAIBA, 13-HODE etc?"

- **Action:** Check network figure layout — confirm which metabolites are graphically closest to GCG. Update text (Results network section and Discussion) to accurately reflect the figure topology.

my opinion: yes , do exactly that

### Fig 3: Re-order Panels — Panel C First

- **Salem (Apr 8):** "Re-order so panel C is first?"

- **Action:** Discuss panel reordering for Fig 3. If agreed, reorder and update figure legend and in-text references.

my opinion: already flipped.      update the references accordingly throughout 

### Fig 4 (GWAS): Replace Manhattan Plots with LocusZoom

- **Salem (Apr 8):** "Should we replace Manhattan plots with LocusZoom plots for associated regions?"

- **Action:** Confirm whether to replace Manhattan plots with LocusZoom plots for significant GWAS loci. LocusZoom plots are already generated for glucuronate, hippurate, kynurenine, C34:2 (see `figures/Fig4defg/`).

my opinion: no lets keep the manhatten plots since the locus zoom plots are not as interesting.   so no change here. 

### Supp Fig 2: Clarify Redundancy and Axis Units

- **Salem (Apr 8):** "Unclear what Supp Fig 2 is providing that is not already provided by Fig 1c."

- **Salem (Apr 8):** "Also Supp fig 2b is strange — please confirm that y-axis units change in EBW is correct (is this supposed to be % change in EBW?)"

- **Action:** Either justify Supp Fig 2 by clarifying what it adds beyond Fig 1c, or remove it. Verify the y-axis label on Supp Fig 2b.

my opinion:  make sure that each figure in supp fig 2 is referenced    now we have quite a few more figures there.   

### Supp Fig 3: Fix or Remove Surgical Center Stratification

- **Salem (Apr 8):** "Supp Figure 3 does not support for surgical center."

- **Action:** Either add a surgical center stratification panel to Supp Fig 3 or remove the claim that this figure supports center effects.

my opinion:  yes remove the center strata claim - the figure should be kept as it is

### Supp Fig 5: Consider Converting Heatmap to Table

- **Salem (Apr 8):** "Supp fig 5 is a Heatmap — table instead?"

- **Action:** Discuss whether Supp Fig 5 (heatmap of 541 metabolites) should be converted to a supplemental table.

my opinion:  keep the figure as it is (althought this should be referring to figure supp 3 now ? 

### Missing Figure Reference

- **Salem (Apr 8):** "Where is this fig?" (comment on Supp Fig reference in methods/results)

- **Action:** Locate and reconcile the missing figure reference. Likely refers to a supplemental figure that was renumbered or removed.

---

## 3. Text Revisions

### Terminology: Remove Word Associated with "Criminal Activities"

- **Salem (Apr 7):** "Sounds like you're referring to criminal activities … why not regain?" (anchored to Summary/Introduction)

- **Action:** Replace the flagged term with "weight regain" throughout.

my opinion: yes, lets use the more reasonable and less misleading weight regain throughout. 

### Terminology: "Modest" Weight Loss

- **Salem (Apr 7):** "Don't like the use of 'modest' here — ~50kg (~50% of EBW) is not modest."

- **Action:** Replace "modest" with a more accurate descriptor (e.g., "substantial" or specify the magnitude).

my opinion: yes, or just use words to show that one is simply lower or higher than the other, does not need to say modest.. 

### %EBW5 Definition: Add Formula and Clarify

- **Salem (Apr 8):** "Does not clarify what %EBW5 means."

- **Salem (Apr 8):** "Maybe provide formula?"

- **Salem (Apr 8):** "Not sure why, but I first read this as change in EBW — might be a 'me' issue, but won't hurt for you to double check."

- **Action:** Revise the %EBW5 definition to read unambiguously. Explicit current formula: (EBW at year 5 / baseline EBW) × 100. Consider rephrasing to make clear this is a proportion retained, not a change.

  

my opinion: add minimal texual clarification to make sure it is clear

### Simplify MetRS Sentence in Results

- **Salem (Apr 8):** "Simplify to: 'The MetRS remained a strong predictor of weight regain across unadjusted and adjusted models.'"

- **Action:** Replace the current multi-clause sentence with Salem's suggested text.

my opinion: yes agree, make the changes as suggested 

### "Microbial Activity" Clarification

- **Salem (Apr 7):** "Are you referring to microbial 'diversity' or specifically to microbial 'activity' level?"

- **Thaker (Apr 11):** "Microbial activity as the word suggests."

- **Action:** Confirm the text reads "gut microbial activity" not "diversity" — appears already correct; verify no edits introduced "diversity" elsewhere.

my opinion:  yes. make this change

### Biomarker Definition Clarification

- **Salem (Apr 7):** "Are you referring to biomarkers specifically as biological biomarkers or more broadly, including patient characteristics?"

- **Thaker (Apr 11):** "This refers to measurable markers."

- **Action:** Confirm the term "biomarker" is used broadly (measurable markers) and the Introduction is clear on this point.

- my opinion:  yes do that . 

### Figure/Abbreviation Consistency: "Fig" vs "Fig."

- **Salem (Apr 8):** "Need to be consistent: either 'Fig' or 'Fig.' throughout."

- **Action:** Do a global find-and-replace to standardize to one format (recommend "Fig.") across the entire manuscript.

- my opinion:  yes, make sure this is consistent throughout. 

### Discovery Cohort Sentence Revision

- **Salem (Apr 9):** "Revise — Does not sound right." (anchored to LABS-2 discovery cohort description)

- **Action:** Revise the sentence describing selection of discovery cohort subjects. Note: do not describe subjects as "selected" — they were included based on class membership correlated with long-term weight loss trajectory. (See comment [36] in `CRM_met_20Mar26_rs.docx` for detailed guidance.)

- my opinion: yes, revise exactly as suggested. 

### Sex Imbalance as Limitation

- **Salem (Apr 9):** "Shouldn't we note in limitation section?" (anchored to sex imbalance paragraph: 82.5% female)

- **Action:** Add a Limitations statement noting the predominantly female sample (82.5%) and its implications for generalizability.

- my opinion:   add a very brief sentence in the limitations section about this. 

---

## 4. Methods Gaps

### LC-MS Methods: Add Full Protocol

- **Salem (Apr 8):** "Need details — Not detailed in methods." (anchored to LC-MS sentence)

- **Salem (Apr 8):** "Also confirm this was performed." (re: specific QC step)

- **Action:** Insert the complete LC-MS protocol from `LC-MS_methods_042426.docx` into the manuscript Methods section (four LC-MS methods: HILIC-pos, HILIC-neg, C18-neg, C8-pos). 

- my opinion: read the LC-MS_methods_042426.docx   and add another supplementary note including a brief description of the methods of LC-MS mirroring the format of the current supplementary note.    and refer to this in the methods section

### Metabolomics QC: Add Columbia QC Protocol

- **Thaker (Apr 23):** Provided the Columbia QA/QC protocol text (see comment [35] in manuscript):

> *"QAQC samples prepared along with the study samples consisted of pooled plasma samples and a standard reference material (NIST SRM 1958). Pool 1 (20–35 years old) and Pool 2 (50+ years old) were injected at regular intervals to monitor instrument stability. Data quality assessed by median RSD of stable isotope-labeled internal standards (<20% threshold), TIC distributions, PCA clustering of QC and study samples, and intensity trends of selected reference metabolites. Features with high variability or inconsistent behavior across QC samples were excluded."*
>
>
- **Salem (Apr 8):** "What are the sample QC filters?"

- **Salem (Apr 9):** "Could not find" (reference to QC section)

- **Action:** Add this Columbia QC protocol to the metabolomics Methods section. Also specify the exact sample QC filters (RSD threshold, feature exclusion criteria).

- my opinion:  use this text and integrate it with the supplementary note (additional) about the lcms methods.   

### Genotype Imputation: Add Reference

- **Salem (Apr 9):** Provided the reference for genotype imputation:

> Das S, Forer L, Schönherr S, et al. Next-generation genotype imputation service and methods. *Nature Genetics* 48, 1284–1287 (2016).
>
>
- **Action:** Add this citation to the GWAS quality control and imputation Methods section.

- my opinion: yes, add this citation and use 1 - 2 (at most 3) sentences to very briefly talk about the QC of GWAS. 

---

## 5. GWAS / Genetics Section

### AGXT2 Variant rs13174300: Add Annotation

- **Salem (Apr 8):** "Need to detail/describe this variant: intronic, common in European ancestry (less common in others). PheWAS associations: age of menarche (2.35e-6), triglycerides (5.6e-5)."

- Resources: [dbSNP](https://www.ncbi.nlm.nih.gov/snp/rs13174300#frequency_tab), [gnomAD](https://gnomad.broadinstitute.org/region/5-35002141-35002151?dataset=gnomad_r4), [HugeAMP](https://hugeamp.org/variant.html?variant=5%3A35002251%3AC%3AA), [PheWeb](https://pheweb.org/UKB-TOPMed/variant/5:35002146-C-A)

- **Thaker (Apr 22):** "Please add the description that you believe is helpful."

- **Action:** Add variant annotation for rs13174300 in the GWAS results: intronic AGXT2 variant, minor allele relatively common in Europeans; PheWAS signals include age of menarche and triglycerides.

- my opinion: some info should be there already added. check to see if that is good 

### AGXT2 Variants: Report LD Structure

- **Salem (Apr 8):** "Also, what is the LD between the four AGXT2 variants?"

- **Action:** Calculate and report pairwise LD (r²) between the four AGXT2 GWAS hits. Determine if they are independent signals or one LD block.

- my opinion: they are not independent, quickly calculate the LD pattern 

### Metabolite GWAS: Check MetRS Association

- **Salem (Apr 8):** "Were any of these [individual metabolite GWAS loci] associated with MetRS (even nominally)?"

- **Action:** Test association of significant individual-metabolite GWAS loci with the overall MetRS score. Report any nominal (p < 0.05) or significant associations.

- my opinion: yes, do that. 

### GWAS Results: Create Summary Table

- **Salem (Apr 8):** "Organizing all the genetic results into a table would be helpful."

- **Action:** Create a supplemental table of all genome-wide significant GWAS hits (metabolite, SNP ID, position, gene/locus, effect, p-value, and any PheWAS annotations).

- my opinion: yes, do that. 

### LDSC: Consider Heritability Analysis

- **Salem (Apr 7):** "We could run LDSC on GWAS results to estimate the heritability of the identified metabolites (haven't, but could be easily done if need be)."

- **Action:** Decide whether to run LD score regression (LDSC) on GWAS results to report SNP-heritability estimates for MetRS metabolites.

- my opinion: that might be hard with the gwas that we did with the limited sample size. we dont have to do this now, but will do if the external reviewers asks for it 

---

## 6. Forest Plot (Fig 3d): Keep as Figure

- **Salem (Apr 8):** "Why not table?" (referring to forest plot of adjusted/unadjusted MetRS models)

- **Thaker (Apr 22):** "I think figure is a better visual representation."

- **Action:** Retain forest plot as a figure. No change needed.

- my opinion: agreed

---

## 7. Previously Noted Tasks (from `tasks/Tasks.txt`, Apr 23, 2026)

These items from the existing task list are incorporated here for completeness:

- [ ] Add demographic details of the FHS cohort to the manuscript

- [ ] Expand GWAS section based on Salem's comments (see Section 5 above)

- [ ] Remove Fig 2B (see Section 2 above)

- [ ] Supplemental Table 1: Demographic/laboratory details of discovery cohort

- [ ] Supp Fig 1: EBW at baseline, 1-yr, 3-yr and weight regain (entire RYGB LABS-2 cohort)

- [ ] Supp Fig 2: Longitudinal EBW trajectories among matched RYGB subgroups, with exact numbers table

- [ ] Supp Fig 3: Longitudinal weight trajectories and cohort characteristics (4 plots: EBW spaghetti, %EBW, by sex, by center)

- [ ] Supp Fig 4: Heatmap of metabolites with univariate associations

- [ ] Supp Fig 5: Bootstrap stability, p-value histogram, Q-Q plot

- [ ] Supp Fig 6: Post-RYGB cohort — PLS-DA and cohort summary; MetRS-10 boxplot

- [ ] Supp Fig 7: Estonia cohort — PLS-DA and cohort summary; MetRS-8 boxplot

- [ ] Supp Fig 8: Fully annotated network plot

- [ ] Supp Fig 9: GWAS-related figures

- [ ] Supplemental Table: All univariate metabolites

- [ ] Supplemental Note: 3-methyladipic acid and pimelate (already drafted in `supplement/Supplemental Note.docx`)

---

## Priority Summary

| Priority | Item                                                          |
| -------- | ------------------------------------------------------------- |
| High     | Integrate LC-MS methods into manuscript (Section 4)           |
| High     | Remove Fig 2B; renumber panels (Section 2)                    |
| High     | Add Columbia QC protocol to Methods (Section 4)               |
| High     | Add %EBW5 formula and clarify definition (Section 3)          |
| High     | Add rs13174300 variant annotation to GWAS section (Section 5) |
| High     | Standardize "Fig" vs "Fig." globally (Section 3)              |
| High     | Revise discovery cohort selection sentence (Section 3)        |
| Medium   | Create GWAS summary table (Section 5)                         |
| Medium   | Verify network figure node proximity to GCG (Section 2)       |
| Medium   | Add sex imbalance to Limitations (Section 3)                  |
| Medium   | Add genotype imputation reference (Section 4)                 |
| Medium   | Calculate LD between AGXT2 variants (Section 5)               |
| Medium   | Check MetRS nominal association with GWAS hits (Section 5)    |
| Medium   | Replace "modest" re: weight loss (Section 3)                  |
| Medium   | Decide on LocusZoom vs Manhattan plots (Section 2)            |
| Low      | Clarify Supp Fig 2 vs Fig 1c redundancy (Section 2)           |
| Low      | Fix Supp Fig 3 surgical center panel (Section 2)              |
| Low      | Consider LDSC heritability analysis (Section 5)               |
| Low      | Decide on Supp Fig 5 heatmap → table (Section 2)              |

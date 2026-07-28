# Gene/Protein Nomenclature Correction Table

## Guiding Principle

In the SPOKE knowledge graph, **PPARA, PPARG, NOS3, GCG, TDO2, IDO1, NR1H4, CYP7A1, FGF19, GLP1R, DPP4, CPT1A, KYNU, KYAT3, GOT2, UGT1A1, UGT1A3** are all classified as **Gene** nodes. Per HUGO/HGNC convention, human gene symbols should be **italicized and all-caps** (e.g., *PPARA*). Protein products are written in roman (non-italic) text, often with different formatting (e.g., PPARα for the protein).

Since the Results network section describes findings from a gene-level knowledge graph, all references to SPOKE Gene nodes should use italicized gene symbols. The Discussion may use protein names when describing biochemistry from the literature, but this should be done consistently and deliberately.

---

## Correction note on IDO1

IDO1 **is** present in the curated SPOKE subgraph (7 edges, betweenness = 0.027, ranked 15th among 52 genes). However, it is far below the top-5 betweenness genes (GCG 0.16, NOS3 0.13, PPARG 0.12, TDO2 0.12, PPARA 0.10) and appears as an **unlabeled node** in Figure 2d. It is never mentioned in the Results. See separate IDO1 recommendation.

---

## Section-by-Section Corrections

### SUMMARY (Line 25)

| # | Current text | Correction | Reason |
|---|-------------|------------|--------|
| 1 | `*AGXT2 *and* SLC7A5*` | `*AGXT2* and *SLC7A5*` | Fix broken italic markup — stray spaces inside asterisks |

---

### RESULTS — Biological network context (Line 69)

**Problem:** Every gene name in this paragraph is in plain roman text, but these are all SPOKE Gene nodes being discussed as network findings. All should be italicized.

| # | Current text | Correction | Reason |
|---|-------------|------------|--------|
| 2 | `UGT1A1 and UGT1A3` | `*UGT1A1* and *UGT1A3*` | Gene nodes in SPOKE; need italics |
| 3 | `connected to DPP4, the enzyme responsible for GLP-1 degradation` | `connected to *DPP4*, the gene encoding the enzyme responsible for GLP-1 degradation` | DPP4 is a Gene node in SPOKE; clarify that the network node is the gene, not the protein |
| 4 | `this module reached GCG (0.17)` | `this module reached *GCG* (0.17)` | Gene node; needs italics |
| 5 | `nuclear receptor NR1H4 (FXR), CYP7A1, FGF19, and GLP1R` | `nuclear receptor gene *NR1H4* (FXR), *CYP7A1*, *FGF19*, and *GLP1R*` | All Gene nodes; needs italics. "FXR" is kept in parentheses as the common protein alias for reader clarity |
| 6 | `rate-limiting enzyme TDO2 (0.12) together with KYNU, KYAT3, and GOT2` | `rate-limiting enzyme gene *TDO2* (0.12) together with *KYNU*, *KYAT3*, and *GOT2*` | All Gene nodes; need italics |
| 7 | `PPARA and PPARG (betweenness 0.10 and 0.13, respectively), CPT1A` | `*PPARA* and *PPARG* (betweenness 0.10 and 0.13, respectively), *CPT1A*` | Gene nodes; need italics. Use official gene symbols (not Greek PPARα/PPARγ) since these refer to SPOKE network nodes |
| 8 | `The fourth module centered on NOS3, endothelial nitric oxide synthase` | `The fourth module centered on *NOS3*, encoding endothelial nitric oxide synthase` | Gene node; needs italics; clarify gene-protein relationship |

---

### RESULTS — Genetic architecture (Line 73)

| # | Current text | Correction | Reason |
|---|-------------|------------|--------|
| 9 | `At the AGXT2 locus on chromosome 5p13` | `At the *AGXT2* locus on chromosome 5p13` | Gene locus; needs italics |
| 10 | `Three additional AGXT2 variants` | `Three additional *AGXT2* variants` | Gene name; needs italics |
| 11 | `the polygenic architecture previously described for AGXT2` | `the polygenic architecture previously described for *AGXT2*` | Gene name; needs italics |

---

### RESULTS — Genetic architecture (Line 75)

No changes needed — `*AGXT2*` is already italicized here.

---

### RESULTS — Genetic architecture (Line 77)

No changes needed — `*SLC7A5*` is already italicized here.

---

### DISCUSSION — Bile acid/GLP-1 paragraph (Line 85)

**Problem:** This paragraph discusses both literature-level biology (proteins/receptors) and the study's own network findings (gene nodes). The two contexts are mixed without formatting distinction.

| # | Current text | Correction | Reason |
|---|-------------|------------|--------|
| 12 | `activate farsenoid X receptor (FXR) and Takeda G protein coupled receptor (TGR5)` | No change needed | Literature context, describing proteins/receptors — roman text is correct here. (But fix the typo: "farsenoid" → "farnesoid") |
| 13 | `connected directly to GCG (the proglucagon gene encoding GLP-1), GLP-1R, NR1H4 (FXR), CYP7A1, and FGF19` | `connected directly to *GCG* (the proglucagon gene encoding GLP-1), *GLP1R*, *NR1H4* (FXR), *CYP7A1*, and *FGF19*` | These refer to the study's own network nodes (Gene nodes in SPOKE); need italics. Also: "GLP-1R" should be "*GLP1R*" to match the SPOKE gene symbol (the hyphenated "GLP-1R" denotes the receptor protein) |
| 14 | `FXR activation is increasingly recognized` | No change needed | Literature statement about the FXR protein; roman is appropriate |

---

### DISCUSSION — Kynurenine/tryptophan paragraph (Line 87)

| # | Current text | Correction | Reason |
|---|-------------|------------|--------|
| 15 | `*IDO1*- and *TDO2*-driven tryptophan catabolism` | `*TDO2*-driven tryptophan catabolism` (or: `TDO2- and IDO1-driven tryptophan catabolism`, using roman for the literature-level protein reference and italics only for the network gene) | IDO1 is not discussed in the Results. If kept, it should be clearly marked as a literature reference, not a study finding. See IDO1 recommendation. |
| 16 | `the PPARα/PPARγ pair` | `the *PPARA*/*PPARG* pair` | These refer to the network nodes discussed in the preceding Results paragraph. Should match the gene symbol convention. If the intent is to discuss protein-level function, write: "the PPARα and PPARγ proteins (encoded by *PPARA* and *PPARG*)" |
| 17 | `amplifies PPARα signaling` | `amplifies PPARα signaling` | This is a literature-level statement about the protein's biological function — roman PPARα is acceptable here. However, it creates a jarring switch mid-sentence from gene symbols to protein names. **Recommendation:** use one convention per sentence. E.g., "…anchored on malonic acid, BAIBA, and *PPARA*/*PPARG*, reflects the established role of BAIBA…that amplifies *PPARA*-mediated signaling…" |
| 18 | `centered on *NOS3* and nitric oxide biosynthesis` | No change needed | Already correctly italicized |

---

### DISCUSSION — BAIBA paragraph (Line 91)

| # | Current text | Correction | Reason |
|---|-------------|------------|--------|
| 19 | `common variants in AGXT2, the BAIBA-regulating enzyme` | `common variants in *AGXT2*, encoding the BAIBA-regulating enzyme` | Gene name needs italics; AGXT2 is the gene, not the enzyme itself |
| 20 | `multiple independent *AGXT2* variants` | No change needed | Already correct |

---

### DISCUSSION — Precision bariatrics paragraph (Line 97)

| # | Current text | Correction | Reason |
|---|-------------|------------|--------|
| 21 | `including *IDO1*, *PPARA*, FXR, and GLP-1 receptor signaling` | `including *TDO2*, *PPARA*, *NR1H4* (FXR), and *GLP1R*` | (a) Replace *IDO1* with *TDO2* — TDO2 is the high-betweenness gene actually recovered by the network (see IDO1 note). (b) FXR should be cited by its gene symbol *NR1H4* with "(FXR)" as alias, since this sentence explicitly claims these are "network genes." (c) "GLP-1 receptor signaling" should reference the gene node *GLP1R* for consistency. |

---

### FIGURE 2 LEGEND (Line 108)

| # | Current text | Correction | Reason |
|---|-------------|------------|--------|
| 22 | `*GCG*, *NOS3*, *PPARG*, *TDO2*, *PPARA*` | No change needed | Already correctly italicized as gene symbols |

---

## Summary of the PPARα/PPARA Problem

The manuscript uses three conventions for the same two entities:

| Convention | Where used | Context |
|-----------|-----------|---------|
| PPARA / PPARG (roman, gene symbol) | Results line 69 | Network findings |
| PPARα / PPARγ (roman, Greek, protein name) | Discussion line 87 | Literature biology |
| *PPARA* / *PPARG* (italic, gene symbol) | Discussion line 97, Figure legend line 108 | Network genes / figure |

**Recommended rule:** When referring to the SPOKE network node or GWAS locus → *PPARA*, *PPARG* (italicized gene symbol). When referring to the protein's biochemical activity in a literature context → PPARα, PPARγ (roman, Greek). Never mix the two conventions within the same clause.

---

## Summary of the GLP1R / GLP-1R / GLP-1 receptor Problem

| Convention | Where used |
|-----------|-----------|
| GLP1R (roman, no hyphen) | Results line 69 |
| GLP-1R (hyphenated) | Discussion line 85 |
| GLP-1 receptor signaling | Discussion line 97 |

In SPOKE this is Gene node **GLP1R**. Recommendation: use *GLP1R* (italicized, no hyphen) when referring to the gene/network node. Use "GLP-1 receptor" or "GLP-1R" (roman) only when discussing the protein in a literature context.

---

## Summary of the FXR / NR1H4 Problem

| Convention | Where used |
|-----------|-----------|
| NR1H4 (FXR) (roman) | Results line 69, Discussion line 85 |
| FXR alone (roman) | Discussion lines 85, 97 |

In SPOKE this is Gene node **NR1H4**. Recommendation: First mention in each section → *NR1H4* (FXR). Subsequent references in the same paragraph → FXR is fine as an established alias. In the "network genes" sentence (line 97), use *NR1H4* (FXR) since the claim is specifically about what the network recovered.

---

## Quick-Reference: All Gene Nodes Mentioned in Manuscript

| Gene | SPOKE type | Results (line 69) | Discussion | Fig legend | Correct |
|------|-----------|-------------------|------------|------------|---------|
| GCG | Gene | roman ✗ | roman ✗ | *italic* ✓ | *GCG* |
| NOS3 | Gene | roman ✗ | *italic* ✓ | *italic* ✓ | *NOS3* |
| PPARG | Gene | roman ✗ | PPARγ (mixed) ✗ | *italic* ✓ | *PPARG* (gene) or PPARγ (protein) |
| PPARA | Gene | roman ✗ | PPARα (mixed) ✗ | *italic* ✓ | *PPARA* (gene) or PPARα (protein) |
| TDO2 | Gene | roman ✗ | *italic* ✓ | *italic* ✓ | *TDO2* |
| NR1H4 | Gene | roman ✗ | roman ✗ | — | *NR1H4* |
| CYP7A1 | Gene | roman ✗ | roman ✗ | — | *CYP7A1* |
| FGF19 | Gene | roman ✗ | roman ✗ | — | *FGF19* |
| GLP1R | Gene | roman ✗ | GLP-1R ✗ | — | *GLP1R* |
| DPP4 | Gene | roman ✗ | — | — | *DPP4* |
| CPT1A | Gene | roman ✗ | — | — | *CPT1A* |
| KYNU | Gene | roman ✗ | — | — | *KYNU* |
| KYAT3 | Gene | roman ✗ | — | — | *KYAT3* |
| GOT2 | Gene | roman ✗ | — | — | *GOT2* |
| UGT1A1 | Gene | roman ✗ | — | — | *UGT1A1* |
| UGT1A3 | Gene | roman ✗ | — | — | *UGT1A3* |
| IDO1 | Gene | not mentioned | *italic* ✓ | — | Remove or downgrade (see IDO1 note) |
| AGXT2 | Gene | — | mixed ✗ | — | *AGXT2* throughout |
| SLC7A5 | Gene | — | *italic* ✓ | — | *SLC7A5* ✓ |

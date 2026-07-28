# Variant Contextualization: rs13174300 (AGXT2 locus)

**Manuscript context:** rs13174300 is the lead signal at the AGXT2 locus in the FHS Offspring GWAS and is independently associated with the composite MetRS after conditioning on nearby BAIBA-specific variants (rs37376, rs163910, rs11749934), suggesting its effect on the score may extend beyond BAIBA alone.

---

## Variant Summary

| Field | Value |
|---|---|
| rsID | rs13174300 |
| Position (GRCh38) | chr5:35,002,146 |
| Position (GRCh37) | chr5:35,002,251 |
| Gene | *AGXT2* (alanine–glyoxylate aminotransferase 2; Gene ID: 64902) |
| Functional class | Intronic (non-coding; consistent across all transcripts) |
| Alleles | C (ref) → A (alt) |

---

## Population Frequency (gnomAD v4 / dbSNP ALFA / TOPMed)

The A allele is **common in European populations** and substantially less frequent in African and East Asian ancestry groups — a frequency gradient directly relevant to the composition of the FHS Offspring discovery cohort (predominantly Non-Finnish European).

| Population | Allele Frequency (A) |
|---|---|
| Non-Finnish European (NFE) | **38.6%** |
| Finnish | **41.7%** |
| Ashkenazi Jewish | 33.2% |
| Latino/Admixed American | 28.2% |
| South Asian | 20.3% |
| **African/African-American** | **17.4%** |
| **East Asian** | **11.5%** |
| Global (TOPMed, n=264k) | 28.2% |

---

## Phenome-Wide Associations (PheWAS)

**HugeAMP (AMP-T2D-GENES portal; quantitative traits):**
- **Age of menarche:** p = 2.35 × 10⁻⁶ — the strongest PheWAS signal; this connection between an AGXT2 intronic variant and reproductive timing is biologically plausible given that BAIBA (the primary metabolite catabolized by AGXT2) modulates energy homeostasis and adipose browning, both of which are determinants of pubertal onset and body composition.
- **Triglycerides:** p = 5.6 × 10⁻⁵ — consistent with BAIBA's documented role in promoting mitochondrial fatty acid oxidation; elevated BAIBA (as would be predicted by a reduced-function AGXT2 allele) is associated with improved lipid profiles.

**UKB-TOPMed PheWeb (binary disease PheCodes, n = 1,419 traits):**
- No phenotype reached genome-wide significance; the top nominal signal was nontoxic nodular goiter (p = 1.1 × 10⁻³), which lacks an obvious mechanistic link and likely reflects multiple testing noise. Obesity, T2D, and hyperlipidemia PheCodes showed no association (p > 0.08), consistent with the effect of this intronic variant being primarily at the metabolite-QTL level rather than manifest as overt disease risk in a general population.

---

## AGXT2 Biology and Manuscript Relevance

AGXT2 encodes a mitochondrial aminotransferase that is the principal enzyme for BAIBA catabolism, converting BAIBA to methylmalonate semialdehyde. Variants at this locus are among the most consistently replicated metabolite-QTLs in population studies; the three BAIBA-specific signals (rs37376, rs163910, rs11749934) identified in our GWAS are consistent with this literature. The independence of rs13174300 from these BAIBA signals — and its association with the composite MetRS — implies that this variant may additionally influence other AGXT2 substrates (e.g., (R)-3-amino-2-methylpropanoate) or act through expression-level effects that span a broader set of metabolic pathways captured by the score.

The PheWAS profile of rs13174300 reinforces the manuscript's central argument: the MetRS indexes a **pre-existing cardiometabolic state** rather than a surgery-specific phenomenon. The association with age of menarche connects AGXT2 variation to energy balance and body composition regulation long before any surgical intervention; the triglyceride association links it to the fatty acid oxidation axis that is one of the four cardiometabolic hubs mapped through SPOKE. The European-ancestry enrichment of the risk allele is germane to interpreting statistical power in the FHS discovery cohort and highlights the need for multi-ancestry GWAS replication to assess generalizability of the MetRS genetic architecture.

---

## Suggested Manuscript Text (for reviewer response / Results section)

> rs13174300 (chr5:35,002,146; GRCh38) is an intronic variant in *AGXT2* with an alternate-allele frequency of ~39% in Non-Finnish Europeans and substantially lower frequencies in African (~17%) and East Asian (~12%) ancestry groups (gnomAD v4). Despite its non-coding location, it emerged as an independent MetRS signal after conditioning on three nearby BAIBA-associated variants, suggesting its effect may extend beyond BAIBA catabolism alone. Phenome-wide association analyses (HugeAMP) identified nominal associations with age of menarche (p = 2.35 × 10⁻⁶) and serum triglycerides (p = 5.6 × 10⁻⁵), consistent with BAIBA's established roles in adipose tissue browning and mitochondrial fatty acid oxidation. In the UK Biobank PheWeb analysis (binary disease outcomes), no association reached genome-wide significance, suggesting the variant's primary phenotypic footprint is at the metabolite-QTL level rather than manifest as overt disease risk in a general population.

---

*Generated 2026-04-30 from: dbSNP rs13174300, gnomAD v4, HugeAMP AMP-T2D-GENES PheWAS, UKB-TOPMed PheWeb, and manuscript CRM_met_23Apr26.docx.*

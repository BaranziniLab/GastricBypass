# MetRS Metabolites in SPOKE: A Network Biology Deep-Dive into Weight Loss and Regain After RYGB Surgery

## Executive Summary

This report presents a systematic network traversal of the SPOKE biomedical knowledge graph to identify biological pathways and molecular mechanisms linking 14 metabolites from a Metabolite Risk Score (MetRS) — associated with weight trajectories after Roux-en-Y gastric bypass (RYGB) — to plausible mechanistic themes. The analysis recovered **166 unique nodes** (compounds, genes, biological processes, pathways, diseases, protein domains) and **188 edges** connecting them across seven major pathway themes plus several emergent biology areas.

The network reveals that the MetRS is not a random collection of metabolites; rather, it captures a coordinated snapshot of at least seven interlocking biological systems that are reshaped by bariatric surgery and whose dysregulation may predict weight regain.

---

## 1. Network Architecture Overview

The 14 MetRS metabolites connect to the broader SPOKE graph through the following pathway themes:

| Theme | Key MetRS Metabolites | Central Hub Genes | Key Pathways |
|-------|----------------------|-------------------|--------------|
| Fatty acid oxidation / Energy sensing | Malonate, BAIBA | CPT1A, ACACA/B, PRKAA1/2, SDHA-D | FA beta-oxidation, TCA cycle, AMPK signaling |
| Bile acid / Enterohepatic / GLP-1 | Glucuronate | CYP7A1, NR1H4 (FXR), FGF19, GCG, GLP1R | Bile acid synthesis, GLP-1 signaling, Hunger & satiety |
| One-carbon metabolism / Antioxidant defense | Hydroxyproline, 1-Methylguanosine | PRODH, ALDH4A1, EGLN1, SIRT1 | Proline metabolism, HIF oxygen sensing, NAD metabolism |
| Mitochondrial integrity / Redox | Malonate, BAIBA | SDHA-D, UCP2, GPX4 | ETC Complex II, Ferroptosis, Thermogenesis |
| Inflammation (Kynurenine pathway) | L-Kynurenine | IDO1/2, TDO2, KMO, KYNU, AFMID | Tryptophan metabolism, IDO pathway, NAD biosynthesis |
| Vascular tone (NO via homoarginine) | L-Homoarginine, DMGV | NOS1/2/3, GATM, GAMT | Effects of NO, Leptin signaling, Creatine pathway |
| Gut-microbiome interactions | 4-Hydroxyhippuric acid, 3-Ureidopropionic acid | SLC22A6, DPYD, UPB1 | Pyrimidine catabolism, OAT transport |
| Lipid handling / PPAR signaling | 13-HODE, PC 34:2, 3-Methyladipic acid | ALOX15, PPARG, PPARA, SREBF1 | PPAR signaling, Eicosanoid/LOX metabolism, Adipogenesis |

---

## 2. Detailed Pathway Narratives

### 2.1 Fatty Acid Oxidation and Hypothalamic Energy Sensing

**Key MetRS metabolites:** Malonate, 2-Aminoisobutyric acid (BAIBA)

Malonate occupies a unique position in metabolic regulation. In SPOKE, it binds 442 protein domains and directly inhibits succinate dehydrogenase (SDH/Complex II: SDHA, SDHB, SDHC, SDHD), positioning it as a sentinel of mitochondrial TCA cycle flux. More critically, malonate is the free-acid form of malonyl-CoA, the master regulator of the CPT1A/CPT1B fatty acid oxidation gateway. The malonyl-CoA axis — controlled by acetyl-CoA carboxylases ACACA and ACACB — is the primary mechanism by which hypothalamic energy sensing regulates systemic fat burning vs. storage. When malonyl-CoA rises (signaling energy surplus), CPT1A is inhibited and fatty acid oxidation shuts down; when it falls (energy deficit), fat burning resumes.

After RYGB, the dramatic caloric restriction and gut hormone changes fundamentally reset this axis. Malonate levels in the MetRS may reflect the capacity of the malonyl-CoA/AMPK/CPT1A circuit to maintain the "fat-burning" state. SPOKE confirms that PRKAA1 and PRKAA2 (AMPK subunits) directly participate in insulin signaling (WP481), energy metabolism (WP1541), lipid metabolism (WP3965), and nonalcoholic fatty liver disease (WP4396) — all pathways remodeled by bariatric surgery.

BAIBA (2-aminoisobutyric acid) extends this story. Known as an exercise-mimicking myokine, BAIBA activates PPARA-mediated fat oxidation and upregulates UCP2 (uncoupling protein 2), promoting brown-fat-like thermogenesis. In the SPOKE network, these connect through PPAR signaling (WP3942), differentiation of white and brown adipocyte (WP2895), and energy metabolism (WP1541). BAIBA's inclusion in the MetRS likely captures the extent to which post-surgical physiology maintains an "exercised" metabolic state.

### 2.2 Bile Acid / Enterohepatic Metabolism and the GLP-1 Link

**Key MetRS metabolite:** D-Glucuronic acid

Glucuronate's network connections in SPOKE reveal a deep link to bile acid metabolism and, through it, to the GLP-1/incretin axis that is fundamentally altered by RYGB. Glucuronate is the substrate/product of UDP-glucuronosyltransferases (UGT1A1, UGT1A3, and >20 other UGT family members) that conjugate bile acids, bilirubin, and xenobiotics for excretion. UGT1A3 specifically conjugates bile acids, directly tying glucuronate to the enterohepatic cycle.

SPOKE reveals that the bile acid master regulators — CYP7A1 (rate-limiting enzyme of bile acid synthesis), NR1H4/FXR (bile acid receptor), and FGF19 (enterohepatic feedback signal) — are all directly associated with obesity (DOID:9970) and type 2 diabetes (DOID:9352). NR1H4/FXR is further associated with MASLD, MASH, cholestasis, and metabolic dysfunction. RYGB profoundly alters bile acid pools by rerouting bile flow, and the resulting FXR/FGF19 activation is thought to be a key mechanism by which surgery improves metabolism beyond simple caloric restriction.

Crucially, bile acid signaling through FXR and TGR5 (GPBAR1) stimulates GLP-1 secretion from L-cells. SPOKE confirms that GCG (proglucagon, the GLP-1 precursor) participates in GLP-1 glucose homeostasis (WP5452), hunger and satiety (WP5445), thermogenesis (WP4321), and SCFA/skeletal muscle metabolism (WP4030). GLP1R connects to these same pathways. Glucuronate levels in the MetRS may therefore serve as a proxy for the capacity of the bile acid/UGT conjugation system — and by extension, the strength of the bile acid → FXR → GLP-1 signaling cascade that sustains weight loss after RYGB.

### 2.3 One-Carbon Metabolism, Antioxidant Defense, and Collagen Turnover

**Key MetRS metabolites:** Hydroxyproline, 1-Methylguanosine

Hydroxyproline is primarily a collagen degradation marker. SPOKE connects it to PRODH, ALDH4A1, HOGA1, and GOT2 through 4-hydroxyproline catabolic and metabolic processes. These enzymes feed hydroxyproline carbon into the TCA cycle, connecting collagen turnover directly to energy metabolism. P4HA1 (prolyl-4-hydroxylase) and EGLN1 (HIF prolyl-hydroxylase) provide a bridge to oxygen sensing — EGLN1 hydroxylates HIF-1α to mark it for degradation, and this reaction depends on the same 2-oxoglutarate/Fe²⁺/ascorbate cofactors as collagen hydroxylation.

After massive weight loss, extensive tissue remodeling and collagen turnover occur. The MetRS likely captures this remodeling activity. Hydroxyproline also has a Phase 1.5 clinical trial for primary hyperoxaluria, reflecting its catabolism to oxalate (via HOGA1) — a known risk after RYGB.

1-Methylguanosine is a modified nucleoside released during RNA turnover. It connects to SIRT1 (a NAD-dependent deacetylase) through the broader NAD metabolism network. SIRT1 is directly associated with obesity and type 2 diabetes in SPOKE, and participates in NAFLD (WP4396). Post-surgical improvements in NAD+ metabolism and sirtuin activity are part of the metabolic reset that sustains weight loss.

### 2.4 Mitochondrial Integrity and Redox Status

**Key MetRS metabolites:** Malonate, BAIBA, Hydroxyproline

The mitochondrial theme emerges from the convergence of multiple MetRS compounds. Malonate's inhibition of SDH/Complex II (confirmed by SPOKE domain bindings to all four SDH subunits) directly impairs the electron transport chain. All four SDH genes (SDHA-D) participate in TCA cycle (WP78), ETC/OXPHOS (WP111), and mitochondrial complex II assembly (WP4920) — and importantly, also in nonalcoholic fatty liver disease (WP4396), connecting mitochondrial dysfunction to hepatic steatosis.

BAIBA's activation of UCP2 introduces a thermogenic/uncoupling component. GPX4 (glutathione peroxidase 4), identified through the lipoxygenase pathway that produces 13-HODE, participates in ferroptosis (WP4313) — iron-dependent cell death driven by lipid peroxidation. The 13-HODE/ALOX15/GPX4 axis therefore connects oxidized lipid metabolism to cell survival decisions, relevant to the oxidative stress that accompanies rapid weight change.

### 2.5 Inflammation: The Tryptophan/Kynurenine Pathway

**Key MetRS metabolite:** L-Kynurenine

L-Kynurenine is the most biologically connected MetRS metabolite in terms of pathway complexity. SPOKE identifies 11 genes in kynurenine metabolism: IDO1, IDO2, TDO2 (the initiating enzymes converting tryptophan → kynurenine), KMO, KYNU, KYAT1, KYAT3, AADAT, AFMID, ALDH8A1, and GOT2. These genes collectively participate in tryptophan metabolism (WP465), the kynurenine/senescence pathway (WP5044), IDO metabolic pathway (WP5414), NAD biosynthesis from tryptophan (WP2485), and tryptophan catabolism to NAD (WP4210).

The immunometabolic significance is profound. IDO1 is the rate-limiting enzyme for kynurenine production under inflammatory conditions, and SPOKE shows it is associated with immune system disease, autoimmune disease, and multiple cancers. After RYGB, the dramatic reduction in adipose-tissue-driven inflammation should suppress IDO1 activity, lowering kynurenine. Patients who fail to suppress kynurenine may have persistent inflammatory drive — explaining its predictive value for weight regain.

Moreover, the kynurenine pathway competes with serotonin synthesis for tryptophan, linking inflammation to mood and appetite regulation. TDO2 connects to monoamine transport (WP727), while the broader pathway links to NAD biosynthesis — connecting inflammatory tryptophan diversion to cellular energy currency.

L-kynurenine is the only MetRS metabolite with a clinical max phase (Phase 1), reflecting active drug development around this pathway for immunotherapy.

### 2.6 Vascular Tone: Nitric Oxide via Homoarginine

**Key MetRS metabolites:** L-Homoarginine, DMGV

L-Homoarginine's binding to the NOS oxygenase domain (PF02898) in SPOKE directly confirms its role as an alternative NOS substrate. NOS3 (endothelial NOS) is directly associated with obesity (DOID:9970) and type 2 diabetes (DOID:9352) in SPOKE, and participates in leptin signaling (WP2034), PI3K-Akt signaling (WP4172), effects of NO (WP1995), and the VEGFA-VEGFR2 pathway. NOS3 is therefore a convergence point for metabolic, vascular, and adipokine signaling.

Homoarginine is produced by GATM (glycine amidinotransferase / AGAT), which in SPOKE participates in the creatine pathway (WP5190) and urea cycle (WP497). GATM is the same enzyme that initiates creatine biosynthesis, linking homoarginine to the creatine/phosphocreatine energy buffer system. Low homoarginine = low GATM activity = impaired creatine synthesis + impaired NO production — a double hit on cardiovascular health and energy metabolism.

DMGV (2-oxo-5-(3,3-dimethylguanidine-1-yl)pentanoic acid) extends this axis. It derives from asymmetric dimethylarginine (ADMA) metabolism and the GATM pathway. ADMA is an endogenous NOS inhibitor, and DMGV levels reflect the balance between methylarginine production and clearance — a direct readout of vascular NO availability and cardiovascular risk.

### 2.7 Gut-Microbiome Interactions

**Key MetRS metabolites:** 4-Hydroxyhippuric acid, 3-Ureidopropionic acid (N-Carbamoyl-beta-alanine)

4-Hydroxyhippuric acid is a classic gut-microbial co-metabolite. Dietary polyphenols are metabolized by gut bacteria to produce 4-hydroxybenzoic acid, which is then conjugated with glycine in the liver to form 4-hydroxyhippuric acid. SPOKE confirms its transport by SLC22A6 (OAT1), the organic anion transporter in the kidney — establishing the gut → liver → kidney elimination axis. Changes in 4-hydroxyhippuric acid after RYGB reflect altered gut microbiome composition and function, which is dramatically restructured by the surgical re-routing of the GI tract.

3-Ureidopropionic acid (N-carbamoyl-beta-alanine) is an intermediate of pyrimidine catabolism, produced by DPYD (dihydropyrimidine dehydrogenase) and DPYS, and metabolized by UPB1 to beta-alanine. Both host liver enzymes and gut bacteria contribute to pyrimidine catabolism. Beta-alanine itself has connections to carnosine synthesis and exercise physiology, providing another link to the energy/exercise theme.

### 2.8 Lipid Handling: PPAR Signaling and Membrane Composition

**Key MetRS metabolites:** 13-HODE, PC 34:2, 3-Methyladipic acid/Pimelic acid

13-HODE (13-hydroxy-9,11-octadecadienoic acid) is produced by ALOX15 (15-lipoxygenase) from linoleic acid. SPOKE places ALOX15 in eicosanoid/LOX metabolism (WP4721), eicosanoid synthesis (WP167), and ferroptosis (WP4313). Critically, 13-HODE is an endogenous PPARG ligand — SPOKE confirms PPARG's participation in PPAR signaling (WP3942), adipocyte differentiation (WP2895), nuclear receptors in lipid metabolism (WP299), and energy metabolism (WP1541). PPARG is associated with both obesity and T2DM.

After RYGB, changes in 13-HODE reflect altered linoleic acid handling and oxidized lipid signaling. Since PPARG drives adipocyte differentiation and lipid storage, 13-HODE levels may indicate whether the post-surgical state favors fat mobilization vs. renewed fat accumulation.

PC 34:2 (phosphatidylcholine 34:2) represents membrane phospholipid remodeling. As the major phospholipid in cell membranes and lipoproteins, PC species reflect the balance between phospholipid synthesis (Kennedy pathway) and remodeling (Lands cycle). Changes in PC 34:2 after RYGB may indicate altered hepatic lipid secretion (VLDL composition), bile composition, or cellular membrane turnover.

3-Methyladipic acid and pimelic acid are medium-chain dicarboxylic acids that arise from branched-chain and odd-chain fatty acid oxidation. Their presence in the MetRS captures the efficiency of peroxisomal and mitochondrial fatty acid oxidation pathways.

---

## 3. Convergence Points: Where Pathways Meet

Several genes and pathways emerge as critical convergence hubs where multiple MetRS metabolites interact:

**GOT2 (Glutamic-oxaloacetic transaminase 2):** Participates in both kynurenine metabolism AND hydroxyproline catabolism, while also operating in the malate-aspartate shuttle (mitochondrial redox), amino acid metabolism, and glycolysis/gluconeogenesis. GOT2 is a true metabolic integrator connecting inflammation, collagen turnover, and energy metabolism.

**NOS3:** Associated with obesity and T2DM, participating in leptin signaling and PI3K-Akt — it is the convergence point for homoarginine/DMGV (vascular) and adipokine signaling (metabolic).

**NR1H4/FXR:** Associated with obesity, T2DM, MASLD, MASH, and cholestasis — it bridges bile acid metabolism (glucuronate) to GLP-1 signaling (GCG/GLP1R) and hepatic lipid handling.

**PPARA/PPARG:** Connected to BAIBA (FAO activation), 13-HODE (PPARG ligand), fatty acid oxidation, adipogenesis, and insulin signaling. The balance between PPARA (fat burning) and PPARG (fat storage) may be central to weight trajectory.

**SIRT1:** Associated with obesity and T2DM, connects NAD metabolism (1-methylguanosine link), bile acid regulation, and NAFLD to the broader metabolic reset.

---

## 4. Disease Network

SPOKE disease associations confirm the clinical relevance of the MetRS network:

| Disease | # Pathway Genes Associated | Key Genes |
|---------|---------------------------|-----------|
| Obesity | 18 | NOS3, LEP, SIRT1, NPY, SREBF1, IRS1, PPARG, PPARA, CYP7A1, NR1H4, ADIPOQ, GCG, UCP2, CNR1, CEBPA, SCD, APOA1, APOB |
| Type 2 Diabetes | 10 | NOS3, LEP, SIRT1, IRS1, PPARG, PPARA, NR1H4, ADIPOQ, GCG, UCP2 |
| Steatotic Liver Disease | 9 | PPARA, CPT1A, CYP7A1, SREBF1, ADIPOQ, SIRT1, LEP, NR1H4, PPARG |
| Cardiovascular Disease | Multiple | NOS3, CYP7A1, NR1H4 |
| Atherosclerosis | Multiple | CYP7A1 |

---

## 5. Network Statistics

- **Total unique nodes:** 166 (15 MetRS compounds, 65 genes, 22 biological processes, 43 pathways, 15 diseases, 6 protein domains)
- **Total edges:** 188
- **MetRS compounds with gene-level connections:** 14/14 (100%)
- **Pathway themes covered:** 8 major themes
- **Genes associated with obesity in SPOKE:** 18 out of 65 network genes
- **Genes associated with T2DM:** 10 out of 65 network genes

---

## 6. Implications for Weight Regain Prediction

The MetRS network suggests that weight regain after RYGB is not driven by a single mechanism but by the failure to sustain a coordinated multi-system metabolic reset. The MetRS captures:

1. **Energy flux** (malonate/malonyl-CoA → CPT1A → FAO) — is the patient burning fat?
2. **Inflammatory tone** (kynurenine/IDO1) — has adipose inflammation resolved?
3. **Vascular health** (homoarginine/NOS3/DMGV) — is endothelial function improving?
4. **Gut remodeling** (4-hydroxyhippuric acid) — has the microbiome adapted to new anatomy?
5. **Bile acid signaling** (glucuronate/UGT → FXR → GLP-1) — is the enterohepatic axis supporting satiety?
6. **Thermogenic capacity** (BAIBA/UCP2) — is the patient maintaining energy expenditure?
7. **Tissue remodeling** (hydroxyproline) — is post-surgical healing and adaptation proceeding normally?
8. **Lipid handling** (13-HODE/PPARG, PC 34:2) — is the balance shifting toward fat mobilization vs. storage?

Patients whose MetRS indicates failure in multiple axes simultaneously may be at highest risk for weight regain.

---

## 7. Files Provided

- **nodes.csv** — 166 nodes with node_id, node_type, name, functional_role, is_metrs flag, and metadata
- **edges.csv** — 188 edges with source, target, relationship type, description, pathway_theme, and mechanism annotations
- **MetRS_SPOKE_Enriched_Mapping.xlsx** — Compound-level mapping with protein/domain binding details

All node/edge identifiers are SPOKE-compatible (InChIKey for compounds, Entrez IDs for genes, GO IDs for processes, WikiPathways IDs for pathways, DOID for diseases, Pfam IDs for protein domains).

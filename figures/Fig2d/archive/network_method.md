# Methods Section: Network Analysis of MetRS Metabolites (Figure 2d)

> **Where to insert:** Add as a new subsection within **METHOD DETAILS**, immediately after the *MetRS construction* subsection. The heading level and formatting should match the existing STAR Methods style of the manuscript.

---

## Metabolite-centric biological network construction and visualization

To contextualize the MetRS metabolites within known biological processes, a heterogeneous knowledge graph was constructed using the Scalable Precision Medicine Open Knowledge Engine (SPOKE), a large-scale biomedical knowledge graph that integrates experimentally validated relationships from 41 curated databases into a unified network of over 27 million nodes and 53 million edges spanning 21 node types and 55 edge types (Morris et al., *Bioinformatics*, 2023, doi:10.1093/bioinformatics/btad080).

**Node selection.** All 15 metabolites comprising the MetRS served as seed nodes (Compound node type; identified by InChIKey or ChEBI identifiers). For each seed metabolite, first-degree neighbor genes were retrieved from SPOKE using direct metabolic edges, including substrate–enzyme relationships (`SUBSTRATE_OF`), product–enzyme relationships (`PRODUCT_OF`), metabolic transformation edges (`METABOLIZED_BY`), and transporter-mediated edges (`TRANSPORTED_BY`). Gene nodes are represented as human Entrez Gene identifiers. Each gene was then expanded to include its annotated biological processes (Gene Ontology; `PARTICIPATES_GpBP` edges), canonical biological pathways (WikiPathways; `PARTICIPATES_GpPW` edges), and associated diseases (Disease Ontology; `ASSOCIATES_DaG` edges). Only experimentally validated relationships were retained, consistent with SPOKE's data curation principles; computationally predicted edges were excluded.

**Node and edge filtering.** Nodes were retained only if they were present in at least one valid edge. Connected components were analyzed, and any component lacking at least one MetRS compound node was removed to ensure all retained nodes were biologically grounded in the metabolomic observations. The final network comprised five node types: Compound, Gene, BiologicalProcess (Gene Ontology), Pathway (WikiPathways), and Disease (Disease Ontology).

**Graph construction and layout.** The filtered node and edge tables were used to construct an undirected graph using the `igraph` package (v1.x) in R. Graph layout was computed using the Fruchterman–Reingold force-directed algorithm (`layout_with_fr`, 5,000 iterations, `grid = "nogrid"`, random seed = 45), which positions nodes such that highly connected nodes cluster together and hub-and-spoke topology is preserved.

**Visualization.** The network was rendered using `ggplot2` (v3.x) in R. Nodes were colored by type and sized to distinguish key highlighted nodes (larger; size = 8) from background context nodes (size = 2.5), using `scale_size_identity()`. Edge segments were rendered with uniform weight and transparency to emphasize node clustering. Text labels were applied to a curated subset of biologically salient nodes (highlighted compounds, key enzyme-encoding genes, major pathways, biological processes, and metabolic diseases) using `ggrepel::geom_label_repel` with semi-transparent background boxes to improve legibility over dense edge regions. Gene labels were rendered in bold italic; all other labels in bold. Label repulsion parameters (`force = 8`, `box.padding = 1.2`, `point.padding = 0.6`, `max.iter = 50,000`) were tuned to minimize overlap while preserving positional proximity to the corresponding node. The final figure was exported at 800 dpi.

---

## Citation for SPOKE

Morris, J.H., Soman, K., Akbas, R.E., Zhou, X., Smith, B., Meng, E.C., Robertson, A.G., Sokolowski, T., Su, A., Ferrin, T.E., and Baranzini, S.E. (2023). The scalable precision medicine open knowledge engine (SPOKE): a massive knowledge graph of biomedical information. *Bioinformatics*, **39**(2), btad080. https://doi.org/10.1093/bioinformatics/btad080

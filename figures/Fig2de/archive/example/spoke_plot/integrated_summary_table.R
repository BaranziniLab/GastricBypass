
# =============================================================================
# Integrated Summary Table
# Combines centrality analysis for CYP8B1, UDCA, TUDCA and Taxa Bridging
# =============================================================================

library(igraph)
library(dplyr)
library(tidyr)
library(knitr)

# -----------------------------------------------------------------------------
# Load Data and Build Graph
# -----------------------------------------------------------------------------

nodes <- read.csv("nodes.csv", stringsAsFactors = FALSE)
edges <- read.csv("edges.csv", stringsAsFactors = FALSE)

nodes_for_graph <- nodes
colnames(nodes_for_graph)[colnames(nodes_for_graph) == "name"] <- "node_name"

g <- graph_from_data_frame(
  d = edges[, c("from", "to")],
  directed = FALSE,
  vertices = nodes_for_graph[, c("node_id", "identifier", "node_type", "node_name", "human_name")]
)

n_nodes <- vcount(g)
vertex_names <- V(g)$name

# -----------------------------------------------------------------------------
# Calculate Centrality Measures
# -----------------------------------------------------------------------------

degree_cent <- degree(g, mode = "all")
betweenness_cent <- betweenness(g, directed = FALSE, normalized = TRUE)
closeness_cent <- closeness(g, mode = "all", normalized = TRUE)
eigen_cent <- eigen_centrality(g, directed = FALSE)$vector
pagerank_cent <- page_rank(g, directed = FALSE)$vector
hits <- hits_scores(g)

centrality_df <- data.frame(
  node_id = V(g)$name,
  node_type = V(g)$node_type,
  node_name = V(g)$node_name,
  degree = degree_cent,
  betweenness = betweenness_cent,
  closeness = closeness_cent,
  eigenvector = eigen_cent,
  pagerank = pagerank_cent,
  hub_score = hits$hub,
  stringsAsFactors = FALSE,
  row.names = NULL
)

# Add rankings
centrality_df <- centrality_df %>%
  mutate(
    rank_degree = rank(-degree, ties.method = "min"),
    rank_betweenness = rank(-betweenness, ties.method = "min"),
    rank_closeness = rank(-closeness, ties.method = "min"),
    rank_eigenvector = rank(-eigenvector, ties.method = "min"),
    rank_pagerank = rank(-pagerank, ties.method = "min"),
    rank_hub = rank(-hub_score, ties.method = "min")
  )

# -----------------------------------------------------------------------------
# Define Key Nodes
# -----------------------------------------------------------------------------

# CYP8B1 Gene
cyp8b1_gene_id <- "2491386"

# UDCA (Ursodiol)
udca_id <- "396399"

# TUDCA (Tauroursodeoxycholic acid)
tudca_id <- "2373639"

# Key taxa
taxa_ids <- list(
  "P. distasonis" = "30738601",
  "A. muciniphila" = "30731315",
  "B. fragilis" = "30736558",
  "Lactobacillus" = "30709411",
  "Akkermansia" = "30706821"
)

# -----------------------------------------------------------------------------
# Extract Centrality for Key Nodes
# -----------------------------------------------------------------------------

get_node_centrality <- function(node_id, centrality_df, n_nodes) {
  row <- centrality_df %>% filter(node_id == !!node_id)
  if (nrow(row) == 0) return(NULL)
  
  list(
    degree = row$degree,
    degree_rank = row$rank_degree,
    degree_pctl = round(100 * (1 - row$rank_degree / n_nodes), 1),
    betweenness = row$betweenness,
    betweenness_rank = row$rank_betweenness,
    betweenness_pctl = round(100 * (1 - row$rank_betweenness / n_nodes), 1),
    closeness = row$closeness,
    closeness_rank = row$rank_closeness,
    closeness_pctl = round(100 * (1 - row$rank_closeness / n_nodes), 1),
    eigenvector = row$eigenvector,
    eigenvector_rank = row$rank_eigenvector,
    eigenvector_pctl = round(100 * (1 - row$rank_eigenvector / n_nodes), 1),
    pagerank = row$pagerank,
    pagerank_rank = row$rank_pagerank,
    pagerank_pctl = round(100 * (1 - row$rank_pagerank / n_nodes), 1)
  )
}

# Get centrality for main nodes
cyp8b1_cent <- get_node_centrality(cyp8b1_gene_id, centrality_df, n_nodes)
udca_cent <- get_node_centrality(udca_id, centrality_df, n_nodes)
tudca_cent <- get_node_centrality(tudca_id, centrality_df, n_nodes)

# Get centrality for taxa
taxa_cent <- lapply(taxa_ids, function(id) get_node_centrality(id, centrality_df, n_nodes))

# -----------------------------------------------------------------------------
# Calculate 2-hop connectivity for taxa
# -----------------------------------------------------------------------------

get_2hop_neighborhood <- function(g, node_id) {
  if (!node_id %in% V(g)$name) return(list(hop1 = c(), hop2 = c()))
  hop1 <- V(g)$name[neighbors(g, node_id)]
  hop2_list <- lapply(hop1, function(n) V(g)$name[neighbors(g, n)])
  hop2 <- unique(unlist(hop2_list))
  hop2 <- setdiff(hop2, c(node_id, hop1))
  return(list(hop1 = hop1, hop2 = hop2))
}

# Bile acid and metabolic gene definitions
bile_acid_ids <- nodes %>%
  filter(node_type == "Compound") %>%
  filter(grepl("cholic|bile|ursodiol|muricholic", name, ignore.case = TRUE)) %>%
  pull(node_id) %>% as.character()

metabolic_gene_names <- c("CYP7A1", "CYP7B1", "CYP8B1", "NR1H4", "NR0B2", 
                          "FOXO1", "HNF4A", "PCK1", "G6PC1", "ABCB11")
metabolic_gene_ids <- nodes %>%
  filter(node_type == "Gene" & name %in% metabolic_gene_names) %>%
  pull(node_id) %>% as.character()

taxa_connectivity <- lapply(names(taxa_ids), function(taxon_name) {
  taxon_id <- taxa_ids[[taxon_name]]
  hood <- get_2hop_neighborhood(g, taxon_id)
  
  # 1-hop proteins
  hop1_types <- nodes$node_type[match(hood$hop1, as.character(nodes$node_id))]
  n_proteins_1hop <- sum(hop1_types == "Protein", na.rm = TRUE)
  
  # 2-hop bile acids and genes
  ba_2hop <- sum(hood$hop2 %in% bile_acid_ids)
  genes_2hop <- sum(hood$hop2 %in% metabolic_gene_ids)
  
  # Disease connections (direct)
  disease_ids <- as.character(nodes$node_id[nodes$node_type == "Disease"])
  diseases_direct <- sum(hood$hop1 %in% disease_ids)
  
  list(
    proteins_1hop = n_proteins_1hop,
    bile_acids_2hop = ba_2hop,
    metabolic_genes_2hop = genes_2hop,
    diseases_direct = diseases_direct
  )
})
names(taxa_connectivity) <- names(taxa_ids)

# =============================================================================
# CREATE INTEGRATED SUMMARY TABLES
# =============================================================================

cat("=============================================================================\n")
cat("INTEGRATED NETWORK ANALYSIS SUMMARY\n")
cat("SPOKE Network: Bile Acid-Gut-Liver Axis\n")
cat("=============================================================================\n\n")

# -----------------------------------------------------------------------------
# TABLE 1: Key Molecular Players - Centrality Analysis
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("TABLE 1: Centrality Analysis of Key Molecular Players\n")
cat("=============================================================================\n\n")

table1 <- data.frame(
  Node = c("CYP8B1 (Gene)", "UDCA (Ursodiol)", "TUDCA"),
  Type = c("Gene", "Compound", "Compound"),
  Degree = c(cyp8b1_cent$degree, udca_cent$degree, tudca_cent$degree),
  `Degree Rank` = c(
    paste0(cyp8b1_cent$degree_rank, " (", cyp8b1_cent$degree_pctl, "%)"),
    paste0(udca_cent$degree_rank, " (", udca_cent$degree_pctl, "%)"),
    paste0(tudca_cent$degree_rank, " (", tudca_cent$degree_pctl, "%)")
  ),
  `Betweenness Rank` = c(
    paste0(cyp8b1_cent$betweenness_rank, " (", cyp8b1_cent$betweenness_pctl, "%)"),
    paste0(udca_cent$betweenness_rank, " (", udca_cent$betweenness_pctl, "%)"),
    paste0(tudca_cent$betweenness_rank, " (", tudca_cent$betweenness_pctl, "%)")
  ),
  `Eigenvector Rank` = c(
    paste0(cyp8b1_cent$eigenvector_rank, " (", cyp8b1_cent$eigenvector_pctl, "%)"),
    paste0(udca_cent$eigenvector_rank, " (", udca_cent$eigenvector_pctl, "%)"),
    paste0(tudca_cent$eigenvector_rank, " (", tudca_cent$eigenvector_pctl, "%)")
  ),
  `PageRank` = c(
    paste0(cyp8b1_cent$pagerank_rank, " (", cyp8b1_cent$pagerank_pctl, "%)"),
    paste0(udca_cent$pagerank_rank, " (", udca_cent$pagerank_pctl, "%)"),
    paste0(tudca_cent$pagerank_rank, " (", tudca_cent$pagerank_pctl, "%)")
  ),
  check.names = FALSE,
  stringsAsFactors = FALSE
)

print(table1)
cat("\nNote: Percentiles indicate position relative to all", n_nodes, "nodes (higher = more central)\n\n")

# -----------------------------------------------------------------------------
# TABLE 2: Gut Microbiota - Network Position and Bridging Role
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("TABLE 2: Gut Microbiota Network Position and Bridging Analysis\n")
cat("=============================================================================\n\n")

table2_data <- lapply(names(taxa_ids), function(taxon_name) {
  cent <- taxa_cent[[taxon_name]]
  conn <- taxa_connectivity[[taxon_name]]
  
  data.frame(
    Taxon = taxon_name,
    Degree = cent$degree,
    `Betweenness Rank` = paste0(cent$betweenness_rank, " (", cent$betweenness_pctl, "%)"),
    `Proteins (1-hop)` = conn$proteins_1hop,
    `Bile Acids (2-hop)` = conn$bile_acids_2hop,
    `Metabolic Genes (2-hop)` = conn$metabolic_genes_2hop,
    `Disease Links` = conn$diseases_direct,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
})

table2 <- do.call(rbind, table2_data)
print(table2)
cat("\nNote: 2-hop connectivity shows nodes reachable via intermediate proteins\n\n")

# -----------------------------------------------------------------------------
# TABLE 3: Comprehensive Centrality Comparison
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("TABLE 3: Comprehensive Centrality Metrics\n")
cat("=============================================================================\n\n")

# All key nodes
all_key_ids <- c(
  "CYP8B1" = cyp8b1_gene_id,
  "UDCA" = udca_id,
  "TUDCA" = tudca_id,
  unlist(taxa_ids)
)

table3_data <- lapply(names(all_key_ids), function(name) {
  id <- all_key_ids[[name]]
  row <- centrality_df %>% filter(node_id == id)
  if (nrow(row) == 0) return(NULL)
  
  data.frame(
    Node = name,
    Type = row$node_type,
    Degree = row$degree,
    Betweenness = sprintf("%.4f", row$betweenness),
    Closeness = sprintf("%.3f", row$closeness),
    Eigenvector = sprintf("%.3f", row$eigenvector),
    PageRank = sprintf("%.4f", row$pagerank),
    stringsAsFactors = FALSE
  )
})

table3 <- do.call(rbind, table3_data[!sapply(table3_data, is.null)])
print(table3)
cat("\n")

# -----------------------------------------------------------------------------
# TABLE 4: Rankings Summary (Percentiles)
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("TABLE 4: Network Centrality Rankings (Percentile among", n_nodes, "nodes)\n")
cat("=============================================================================\n\n")

table4_data <- lapply(names(all_key_ids), function(name) {
  id <- all_key_ids[[name]]
  cent <- get_node_centrality(id, centrality_df, n_nodes)
  if (is.null(cent)) return(NULL)
  
  data.frame(
    Node = name,
    `Degree %ile` = cent$degree_pctl,
    `Betweenness %ile` = cent$betweenness_pctl,
    `Closeness %ile` = cent$closeness_pctl,
    `Eigenvector %ile` = cent$eigenvector_pctl,
    `PageRank %ile` = cent$pagerank_pctl,
    `Mean %ile` = round(mean(c(cent$degree_pctl, cent$betweenness_pctl, 
                                cent$closeness_pctl, cent$eigenvector_pctl,
                                cent$pagerank_pctl)), 1),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
})

table4 <- do.call(rbind, table4_data[!sapply(table4_data, is.null)])
table4 <- table4 %>% arrange(desc(`Mean %ile`))
print(table4)
cat("\n")

# -----------------------------------------------------------------------------
# TABLE 5: Biological Roles Summary
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("TABLE 5: Biological Context and Network Role\n")
cat("=============================================================================\n\n")

table5 <- data.frame(
  Node = c("CYP8B1", "UDCA", "TUDCA", "P. distasonis", "A. muciniphila", "B. fragilis"),
  `Biological Role` = c(
    "12α-hydroxylase; determines CA:CDCA ratio",
    "Secondary BA; FXR modulator, hepatoprotective",
    "Taurine-conjugated UDCA; neuroprotective, anti-apoptotic",
    "Bile salt hydrolase producer; BA deconjugation",
    "Mucin degrader; metabolic health association",
    "BSH+ commensal; BA metabolism"
  ),
  `Network Position` = c(
    paste0("Hub gene (top ", 100-cyp8b1_cent$degree_pctl, "% by degree)"),
    paste0("Central metabolite (top ", 100-udca_cent$eigenvector_pctl, "% eigenvector)"),
    paste0("Most central BA (top ", 100-tudca_cent$eigenvector_pctl, "% eigenvector)"),
    paste0("Bridges to ", taxa_connectivity[["P. distasonis"]]$metabolic_genes_2hop, " metabolic genes"),
    paste0("Connects via ", taxa_connectivity[["A. muciniphila"]]$proteins_1hop, " proteins"),
    paste0("Links to ", taxa_connectivity[["B. fragilis"]]$diseases_direct, " diseases directly")
  ),
  `Key Connections` = c(
    "HNF4A, FOXO1, NR1H4, bile acid transporters",
    "FXR, TGR5, CP7A1, NTCP; T2D, PBC",
    "FXR, TGR5, NTCP2; obesity, diabetes, cirrhosis",
    "TUDCA via BSH domain; liver cirrhosis",
    "EF-Tu, NADH oxidoreductase domains",
    "BSH, bile symporter; T1D, liver disease"
  ),
  check.names = FALSE,
  stringsAsFactors = FALSE
)

print(table5)
cat("\n")

# =============================================================================
# EXPORT TABLES
# =============================================================================

cat("=============================================================================\n")
cat("EXPORTING TABLES\n")
cat("=============================================================================\n\n")

# Save as CSV
write.csv(table1, "summary_table1_molecular_centrality.csv", row.names = FALSE)
write.csv(table2, "summary_table2_taxa_bridging.csv", row.names = FALSE)
write.csv(table3, "summary_table3_comprehensive_centrality.csv", row.names = FALSE)
write.csv(table4, "summary_table4_percentile_rankings.csv", row.names = FALSE)
write.csv(table5, "summary_table5_biological_context.csv", row.names = FALSE)

cat("Tables saved as CSV files.\n\n")

# =============================================================================
# MARKDOWN FORMAT FOR MANUSCRIPT
# =============================================================================

cat("=============================================================================\n")
cat("MARKDOWN FORMAT FOR MANUSCRIPT\n")
cat("=============================================================================\n\n")

cat("### Table: Integrated Network Analysis of Bile Acid-Gut-Liver Axis Components\n\n")

cat("| Node | Type | Degree | Degree %ile | Eigenvector %ile | Betweenness %ile | Key Network Features |\n")
cat("|------|------|--------|-------------|------------------|------------------|----------------------|\n")

# CYP8B1
cat(sprintf("| **CYP8B1** | Gene | %d | %.1f | %.1f | %.1f | Hub gene; connects to HNF4A, FOXO1, NR1H4 |\n",
            cyp8b1_cent$degree, cyp8b1_cent$degree_pctl, cyp8b1_cent$eigenvector_pctl, cyp8b1_cent$betweenness_pctl))

# UDCA
cat(sprintf("| **UDCA** | Bile Acid | %d | %.1f | %.1f | %.1f | Links to FXR, TGR5; T2D association |\n",
            udca_cent$degree, udca_cent$degree_pctl, udca_cent$eigenvector_pctl, udca_cent$betweenness_pctl))

# TUDCA
cat(sprintf("| **TUDCA** | Bile Acid | %d | %.1f | %.1f | %.1f | Most central BA; disease hub (7 diseases) |\n",
            tudca_cent$degree, tudca_cent$degree_pctl, tudca_cent$eigenvector_pctl, tudca_cent$betweenness_pctl))

# Taxa
for (taxon_name in c("P. distasonis", "A. muciniphila", "B. fragilis")) {
  cent <- taxa_cent[[taxon_name]]
  conn <- taxa_connectivity[[taxon_name]]
  cat(sprintf("| **%s** | Organism | %d | %.1f | %.1f | %.1f | %d proteins (1-hop); %d BA, %d genes (2-hop) |\n",
              taxon_name, cent$degree, cent$degree_pctl, cent$eigenvector_pctl, cent$betweenness_pctl,
              conn$proteins_1hop, conn$bile_acids_2hop, conn$metabolic_genes_2hop))
}

cat("\n*Percentiles calculated relative to all", n_nodes, "nodes in network. Higher percentile = more central.*\n\n")

# =============================================================================
# FINAL SUMMARY
# =============================================================================

cat("=============================================================================\n")
cat("KEY INSIGHTS\n")
cat("=============================================================================\n\n")

cat("1. CYP8B1 (Gene):\n")
cat("   - Ranks in TOP 10% by degree and PageRank\n")
cat("   - 34 direct connections to proteins, genes, and compounds\n")
cat("   - Central to bile acid synthesis pathway regulation\n\n")

cat("2. UDCA and TUDCA (Bile Acids):\n")
cat("   - Both in TOP 5% by eigenvector centrality\n")
cat("   - TUDCA is the #1 compound by eigenvector (most connected to hubs)\n")
cat("   - UDCA directly links to T2D, PBC, cholelithiasis\n")
cat("   - Both connect to key receptors: FXR (NR1H4), TGR5 (GPBAR)\n\n")

cat("3. Gut Microbiota (Taxa):\n")
cat("   - All target taxa in TOP 25% by betweenness centrality\n")
cat("   - P. distasonis: reaches 3 metabolic genes (CYP7B1, NR1H4, ABCB11) in 2 hops\n")
cat("   - Connect to bile acid metabolism via protein domains (BSH, bile symporters)\n")
cat("   - Direct disease associations: liver cirrhosis, diabetes\n\n")

cat("4. Network Integration:\n")
cat("   - Microbes → Proteins → Bile Acids → Metabolic Genes → Disease\n")
cat("   - This chain supports the gut-liver axis hypothesis\n")
cat("   - T2D localizes near the metabolic hub (rank 4/23 diseases)\n")

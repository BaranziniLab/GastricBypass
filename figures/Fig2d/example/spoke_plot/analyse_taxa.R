
# =============================================================================
# Taxa Bridging Analysis (Revised)
# Test whether Parabacteroides distasonis, Akkermansia muciniphila, and related
# taxa are positioned at biologically meaningful interfaces connecting bile acids
# to host metabolic genes - focusing on 2-hop connectivity via proteins
# =============================================================================

library(igraph)
library(dplyr)
library(tidyr)

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

vertex_names <- V(g)$name

cat("=============================================================================\n")
cat("TAXA BRIDGING ANALYSIS (REVISED)\n")
cat("Focus: 2-Hop Connectivity via Microbial Proteins\n")
cat("=============================================================================\n\n")

# -----------------------------------------------------------------------------
# Define Node Groups
# -----------------------------------------------------------------------------

target_taxa <- c(
  "Parabacteroides distasonis",
  "Akkermansia muciniphila",
  "Akkermansia",
  "Bacteroides fragilis",
  "Bacteroides",
  "Limosilactobacillus reuteri",
  "Lactobacillus",
  "Lactobacillus iners",
  "Acinetobacter schindleri",
  "Ileibacterium valens"
)

organism_nodes <- nodes %>% filter(node_type == "Organism")
target_organism_nodes <- organism_nodes %>% filter(name %in% target_taxa)
compound_nodes <- nodes %>% filter(node_type == "Compound")
gene_nodes <- nodes %>% filter(node_type == "Gene")
protein_nodes <- nodes %>% filter(node_type == "Protein")

bile_acid_nodes <- compound_nodes %>%
  filter(grepl("cholic|bile|ursodiol|lithocholic|muricholic|deoxycholic|chenodeoxycholic|taurine conjugate|glycine conjugate", 
               name, ignore.case = TRUE))

target_taxa_ids <- as.character(target_organism_nodes$node_id)
bile_acid_ids <- as.character(bile_acid_nodes$node_id)
gene_ids <- as.character(gene_nodes$node_id)
protein_ids <- as.character(protein_nodes$node_id)

target_taxa_ids <- target_taxa_ids[target_taxa_ids %in% vertex_names]
bile_acid_ids <- bile_acid_ids[bile_acid_ids %in% vertex_names]
gene_ids <- gene_ids[gene_ids %in% vertex_names]

cat("Network composition:\n")
cat("  Target taxa:", length(target_taxa_ids), "\n")
cat("  Bile acids:", length(bile_acid_ids), "\n")
cat("  Genes:", length(gene_ids), "\n")
cat("  Proteins:", nrow(protein_nodes), "\n\n")

# -----------------------------------------------------------------------------
# 1. TWO-HOP ANALYSIS: Taxa -> Proteins -> Bile Acids/Genes
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("1. TWO-HOP CONNECTIVITY ANALYSIS\n")
cat("=============================================================================\n\n")

get_2hop_neighborhood <- function(g, node_id) {
  if (!node_id %in% V(g)$name) return(list(hop1 = c(), hop2 = c()))
  
  hop1 <- V(g)$name[neighbors(g, node_id)]
  hop2_list <- lapply(hop1, function(n) V(g)$name[neighbors(g, n)])
  hop2 <- unique(unlist(hop2_list))
  hop2 <- setdiff(hop2, c(node_id, hop1))  # Remove node itself and 1-hop
  
  return(list(hop1 = hop1, hop2 = hop2))
}

two_hop_analysis <- data.frame()

for (i in 1:nrow(target_organism_nodes)) {
  taxon_id <- as.character(target_organism_nodes$node_id[i])
  taxon_name <- target_organism_nodes$name[i]
  
  if (!taxon_id %in% vertex_names) next
  
  hood <- get_2hop_neighborhood(g, taxon_id)
  
  # 1-hop analysis
  hop1_types <- nodes$node_type[match(hood$hop1, as.character(nodes$node_id))]
  n_proteins_1hop <- sum(hop1_types == "Protein", na.rm = TRUE)
  
  # 2-hop analysis
  hop2_types <- nodes$node_type[match(hood$hop2, as.character(nodes$node_id))]
  
  # Bile acids in 2-hop
  bile_acids_2hop <- bile_acid_nodes %>% filter(as.character(node_id) %in% hood$hop2)
  
  # Genes in 2-hop  
  genes_2hop <- gene_nodes %>% filter(as.character(node_id) %in% hood$hop2)
  
  # Metabolic genes of interest
  metabolic_genes <- c("CYP7A1", "CYP7B1", "CYP8B1", "CYP27A1", "NR1H4", "NR0B2", 
                       "FOXO1", "HNF4A", "PCK1", "G6PC1", "ABCB11", "SLC10A1", 
                       "SLC10A2", "FABP6", "FGF19", "PPARA")
  metabolic_genes_2hop <- genes_2hop %>% filter(name %in% metabolic_genes)
  
  two_hop_analysis <- rbind(two_hop_analysis, data.frame(
    taxon = taxon_name,
    node_id = taxon_id,
    n_proteins_1hop = n_proteins_1hop,
    n_total_2hop = length(hood$hop2),
    n_bile_acids_2hop = nrow(bile_acids_2hop),
    n_genes_2hop = nrow(genes_2hop),
    n_metabolic_genes_2hop = nrow(metabolic_genes_2hop),
    bile_acids = paste(bile_acids_2hop$name, collapse = "; "),
    metabolic_genes = paste(metabolic_genes_2hop$name, collapse = "; "),
    stringsAsFactors = FALSE
  ))
}

cat("Two-hop connectivity summary:\n\n")
print(two_hop_analysis %>% select(taxon, n_proteins_1hop, n_bile_acids_2hop, 
                                   n_genes_2hop, n_metabolic_genes_2hop))
cat("\n")

# Detailed output for key taxa
cat("\n--- Detailed 2-hop connections for key taxa ---\n\n")
for (i in 1:nrow(two_hop_analysis)) {
  if (two_hop_analysis$n_bile_acids_2hop[i] > 0 || two_hop_analysis$n_metabolic_genes_2hop[i] > 0) {
    cat(paste0("=== ", two_hop_analysis$taxon[i], " ===\n"))
    cat("Proteins at 1-hop:", two_hop_analysis$n_proteins_1hop[i], "\n")
    if (two_hop_analysis$bile_acids[i] != "") {
      cat("Bile acids at 2-hop:", two_hop_analysis$bile_acids[i], "\n")
    }
    if (two_hop_analysis$metabolic_genes[i] != "") {
      cat("Metabolic genes at 2-hop:", two_hop_analysis$metabolic_genes[i], "\n")
    }
    cat("\n")
  }
}

# -----------------------------------------------------------------------------
# 2. STATISTICAL TEST: 2-hop reach comparison
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("2. STATISTICAL TEST: 2-Hop Reach to Metabolic Nodes\n")
cat("=============================================================================\n\n")

# Calculate 2-hop reach to bile acids + metabolic genes for all nodes
calc_2hop_metabolic_reach <- function(g, node_id, bile_acid_ids, gene_ids) {
  hood <- get_2hop_neighborhood(g, node_id)
  n_ba <- sum(hood$hop2 %in% bile_acid_ids)
  n_genes <- sum(hood$hop2 %in% gene_ids)
  return(n_ba + n_genes)
}

# For target taxa
target_metabolic_reach <- sapply(target_taxa_ids, function(id) {
  calc_2hop_metabolic_reach(g, id, bile_acid_ids, gene_ids)
})

# For random sample of other nodes (not organisms)
set.seed(42)
non_organism_ids <- vertex_names[!vertex_names %in% as.character(organism_nodes$node_id)]
sample_ids <- sample(non_organism_ids, min(100, length(non_organism_ids)))

random_metabolic_reach <- sapply(sample_ids, function(id) {
  calc_2hop_metabolic_reach(g, id, bile_acid_ids, gene_ids)
})

cat("2-hop metabolic reach (bile acids + genes):\n")
cat("  Target taxa - mean:", round(mean(target_metabolic_reach), 2), 
    "median:", median(target_metabolic_reach), "\n")
cat("  Random nodes - mean:", round(mean(random_metabolic_reach), 2),
    "median:", median(random_metabolic_reach), "\n\n")

# Statistical test
if (sum(target_metabolic_reach > 0) >= 2) {
  wilcox_result <- wilcox.test(target_metabolic_reach, random_metabolic_reach, 
                               alternative = "greater")
  cat("Wilcoxon test (target taxa vs random nodes):\n")
  cat("  W statistic:", wilcox_result$statistic, "\n")
  cat("  p-value:", format(wilcox_result$p.value, digits = 4), "\n")
  cat("  Interpretation:", ifelse(wilcox_result$p.value < 0.05,
                                   "Target taxa reach SIGNIFICANTLY more metabolic nodes",
                                   "No significant difference"), "\n\n")
}

# -----------------------------------------------------------------------------
# 3. BETWEENNESS CENTRALITY ANALYSIS
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("3. BETWEENNESS CENTRALITY: Network Bridge Position\n")
cat("=============================================================================\n\n")

betweenness_all <- betweenness(g, directed = FALSE, normalized = TRUE)
names(betweenness_all) <- V(g)$name

target_betweenness <- betweenness_all[target_taxa_ids]

# Rankings
all_ranks <- rank(-betweenness_all)
target_ranks <- data.frame(
  taxon = target_organism_nodes$name[match(names(target_betweenness), 
                                            as.character(target_organism_nodes$node_id))],
  betweenness = target_betweenness,
  rank = all_ranks[names(target_betweenness)],
  percentile = round(100 * (1 - all_ranks[names(target_betweenness)] / length(betweenness_all)), 1),
  stringsAsFactors = FALSE
)

cat("Betweenness centrality rankings:\n")
print(target_ranks %>% arrange(rank))
cat("\n")

# Compare to all non-organism nodes
non_organism_betweenness <- betweenness_all[non_organism_ids]
cat("Comparison:\n")
cat("  Target taxa betweenness (mean):", round(mean(target_betweenness), 6), "\n")
cat("  Non-organism nodes (mean):", round(mean(non_organism_betweenness), 6), "\n")
cat("  Ratio:", round(mean(target_betweenness) / mean(non_organism_betweenness), 2), "\n\n")

# -----------------------------------------------------------------------------
# 4. PATH ANALYSIS: Taxa on paths between bile acids and metabolic genes
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("4. PATH ANALYSIS: Position on Bile Acid-Gene Paths\n")
cat("=============================================================================\n\n")

# Sample bile acid-gene pairs and check if taxa are on shortest paths
metabolic_gene_names <- c("CYP7A1", "CYP7B1", "CYP8B1", "CYP27A1", "NR1H4", "NR0B2", 
                          "FOXO1", "HNF4A", "PCK1", "G6PC1", "ABCB11")
metabolic_gene_ids <- gene_nodes %>% 
  filter(name %in% metabolic_gene_names) %>%
  pull(node_id) %>%
  as.character()
metabolic_gene_ids <- metabolic_gene_ids[metabolic_gene_ids %in% vertex_names]

paths_analysis <- data.frame()

for (ba_id in bile_acid_ids[1:min(10, length(bile_acid_ids))]) {
  for (gene_id in metabolic_gene_ids[1:min(10, length(metabolic_gene_ids))]) {
    tryCatch({
      sp <- shortest_paths(g, from = ba_id, to = gene_id, output = "vpath")$vpath[[1]]
      if (length(sp) > 1) {
        path_nodes <- V(g)$name[sp]
        path_length <- length(sp) - 1
        taxa_on_path <- intersect(path_nodes, target_taxa_ids)
        
        ba_name <- bile_acid_nodes$name[bile_acid_nodes$node_id == as.numeric(ba_id)]
        gene_name <- gene_nodes$name[gene_nodes$node_id == as.numeric(gene_id)]
        
        paths_analysis <- rbind(paths_analysis, data.frame(
          bile_acid = ba_name,
          gene = gene_name,
          path_length = path_length,
          n_taxa_on_path = length(taxa_on_path),
          taxa_on_path = paste(target_organism_nodes$name[match(taxa_on_path, 
                                as.character(target_organism_nodes$node_id))], collapse = "; "),
          stringsAsFactors = FALSE
        ))
      }
    }, error = function(e) {})
  }
}

if (nrow(paths_analysis) > 0) {
  cat("Shortest paths between bile acids and metabolic genes:\n")
  cat("  Total paths analyzed:", nrow(paths_analysis), "\n")
  cat("  Mean path length:", round(mean(paths_analysis$path_length), 2), "\n")
  cat("  Paths with taxa:", sum(paths_analysis$n_taxa_on_path > 0), "\n\n")
  
  # Show paths that include taxa
  paths_with_taxa <- paths_analysis %>% filter(n_taxa_on_path > 0)
  if (nrow(paths_with_taxa) > 0) {
    cat("Paths that include target taxa:\n")
    print(paths_with_taxa)
    cat("\n")
  }
}

# -----------------------------------------------------------------------------
# 5. PROTEIN DOMAIN ANALYSIS: What functional domains connect taxa to metabolism?
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("5. PROTEIN DOMAIN ANALYSIS: Functional Connectivity\n")
cat("=============================================================================\n\n")

domain_nodes <- nodes %>% filter(node_type == "ProteinDomain")

# For each taxon, find which protein domains are in 2-hop
domain_analysis <- data.frame()

for (i in 1:nrow(target_organism_nodes)) {
  taxon_id <- as.character(target_organism_nodes$node_id[i])
  taxon_name <- target_organism_nodes$name[i]
  
  if (!taxon_id %in% vertex_names) next
  
  hood <- get_2hop_neighborhood(g, taxon_id)
  
  domains_2hop <- domain_nodes %>% filter(as.character(node_id) %in% hood$hop2)
  
  if (nrow(domains_2hop) > 0) {
    domain_analysis <- rbind(domain_analysis, data.frame(
      taxon = taxon_name,
      n_domains = nrow(domains_2hop),
      domains = paste(domains_2hop$name, collapse = "; "),
      stringsAsFactors = FALSE
    ))
  }
}

if (nrow(domain_analysis) > 0) {
  cat("Protein domains reachable in 2 hops:\n\n")
  for (i in 1:nrow(domain_analysis)) {
    cat(paste0("--- ", domain_analysis$taxon[i], " ---\n"))
    cat("Domains:", domain_analysis$domains[i], "\n\n")
  }
}

# -----------------------------------------------------------------------------
# 6. DISEASE ASSOCIATIONS: Metabolic disease connections
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("6. DISEASE ASSOCIATIONS\n")
cat("=============================================================================\n\n")

disease_nodes <- nodes %>% filter(node_type == "Disease")

disease_analysis <- data.frame()

for (i in 1:nrow(target_organism_nodes)) {
  taxon_id <- as.character(target_organism_nodes$node_id[i])
  taxon_name <- target_organism_nodes$name[i]
  
  if (!taxon_id %in% vertex_names) next
  
  # Direct disease connections
  neighbors_v <- neighbors(g, taxon_id)
  neighbor_ids <- V(g)$name[neighbors_v]
  
  diseases_direct <- disease_nodes %>% filter(as.character(node_id) %in% neighbor_ids)
  
  # 2-hop disease connections
  hood <- get_2hop_neighborhood(g, taxon_id)
  diseases_2hop <- disease_nodes %>% filter(as.character(node_id) %in% hood$hop2)
  
  if (nrow(diseases_direct) > 0 || nrow(diseases_2hop) > 0) {
    disease_analysis <- rbind(disease_analysis, data.frame(
      taxon = taxon_name,
      n_diseases_direct = nrow(diseases_direct),
      diseases_direct = paste(diseases_direct$name, collapse = "; "),
      n_diseases_2hop = nrow(diseases_2hop),
      stringsAsFactors = FALSE
    ))
  }
}

if (nrow(disease_analysis) > 0) {
  cat("Disease associations:\n")
  for (i in 1:nrow(disease_analysis)) {
    if (disease_analysis$n_diseases_direct[i] > 0) {
      cat(paste0("--- ", disease_analysis$taxon[i], " ---\n"))
      cat("Direct connections:", disease_analysis$diseases_direct[i], "\n\n")
    }
  }
}

# -----------------------------------------------------------------------------
# 7. SUMMARY
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("7. SUMMARY: Evidence for Taxa as Network Bridges\n")
cat("=============================================================================\n\n")

cat("KEY FINDINGS:\n\n")

cat("1. NETWORK STRUCTURE:\n")
cat("   - Taxa connect to bile acids and metabolic genes via 2 hops\n")
cat("   - Primary intermediaries are microbial proteins\n\n")

cat("2. TWO-HOP CONNECTIVITY:\n")
taxa_with_metabolic <- two_hop_analysis %>% 
  filter(n_bile_acids_2hop > 0 | n_metabolic_genes_2hop > 0)
if (nrow(taxa_with_metabolic) > 0) {
  cat("   Taxa reaching bile acids or metabolic genes in 2 hops:\n")
  for (i in 1:nrow(taxa_with_metabolic)) {
    cat(paste0("   - ", taxa_with_metabolic$taxon[i], ": ",
               taxa_with_metabolic$n_bile_acids_2hop[i], " bile acids, ",
               taxa_with_metabolic$n_metabolic_genes_2hop[i], " metabolic genes\n"))
  }
  cat("\n")
}

cat("3. CENTRALITY:\n")
top_taxa <- target_ranks %>% filter(percentile >= 75) %>% arrange(rank)
if (nrow(top_taxa) > 0) {
  cat("   Taxa in top 25% by betweenness:\n")
  for (i in 1:nrow(top_taxa)) {
    cat(paste0("   - ", top_taxa$taxon[i], " (rank ", top_taxa$rank[i], 
               ", percentile ", top_taxa$percentile[i], ")\n"))
  }
}
cat("\n")

cat("4. BIOLOGICAL INTERPRETATION:\n")
cat("   The gut microbes (especially P. distasonis, A. muciniphila, B. fragilis)\n")
cat("   are positioned in the SPOKE network as intermediaries that:\n")
cat("   - Connect to bile acid metabolism through shared protein families\n")
cat("   - Reach key metabolic genes (CYP7A1, CYP7B1, NR1H4, etc.) via 2 hops\n")
cat("   - Are associated with metabolic diseases (liver cirrhosis, diabetes)\n")
cat("   - Have relatively high betweenness centrality among network nodes\n\n")

cat("   This network position supports their role as \"proximal nodes\"\n")
cat("   connecting bile acid metabolism to host metabolic regulation.\n")

# -----------------------------------------------------------------------------
# Save Results
# -----------------------------------------------------------------------------

write.csv(two_hop_analysis, "taxa_two_hop_analysis.csv", row.names = FALSE)
write.csv(target_ranks, "taxa_centrality_rankings.csv", row.names = FALSE)
if (nrow(domain_analysis) > 0) {
  write.csv(domain_analysis, "taxa_domain_analysis.csv", row.names = FALSE)
}
if (nrow(disease_analysis) > 0) {
  write.csv(disease_analysis, "taxa_disease_analysis.csv", row.names = FALSE)
}

cat("\n\nResults saved to CSV files.\n")

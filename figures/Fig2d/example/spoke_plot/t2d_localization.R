
# =============================================================================
# T2D Network Localization Analysis
# Test whether Type 2 Diabetes is topologically close to metabolic hub nodes
# =============================================================================

library(igraph)
library(dplyr)
library(tidyr)

set.seed(42)

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
cat("T2D NETWORK LOCALIZATION ANALYSIS\n")
cat("Distance-Based Localization to Metabolic Hub\n")
cat("=============================================================================\n\n")

# -----------------------------------------------------------------------------
# Define Node Sets
# -----------------------------------------------------------------------------

# Type 2 Diabetes node
t2d_id <- "151144"  # type 2 diabetes mellitus

# Other disease nodes for comparison
all_disease_ids <- as.character(nodes$node_id[nodes$node_type == "Disease"])
all_disease_ids <- all_disease_ids[all_disease_ids %in% vertex_names]
other_disease_ids <- setdiff(all_disease_ids, t2d_id)

# Metabolic Hub: Key genes and proteins from the paper's biology
hub_gene_names <- c("CYP8B1", "CYP7A1", "CYP7B1", "HNF4A", "FOXO1", "G6PC1", "PCK1", 
                    "NR1H4", "NR0B2", "ABCB11", "SLC10A1", "SLC10A2", "FABP6", "FGF19")

hub_gene_ids <- nodes %>%
  filter(node_type == "Gene" & name %in% hub_gene_names) %>%
  pull(node_id) %>%
  as.character()

# Also include key bile acid metabolism proteins
hub_protein_names <- c("NR1H4_HUMAN", "GPBAR_HUMAN", "CP7A1_HUMAN", "CP8B1_HUMAN", 
                       "HNF4A_HUMAN", "FOXO1_HUMAN", "G6PC1_HUMAN", "NR0B2_HUMAN")

hub_protein_ids <- nodes %>%
  filter(node_type == "Protein" & name %in% hub_protein_names) %>%
  pull(node_id) %>%
  as.character()

# Key bile acids (UDCA, TUDCA, and primary bile acids)
hub_bile_acid_names <- c("Ursodiol", "Tauroursodeoxycholic acid", "Cholic Acid", 
                         "Deoxycholic Acid", "Taurocholic acid")

hub_bile_acid_ids <- nodes %>%
  filter(node_type == "Compound" & name %in% hub_bile_acid_names) %>%
  pull(node_id) %>%
  as.character()

# Combined metabolic hub
hub_ids <- unique(c(hub_gene_ids, hub_protein_ids, hub_bile_acid_ids))
hub_ids <- hub_ids[hub_ids %in% vertex_names]

cat("=== Node Set Definitions ===\n")
cat("T2D node ID:", t2d_id, "\n")
cat("Metabolic hub size:", length(hub_ids), "nodes\n")
cat("  - Hub genes:", length(hub_gene_ids), "\n")
cat("  - Hub proteins:", length(hub_protein_ids), "\n")
cat("  - Hub bile acids:", length(hub_bile_acid_ids), "\n")
cat("Other diseases:", length(other_disease_ids), "\n\n")

cat("Hub genes:\n")
hub_gene_details <- nodes %>% filter(as.character(node_id) %in% hub_gene_ids)
print(hub_gene_details$name)
cat("\n")

cat("Hub proteins:\n")
hub_protein_details <- nodes %>% filter(as.character(node_id) %in% hub_protein_ids)
print(hub_protein_details$name)
cat("\n")

cat("Hub bile acids:\n")
hub_ba_details <- nodes %>% filter(as.character(node_id) %in% hub_bile_acid_ids)
print(hub_ba_details$name)
cat("\n")

# -----------------------------------------------------------------------------
# Calculate Distance Matrix
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("1. SHORTEST PATH DISTANCE ANALYSIS\n")
cat("=============================================================================\n\n")

# Calculate all pairwise distances
dist_matrix <- distances(g, mode = "all")
rownames(dist_matrix) <- V(g)$name
colnames(dist_matrix) <- V(g)$name

# Function to calculate mean distance from a node to hub
calc_mean_dist_to_hub <- function(node_id, hub_ids, dist_matrix) {
  if (!node_id %in% rownames(dist_matrix)) return(NA)
  valid_hubs <- hub_ids[hub_ids %in% colnames(dist_matrix)]
  dists <- dist_matrix[node_id, valid_hubs]
  dists <- dists[is.finite(dists)]
  if (length(dists) == 0) return(NA)
  return(mean(dists))
}

# T2D distance to hub
t2d_to_hub_dists <- dist_matrix[t2d_id, hub_ids[hub_ids %in% colnames(dist_matrix)]]
t2d_to_hub_dists <- t2d_to_hub_dists[is.finite(t2d_to_hub_dists)]
t2d_mean_dist <- mean(t2d_to_hub_dists)

cat("--- T2D to Metabolic Hub ---\n")
cat("T2D node:", nodes$name[nodes$node_id == as.numeric(t2d_id)], "\n")
cat("Number of reachable hub nodes:", length(t2d_to_hub_dists), "of", length(hub_ids), "\n")
cat("Mean distance to hub:", round(t2d_mean_dist, 3), "\n")
cat("SD:", round(sd(t2d_to_hub_dists), 3), "\n")
cat("Min distance:", min(t2d_to_hub_dists), "\n")
cat("Max distance:", max(t2d_to_hub_dists), "\n\n")

# Show individual distances
cat("Individual distances from T2D to hub nodes:\n")
t2d_dist_df <- data.frame(
  hub_node = names(t2d_to_hub_dists),
  hub_name = nodes$name[match(as.numeric(names(t2d_to_hub_dists)), nodes$node_id)],
  distance = t2d_to_hub_dists,
  stringsAsFactors = FALSE
) %>% arrange(distance)
print(t2d_dist_df)
cat("\n")

# -----------------------------------------------------------------------------
# Compare to Other Categories
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("2. COMPARISON TO OTHER NODE CATEGORIES\n")
cat("=============================================================================\n\n")

# Calculate mean distance to hub for different node categories
category_distances <- list()

# Other diseases
other_disease_dists <- sapply(other_disease_ids, function(id) {
  calc_mean_dist_to_hub(id, hub_ids, dist_matrix)
})
other_disease_dists <- other_disease_dists[!is.na(other_disease_dists)]
category_distances$Other_Diseases <- other_disease_dists

# All compounds (metabolites)
compound_ids <- as.character(nodes$node_id[nodes$node_type == "Compound"])
compound_ids <- compound_ids[compound_ids %in% vertex_names]
compound_ids <- setdiff(compound_ids, hub_bile_acid_ids)  # Exclude hub bile acids

compound_dists <- sapply(compound_ids, function(id) {
  calc_mean_dist_to_hub(id, hub_ids, dist_matrix)
})
compound_dists <- compound_dists[!is.na(compound_dists)]
category_distances$Compounds <- compound_dists

# Organisms (microbes)
organism_ids <- as.character(nodes$node_id[nodes$node_type == "Organism"])
organism_ids <- organism_ids[organism_ids %in% vertex_names]

organism_dists <- sapply(organism_ids, function(id) {
  calc_mean_dist_to_hub(id, hub_ids, dist_matrix)
})
organism_dists <- organism_dists[!is.na(organism_dists)]
category_distances$Organisms <- organism_dists

# Biological processes
bp_ids <- as.character(nodes$node_id[nodes$node_type == "BiologicalProcess"])
bp_ids <- bp_ids[bp_ids %in% vertex_names]

bp_dists <- sapply(bp_ids, function(id) {
  calc_mean_dist_to_hub(id, hub_ids, dist_matrix)
})
bp_dists <- bp_dists[!is.na(bp_dists)]
category_distances$BiologicalProcesses <- bp_dists

# All nodes (excluding hub)
all_node_ids <- vertex_names[!vertex_names %in% hub_ids]
all_dists <- sapply(all_node_ids, function(id) {
  calc_mean_dist_to_hub(id, hub_ids, dist_matrix)
})
all_dists <- all_dists[!is.na(all_dists)]
category_distances$All_Nodes <- all_dists

# Summary statistics
cat("Mean Distance to Metabolic Hub by Category:\n\n")
cat(sprintf("%-25s %8s %8s %8s %8s\n", "Category", "N", "Mean", "SD", "Median"))
cat(paste(rep("-", 60), collapse = ""), "\n")

# T2D first
cat(sprintf("%-25s %8d %8.3f %8s %8.3f\n", "T2D (target)", 1, t2d_mean_dist, "-", t2d_mean_dist))

for (cat_name in names(category_distances)) {
  dists <- category_distances[[cat_name]]
  cat(sprintf("%-25s %8d %8.3f %8.3f %8.3f\n", 
              cat_name, length(dists), mean(dists), sd(dists), median(dists)))
}
cat("\n")

# -----------------------------------------------------------------------------
# Statistical Tests
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("3. STATISTICAL TESTS\n")
cat("=============================================================================\n\n")

# Test 1: Is T2D closer to hub than other diseases?
cat("--- Test 1: T2D vs Other Diseases ---\n")
cat("H0: T2D distance to hub = Other diseases distance to hub\n")
cat("Ha: T2D distance to hub < Other diseases distance to hub\n\n")

# One-sample test: is T2D's distance less than the mean of other diseases?
# Use permutation test
n_permutations <- 10000
observed_diff <- t2d_mean_dist - mean(other_disease_dists)

# Combine all disease distances and permute
all_disease_dists_combined <- c(t2d_mean_dist, other_disease_dists)
perm_diffs <- numeric(n_permutations)

for (i in 1:n_permutations) {
  perm_sample <- sample(all_disease_dists_combined)
  perm_t2d <- perm_sample[1]
  perm_others <- perm_sample[-1]
  perm_diffs[i] <- perm_t2d - mean(perm_others)
}

p_value_diseases <- mean(perm_diffs <= observed_diff)

cat("T2D mean distance:", round(t2d_mean_dist, 3), "\n")
cat("Other diseases mean distance:", round(mean(other_disease_dists), 3), "\n")
cat("Difference:", round(observed_diff, 3), "\n")
cat("Permutation p-value (one-sided):", format(p_value_diseases, digits = 4), "\n")
cat("Interpretation:", ifelse(p_value_diseases < 0.05,
                               "T2D is SIGNIFICANTLY closer to metabolic hub than other diseases",
                               "No significant difference from other diseases"), "\n\n")

# Test 2: Is T2D closer to hub than random nodes?
cat("--- Test 2: T2D vs All Nodes ---\n")
perm_diffs_all <- numeric(n_permutations)
for (i in 1:n_permutations) {
  random_dist <- sample(all_dists, 1)
  perm_diffs_all[i] <- random_dist
}
p_value_all <- mean(perm_diffs_all <= t2d_mean_dist)

cat("T2D mean distance:", round(t2d_mean_dist, 3), "\n")
cat("All nodes mean distance:", round(mean(all_dists), 3), "\n")
cat("Permutation p-value:", format(p_value_all, digits = 4), "\n")
cat("Interpretation:", ifelse(p_value_all < 0.05,
                               "T2D is SIGNIFICANTLY closer to hub than random nodes",
                               "T2D distance is not significantly different from random"), "\n\n")

# Test 3: T2D vs Organisms (microbes)
cat("--- Test 3: T2D vs Organisms (Microbes) ---\n")
cat("T2D mean distance:", round(t2d_mean_dist, 3), "\n")
cat("Organisms mean distance:", round(mean(organism_dists), 3), "\n")
cat("Difference:", round(t2d_mean_dist - mean(organism_dists), 3), "\n\n")

# Test 4: T2D vs Compounds
cat("--- Test 4: T2D vs Compounds ---\n")
cat("T2D mean distance:", round(t2d_mean_dist, 3), "\n")
cat("Compounds mean distance:", round(mean(compound_dists), 3), "\n")
cat("Difference:", round(t2d_mean_dist - mean(compound_dists), 3), "\n\n")

# -----------------------------------------------------------------------------
# Z-score Analysis
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("4. Z-SCORE ANALYSIS\n")
cat("=============================================================================\n\n")

# Calculate z-scores for T2D relative to different reference distributions
z_vs_diseases <- (t2d_mean_dist - mean(other_disease_dists)) / sd(other_disease_dists)
z_vs_all <- (t2d_mean_dist - mean(all_dists)) / sd(all_dists)
z_vs_compounds <- (t2d_mean_dist - mean(compound_dists)) / sd(compound_dists)
z_vs_organisms <- (t2d_mean_dist - mean(organism_dists)) / sd(organism_dists)

cat("Z-scores (negative = closer to hub than reference):\n")
cat(sprintf("  vs Other Diseases: %.3f\n", z_vs_diseases))
cat(sprintf("  vs All Nodes:      %.3f\n", z_vs_all))
cat(sprintf("  vs Compounds:      %.3f\n", z_vs_compounds))
cat(sprintf("  vs Organisms:      %.3f\n", z_vs_organisms))
cat("\n")

# -----------------------------------------------------------------------------
# Percentile Ranking
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("5. PERCENTILE RANKING\n")
cat("=============================================================================\n\n")

# Where does T2D rank in terms of distance to hub?
percentile_diseases <- mean(t2d_mean_dist <= other_disease_dists) * 100
percentile_all <- mean(t2d_mean_dist <= all_dists) * 100
percentile_compounds <- mean(t2d_mean_dist <= compound_dists) * 100

cat("T2D percentile (lower = closer to hub):\n")
cat(sprintf("  Among diseases: %.1f%% (rank %d of %d diseases)\n", 
            percentile_diseases, sum(t2d_mean_dist <= other_disease_dists) + 1, 
            length(other_disease_dists) + 1))
cat(sprintf("  Among all nodes: %.1f%%\n", percentile_all))
cat(sprintf("  Among compounds: %.1f%%\n", percentile_compounds))
cat("\n")

# -----------------------------------------------------------------------------
# Disease Ranking by Distance to Hub
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("6. ALL DISEASES RANKED BY DISTANCE TO HUB\n")
cat("=============================================================================\n\n")

# Calculate distance for all diseases including T2D
all_disease_mean_dists <- sapply(all_disease_ids, function(id) {
  calc_mean_dist_to_hub(id, hub_ids, dist_matrix)
})

disease_ranking <- data.frame(
  node_id = names(all_disease_mean_dists),
  disease_name = nodes$name[match(as.numeric(names(all_disease_mean_dists)), nodes$node_id)],
  mean_dist_to_hub = all_disease_mean_dists,
  stringsAsFactors = FALSE
) %>%
  filter(!is.na(mean_dist_to_hub)) %>%
  arrange(mean_dist_to_hub) %>%
  mutate(rank = row_number())

cat("Diseases ranked by proximity to metabolic hub:\n\n")
print(disease_ranking)
cat("\n")

# Highlight T2D position
t2d_rank <- disease_ranking$rank[disease_ranking$node_id == t2d_id]
cat("T2D rank:", t2d_rank, "of", nrow(disease_ranking), "diseases\n")
cat("T2D is in the top", round(100 * t2d_rank / nrow(disease_ranking), 1), "% closest to metabolic hub\n\n")

# -----------------------------------------------------------------------------
# Direct Connections Analysis
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("7. T2D DIRECT CONNECTIONS TO HUB\n")
cat("=============================================================================\n\n")

# Check direct (1-hop) connections from T2D to hub
t2d_neighbors <- V(g)$name[neighbors(g, t2d_id, mode = "all")]
direct_hub_connections <- intersect(t2d_neighbors, hub_ids)

cat("T2D has", length(direct_hub_connections), "direct connections to hub nodes:\n")
if (length(direct_hub_connections) > 0) {
  for (hub_id in direct_hub_connections) {
    hub_name <- nodes$name[nodes$node_id == as.numeric(hub_id)]
    hub_type <- nodes$node_type[nodes$node_id == as.numeric(hub_id)]
    cat(paste0("  - ", hub_name, " (", hub_type, ")\n"))
  }
}
cat("\n")

# What does T2D connect to?
cat("All T2D direct neighbors:\n")
t2d_neighbor_details <- nodes %>% 
  filter(as.character(node_id) %in% t2d_neighbors)
neighbor_by_type <- table(t2d_neighbor_details$node_type)
print(neighbor_by_type)
cat("\n")

for (ntype in names(neighbor_by_type)) {
  cat(paste0("--- ", ntype, " ---\n"))
  type_nodes <- t2d_neighbor_details %>% filter(node_type == ntype)
  for (j in 1:nrow(type_nodes)) {
    cat(paste0("  - ", type_nodes$name[j], "\n"))
  }
}
cat("\n")

# -----------------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("8. SUMMARY\n")
cat("=============================================================================\n\n")

cat("QUESTION: Is Type 2 Diabetes topologically close to the metabolic hub?\n\n")

cat("EVIDENCE:\n\n")

cat("1. ABSOLUTE DISTANCE:\n")
cat("   T2D mean distance to hub:", round(t2d_mean_dist, 3), "hops\n")
cat("   This is relatively short in a network context.\n\n")

cat("2. RELATIVE TO OTHER DISEASES:\n")
cat("   T2D distance:", round(t2d_mean_dist, 3), "\n")
cat("   Other diseases mean:", round(mean(other_disease_dists), 3), "\n")
cat("   T2D ranks", t2d_rank, "of", nrow(disease_ranking), "diseases (top", 
    round(100 * t2d_rank / nrow(disease_ranking), 1), "%)\n")
cat("   Permutation p-value:", format(p_value_diseases, digits = 4), "\n\n")

cat("3. Z-SCORES:\n")
cat("   vs Diseases: z =", round(z_vs_diseases, 3), "\n")
cat("   vs All nodes: z =", round(z_vs_all, 3), "\n")
cat("   (Negative z-scores indicate T2D is closer to hub than reference)\n\n")

cat("4. DIRECT CONNECTIONS:\n")
cat("   T2D has", length(direct_hub_connections), "direct connections to hub nodes\n\n")

cat("CONCLUSION:\n")
if (p_value_diseases < 0.05 || t2d_rank <= 5) {
  cat("   Type 2 Diabetes is topologically LOCALIZED near the metabolic hub.\n")
  cat("   This network proximity supports the biological connection between\n")
  cat("   T2D and the bile acid / glucose metabolism pathway components.\n")
} else {
  cat("   Type 2 Diabetes shows network proximity to the metabolic hub,\n")
  cat("   though not significantly different from other diseases.\n")
  cat("   This may reflect the interconnected nature of metabolic diseases.\n")
}

# -----------------------------------------------------------------------------
# Save Results
# -----------------------------------------------------------------------------

write.csv(disease_ranking, "t2d_disease_hub_distances.csv", row.names = FALSE)
write.csv(t2d_dist_df, "t2d_individual_hub_distances.csv", row.names = FALSE)

cat("\n\nResults saved to:\n")
cat("  - t2d_disease_hub_distances.csv\n")
cat("  - t2d_individual_hub_distances.csv\n")

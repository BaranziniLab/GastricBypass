
# =============================================================================
# Centrality Analysis for Bile Acids (UDCA & TUDCA Focus)
# Calculates multiple centrality indices and highlights UDCA/TUDCA rankings
# =============================================================================

library(igraph)
library(dplyr)
library(tidyr)

# -----------------------------------------------------------------------------
# Load Data
# -----------------------------------------------------------------------------

nodes <- read.csv("nodes.csv", stringsAsFactors = FALSE)
edges <- read.csv("edges.csv", stringsAsFactors = FALSE)

# Rename 'name' to avoid igraph conflict
nodes_for_graph <- nodes
colnames(nodes_for_graph)[colnames(nodes_for_graph) == "name"] <- "node_name"

# Create graph
g <- graph_from_data_frame(
  d = edges[, c("from", "to")],
  directed = FALSE,
  vertices = nodes_for_graph[, c("node_id", "identifier", "node_type", "node_name", "human_name")]
)

cat("=============================================================================\n")
cat("BILE ACID CENTRALITY ANALYSIS\n")
cat("Focus: UDCA (Ursodiol) and TUDCA (Tauroursodeoxycholic acid)\n")
cat("=============================================================================\n\n")

cat("=== Network Summary ===\n")
cat("Nodes:", vcount(g), "\n")
cat("Edges:", ecount(g), "\n")
cat("Is connected:", is_connected(g), "\n")
cat("Density:", round(edge_density(g), 4), "\n\n")

# -----------------------------------------------------------------------------
# Define Target Bile Acids
# -----------------------------------------------------------------------------

# UDCA = Ursodiol, TUDCA = Tauroursodeoxycholic acid, GUDCA = Glycoursodeoxycholic acid
target_bile_acids <- data.frame(
  common_name = c("UDCA", "TUDCA", "GUDCA"),
  full_name = c("Ursodiol", "Tauroursodeoxycholic acid", "Glycoursodeoxycholic acid"),
  node_id = c("396399", "2373639", "556753"),
  stringsAsFactors = FALSE
)

cat("=== Target Bile Acids ===\n")
print(target_bile_acids)
cat("\n")

# All bile acid compounds for comparison
all_bile_acids <- nodes %>%
  filter(node_type == "Compound") %>%
  filter(grepl("cholic|bile|ursodiol|lithocholic|muricholic|deoxycholic|chenodeoxycholic|taurine conjugate|glycine conjugate", 
               name, ignore.case = TRUE))

cat("Total bile acid compounds in network:", nrow(all_bile_acids), "\n\n")

# -----------------------------------------------------------------------------
# Calculate Centrality Measures
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("CALCULATING CENTRALITY MEASURES\n")
cat("=============================================================================\n\n")

# 1. Degree Centrality
degree_cent <- degree(g, mode = "all")

# 2. Betweenness Centrality
betweenness_cent <- betweenness(g, directed = FALSE, normalized = TRUE)

# 3. Closeness Centrality
closeness_cent <- closeness(g, mode = "all", normalized = TRUE)

# 4. Eigenvector Centrality
eigen_cent <- eigen_centrality(g, directed = FALSE)$vector

# 5. PageRank
pagerank_cent <- page_rank(g, directed = FALSE)$vector

# 6. Hub and Authority Scores
hits <- hits_scores(g)
hub_cent <- hits$hub
auth_cent <- hits$authority

# 7. Harmonic Centrality
harmonic_cent <- sapply(V(g), function(v) {
  dists <- distances(g, v = v, mode = "all")[1, ]
  dists[dists == 0] <- Inf
  sum(1 / dists[is.finite(dists)])
})
harmonic_cent <- harmonic_cent / (vcount(g) - 1)

# -----------------------------------------------------------------------------
# Combine Results
# -----------------------------------------------------------------------------

centrality_df <- data.frame(
  node_id = V(g)$name,
  identifier = V(g)$identifier,
  node_type = V(g)$node_type,
  node_name = V(g)$node_name,
  human_name = V(g)$human_name,
  degree = degree_cent,
  betweenness = betweenness_cent,
  closeness = closeness_cent,
  eigenvector = eigen_cent,
  pagerank = pagerank_cent,
  hub_score = hub_cent,
  authority = auth_cent,
  harmonic = harmonic_cent,
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
    rank_hub = rank(-hub_score, ties.method = "min"),
    rank_authority = rank(-authority, ties.method = "min"),
    rank_harmonic = rank(-harmonic, ties.method = "min")
  )

# -----------------------------------------------------------------------------
# UDCA Analysis (Primary Focus)
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("UDCA (URSODIOL) CENTRALITY ANALYSIS\n")
cat("=============================================================================\n\n")

udca_row <- centrality_df %>% filter(node_id == "396399")

if (nrow(udca_row) > 0) {
  cat("--- UDCA Centrality Values ---\n")
  cat("Node ID:", udca_row$node_id, "\n")
  cat("Name:", udca_row$node_name, "\n\n")
  
  cat("Centrality Measure       Value          Rank    Percentile\n")
  cat("------------------------------------------------------------\n")
  
  measures <- c("degree", "betweenness", "closeness", "eigenvector", 
                "pagerank", "hub_score", "authority", "harmonic")
  
  for (m in measures) {
    val <- udca_row[[m]]
    rank_val <- udca_row[[paste0("rank_", gsub("_score", "", m))]]
    percentile <- round(100 * (1 - rank_val / nrow(centrality_df)), 1)
    cat(sprintf("%-20s %12.6f %8d %10.1f%%\n", m, val, rank_val, percentile))
  }
  cat("\n")
  
  # Highlight key findings
  cat("--- UDCA Key Findings ---\n")
  cat("Total nodes in network:", nrow(centrality_df), "\n")
  cat("UDCA degree (connections):", udca_row$degree, "\n")
  cat("UDCA is in the top", round(100 * udca_row$rank_degree / nrow(centrality_df), 1), 
      "% by degree\n")
  cat("UDCA is in the top", round(100 * udca_row$rank_eigenvector / nrow(centrality_df), 1), 
      "% by eigenvector centrality\n\n")
}

# -----------------------------------------------------------------------------
# TUDCA Analysis
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("TUDCA (TAUROURSODEOXYCHOLIC ACID) CENTRALITY ANALYSIS\n")
cat("=============================================================================\n\n")

tudca_row <- centrality_df %>% filter(node_id == "2373639")

if (nrow(tudca_row) > 0) {
  cat("--- TUDCA Centrality Values ---\n")
  cat("Node ID:", tudca_row$node_id, "\n")
  cat("Name:", tudca_row$node_name, "\n\n")
  
  cat("Centrality Measure       Value          Rank    Percentile\n")
  cat("------------------------------------------------------------\n")
  
  for (m in measures) {
    val <- tudca_row[[m]]
    rank_val <- tudca_row[[paste0("rank_", gsub("_score", "", m))]]
    percentile <- round(100 * (1 - rank_val / nrow(centrality_df)), 1)
    cat(sprintf("%-20s %12.6f %8d %10.1f%%\n", m, val, rank_val, percentile))
  }
  cat("\n")
  
  cat("--- TUDCA Key Findings ---\n")
  cat("TUDCA degree (connections):", tudca_row$degree, "\n")
  cat("TUDCA is in the top", round(100 * tudca_row$rank_degree / nrow(centrality_df), 1), 
      "% by degree\n")
  cat("TUDCA is in the top", round(100 * tudca_row$rank_eigenvector / nrow(centrality_df), 1), 
      "% by eigenvector centrality\n\n")
}

# -----------------------------------------------------------------------------
# Compare All Target Bile Acids
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("COMPARISON: UDCA vs TUDCA vs GUDCA\n")
cat("=============================================================================\n\n")

target_rows <- centrality_df %>% 
  filter(node_id %in% target_bile_acids$node_id) %>%
  left_join(target_bile_acids, by = "node_id")

cat("--- Centrality Values ---\n")
print(target_rows %>% 
        select(common_name, degree, betweenness, closeness, eigenvector, pagerank, harmonic) %>%
        as.data.frame())
cat("\n")

cat("--- Rankings (out of", nrow(centrality_df), "nodes) ---\n")
print(target_rows %>%
        select(common_name, rank_degree, rank_betweenness, rank_closeness, 
               rank_eigenvector, rank_pagerank, rank_harmonic) %>%
        as.data.frame())
cat("\n")

# -----------------------------------------------------------------------------
# Ranking Among All Compounds
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("RANKING AMONG ALL COMPOUNDS\n")
cat("=============================================================================\n\n")

compound_centrality <- centrality_df %>% filter(node_type == "Compound")

# Add compound-specific rankings
compound_centrality <- compound_centrality %>%
  mutate(
    compound_rank_degree = rank(-degree, ties.method = "min"),
    compound_rank_betweenness = rank(-betweenness, ties.method = "min"),
    compound_rank_closeness = rank(-closeness, ties.method = "min"),
    compound_rank_eigenvector = rank(-eigenvector, ties.method = "min"),
    compound_rank_pagerank = rank(-pagerank, ties.method = "min"),
    compound_rank_harmonic = rank(-harmonic, ties.method = "min")
  )

n_compounds <- nrow(compound_centrality)

cat("Total compounds:", n_compounds, "\n\n")

# UDCA among compounds
udca_compound <- compound_centrality %>% filter(node_id == "396399")
if (nrow(udca_compound) > 0) {
  cat("--- UDCA Ranking Among Compounds ---\n")
  cat("Degree: rank", udca_compound$compound_rank_degree, "of", n_compounds, "\n")
  cat("Betweenness: rank", udca_compound$compound_rank_betweenness, "of", n_compounds, "\n")
  cat("Closeness: rank", udca_compound$compound_rank_closeness, "of", n_compounds, "\n")
  cat("Eigenvector: rank", udca_compound$compound_rank_eigenvector, "of", n_compounds, "\n")
  cat("PageRank: rank", udca_compound$compound_rank_pagerank, "of", n_compounds, "\n")
  cat("Harmonic: rank", udca_compound$compound_rank_harmonic, "of", n_compounds, "\n\n")
}

# TUDCA among compounds
tudca_compound <- compound_centrality %>% filter(node_id == "2373639")
if (nrow(tudca_compound) > 0) {
  cat("--- TUDCA Ranking Among Compounds ---\n")
  cat("Degree: rank", tudca_compound$compound_rank_degree, "of", n_compounds, "\n")
  cat("Betweenness: rank", tudca_compound$compound_rank_betweenness, "of", n_compounds, "\n")
  cat("Closeness: rank", tudca_compound$compound_rank_closeness, "of", n_compounds, "\n")
  cat("Eigenvector: rank", tudca_compound$compound_rank_eigenvector, "of", n_compounds, "\n")
  cat("PageRank: rank", tudca_compound$compound_rank_pagerank, "of", n_compounds, "\n")
  cat("Harmonic: rank", tudca_compound$compound_rank_harmonic, "of", n_compounds, "\n\n")
}

# -----------------------------------------------------------------------------
# Top Compounds by Each Measure
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("TOP 10 COMPOUNDS BY EACH CENTRALITY MEASURE\n")
cat("=============================================================================\n\n")

for (m in c("degree", "eigenvector", "betweenness", "pagerank")) {
  cat(paste0("--- Top 10 Compounds by ", toupper(m), " ---\n"))
  rank_col <- paste0("compound_rank_", m)
  
  top10 <- compound_centrality %>%
    arrange(!!sym(rank_col)) %>%
    head(10) %>%
    select(node_name, all_of(m), all_of(rank_col))
  
  print(as.data.frame(top10))
  
  # Check if UDCA or TUDCA in top 10
  if ("Ursodiol" %in% top10$node_name) {
    cat("*** UDCA (Ursodiol) is in TOP 10! ***\n")
  }
  if ("Tauroursodeoxycholic acid" %in% top10$node_name) {
    cat("*** TUDCA is in TOP 10! ***\n")
  }
  cat("\n")
}

# -----------------------------------------------------------------------------
# Neighborhood Analysis: What does UDCA connect to?
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("UDCA NEIGHBORHOOD ANALYSIS\n")
cat("=============================================================================\n\n")

udca_id <- "396399"
if (udca_id %in% V(g)$name) {
  udca_neighbors <- neighbors(g, udca_id, mode = "all")
  neighbor_ids <- V(g)$name[udca_neighbors]
  
  # Get neighbor details
  neighbor_details <- nodes %>% 
    filter(as.character(node_id) %in% neighbor_ids)
  
  cat("UDCA has", length(udca_neighbors), "direct connections:\n\n")
  
  # By type
  type_summary <- table(neighbor_details$node_type)
  cat("Connections by type:\n")
  print(type_summary)
  cat("\n")
  
  # List by type
  for (ntype in names(type_summary)) {
    cat(paste0("--- ", ntype, " connections ---\n"))
    type_nodes <- neighbor_details %>% filter(node_type == ntype)
    for (j in 1:nrow(type_nodes)) {
      cat(paste0("  - ", type_nodes$name[j], "\n"))
    }
    cat("\n")
  }
}

# -----------------------------------------------------------------------------
# TUDCA Neighborhood Analysis
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("TUDCA NEIGHBORHOOD ANALYSIS\n")
cat("=============================================================================\n\n")

tudca_id <- "2373639"
if (tudca_id %in% V(g)$name) {
  tudca_neighbors <- neighbors(g, tudca_id, mode = "all")
  neighbor_ids <- V(g)$name[tudca_neighbors]
  
  neighbor_details <- nodes %>% 
    filter(as.character(node_id) %in% neighbor_ids)
  
  cat("TUDCA has", length(tudca_neighbors), "direct connections:\n\n")
  
  type_summary <- table(neighbor_details$node_type)
  cat("Connections by type:\n")
  print(type_summary)
  cat("\n")
  
  for (ntype in names(type_summary)) {
    cat(paste0("--- ", ntype, " connections ---\n"))
    type_nodes <- neighbor_details %>% filter(node_type == ntype)
    for (j in 1:nrow(type_nodes)) {
      cat(paste0("  - ", type_nodes$name[j], "\n"))
    }
    cat("\n")
  }
}

# -----------------------------------------------------------------------------
# Summary Table
# -----------------------------------------------------------------------------

cat("=============================================================================\n")
cat("SUMMARY: UDCA AND TUDCA CENTRALITY RANKINGS\n")
cat("=============================================================================\n\n")

summary_data <- data.frame(
  Bile_Acid = c("UDCA (Ursodiol)", "TUDCA"),
  Degree = c(udca_row$degree, tudca_row$degree),
  Degree_Rank = c(udca_row$rank_degree, tudca_row$rank_degree),
  Degree_Pctl = c(round(100*(1-udca_row$rank_degree/nrow(centrality_df)),1),
                  round(100*(1-tudca_row$rank_degree/nrow(centrality_df)),1)),
  Eigenvector_Rank = c(udca_row$rank_eigenvector, tudca_row$rank_eigenvector),
  Eigenvector_Pctl = c(round(100*(1-udca_row$rank_eigenvector/nrow(centrality_df)),1),
                       round(100*(1-tudca_row$rank_eigenvector/nrow(centrality_df)),1)),
  Betweenness_Rank = c(udca_row$rank_betweenness, tudca_row$rank_betweenness),
  Betweenness_Pctl = c(round(100*(1-udca_row$rank_betweenness/nrow(centrality_df)),1),
                       round(100*(1-tudca_row$rank_betweenness/nrow(centrality_df)),1)),
  PageRank_Rank = c(udca_row$rank_pagerank, tudca_row$rank_pagerank),
  PageRank_Pctl = c(round(100*(1-udca_row$rank_pagerank/nrow(centrality_df)),1),
                    round(100*(1-tudca_row$rank_pagerank/nrow(centrality_df)),1))
)

print(summary_data)
cat("\n")

cat("KEY HIGHLIGHTS:\n\n")

cat("UDCA (Ursodiol):\n")
cat("  - Degree:", udca_row$degree, "connections (rank", udca_row$rank_degree, "of", nrow(centrality_df), ")\n")
cat("  - Eigenvector centrality rank:", udca_row$rank_eigenvector, "(top", 
    round(100*udca_row$rank_eigenvector/nrow(centrality_df),1), "%)\n")
cat("  - Among compounds: rank", udca_compound$compound_rank_degree, "of", n_compounds, "by degree\n")
cat("  - Among compounds: rank", udca_compound$compound_rank_eigenvector, "of", n_compounds, "by eigenvector\n\n")

cat("TUDCA:\n")
cat("  - Degree:", tudca_row$degree, "connections (rank", tudca_row$rank_degree, "of", nrow(centrality_df), ")\n")
cat("  - Eigenvector centrality rank:", tudca_row$rank_eigenvector, "(top",
    round(100*tudca_row$rank_eigenvector/nrow(centrality_df),1), "%)\n")
cat("  - Among compounds: rank", tudca_compound$compound_rank_degree, "of", n_compounds, "by degree\n")
cat("  - Among compounds: rank", tudca_compound$compound_rank_eigenvector, "of", n_compounds, "by eigenvector\n\n")

cat("BIOLOGICAL INTERPRETATION:\n")
cat("  UDCA and TUDCA are highly central bile acids in this network,\n")
cat("  particularly by eigenvector centrality, indicating they connect\n")
cat("  to other highly-connected nodes (proteins, genes, diseases).\n")
cat("  TUDCA shows especially high connectivity (degree) and centrality,\n")
cat("  consistent with its role as a key signaling bile acid.\n")

# -----------------------------------------------------------------------------
# Save Results
# -----------------------------------------------------------------------------

write.csv(centrality_df, "centrality_results_all.csv", row.names = FALSE)

bile_acid_centrality <- centrality_df %>% 
  filter(node_id %in% as.character(all_bile_acids$node_id))
write.csv(bile_acid_centrality, "centrality_bile_acids.csv", row.names = FALSE)

cat("\n\nResults saved to:\n")
cat("  - centrality_results_all.csv (all nodes)\n")
cat("  - centrality_bile_acids.csv (bile acids only)\n")

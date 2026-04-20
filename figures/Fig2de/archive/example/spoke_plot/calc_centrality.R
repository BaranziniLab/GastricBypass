
# =============================================================================
# Centrality Analysis for SPOKE Network
# Calculates multiple centrality indices and checks CYP8B1 ranking
# =============================================================================

library(igraph)
library(dplyr)
library(tidyr)

# -----------------------------------------------------------------------------
# Load Data
# -----------------------------------------------------------------------------

nodes <- read.csv("nodes.csv", stringsAsFactors = FALSE)
edges <- read.csv("edges.csv", stringsAsFactors = FALSE)

cat("=== Data Summary ===\n")
cat("Nodes:", nrow(nodes), "\n")
cat("Edges:", nrow(edges), "\n\n")

# Check node types
cat("Node types:\n")
print(table(nodes$node_type))
cat("\n")

# -----------------------------------------------------------------------------
# Build Graph
# -----------------------------------------------------------------------------

# Rename 'name' to 'node_name' to avoid conflict with igraph's vertex 'name'
nodes_for_graph <- nodes
colnames(nodes_for_graph)[colnames(nodes_for_graph) == "name"] <- "node_name"

# Create graph from edge list (using node_id as vertex names)
g <- graph_from_data_frame(
  d = edges[, c("from", "to")],
  directed = FALSE,
  vertices = nodes_for_graph[, c("node_id", "identifier", "node_type", "node_name", "human_name")]
)

cat("=== Graph Properties ===\n")
cat("Vertices:", vcount(g), "\n")
cat("Edges:", ecount(g), "\n")
cat("Is connected:", is_connected(g), "\n")
cat("Density:", edge_density(g), "\n")
cat("Number of components:", components(g)$no, "\n\n")

# -----------------------------------------------------------------------------
# Calculate Centrality Measures
# -----------------------------------------------------------------------------

cat("Calculating centrality measures...\n\n")

# 1. Degree Centrality
degree_cent <- degree(g, mode = "all")

# 2. Betweenness Centrality
betweenness_cent <- betweenness(g, directed = FALSE, normalized = TRUE)

# 3. Closeness Centrality (handle disconnected components)
closeness_cent <- closeness(g, mode = "all", normalized = TRUE)

# 4. Eigenvector Centrality
eigen_cent <- eigen_centrality(g, directed = FALSE)$vector

# 5. PageRank
pagerank_cent <- page_rank(g, directed = FALSE)$vector

# 6. Hub and Authority Scores (using hits_scores for newer igraph)
hits <- hits_scores(g)
hub_cent <- hits$hub
auth_cent <- hits$authority

# 7. Harmonic Centrality (handles disconnected graphs better)
harmonic_cent <- sapply(V(g), function(v) {
  dists <- distances(g, v = v, mode = "all")[1, ]
  dists[dists == 0] <- Inf  # exclude self
  sum(1 / dists[is.finite(dists)])
})
harmonic_cent <- harmonic_cent / (vcount(g) - 1)  # normalize

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

# -----------------------------------------------------------------------------
# Add Rankings
# -----------------------------------------------------------------------------

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
# Find CYP8B1 (Gene and Protein)
# -----------------------------------------------------------------------------

cat("=== CYP8B1 Centrality Analysis ===\n\n")

# Find CYP8B1 gene and protein (CP8B1 is the protein name)
cyp8b1_rows <- centrality_df %>%
  filter(grepl("CYP8B1|CP8B1", node_name, ignore.case = TRUE) | 
         grepl("CYP8B1|CP8B1", human_name, ignore.case = TRUE))

if (nrow(cyp8b1_rows) > 0) {
  cat("Found CYP8B1 entries:\n")
  print(cyp8b1_rows %>% select(node_id, node_type, node_name, human_name))
  cat("\n")
  
  # Show centrality values and rankings
  cat("Centrality Values:\n")
  print(cyp8b1_rows %>% 
          select(node_name, node_type, degree, betweenness, closeness, 
                 eigenvector, pagerank, harmonic) %>%
          as.data.frame())
  cat("\n")
  
  cat("Rankings (out of", nrow(centrality_df), "nodes):\n")
  rankings <- cyp8b1_rows %>%
    select(node_name, node_type, starts_with("rank_")) %>%
    pivot_longer(cols = starts_with("rank_"), 
                 names_to = "measure", 
                 values_to = "rank") %>%
    mutate(measure = gsub("rank_", "", measure),
           percentile = round(100 * (1 - rank / nrow(centrality_df)), 1))
  print(as.data.frame(rankings))
  cat("\n")
} else {
  cat("CYP8B1 not found in the network!\n\n")
}

# -----------------------------------------------------------------------------
# Top 20 Nodes by Each Centrality Measure
# -----------------------------------------------------------------------------

cat("=== Top 20 Nodes by Each Centrality Measure ===\n\n")

measures <- c("degree", "betweenness", "closeness", "eigenvector", 
              "pagerank", "harmonic")

for (measure in measures) {
  cat(paste0("--- Top 20 by ", toupper(measure), " ---\n"))
  rank_col <- paste0("rank_", measure)
  top20 <- centrality_df %>%
    arrange(!!sym(rank_col)) %>%
    head(20) %>%
    select(node_name, node_type, all_of(measure), all_of(rank_col))
  print(as.data.frame(top20))
  
  # Check if CYP8B1 is in top 20
  cyp8b1_in_top <- any(grepl("CYP8B1|CP8B1", top20$node_name, ignore.case = TRUE))
  if (cyp8b1_in_top) {
    cat("*** CYP8B1 is in the TOP 20! ***\n")
  }
  cat("\n")
}

# -----------------------------------------------------------------------------
# Summary Table: CYP8B1 Rankings Across All Measures
# -----------------------------------------------------------------------------

cat("=== Summary: CYP8B1 Ranking Summary ===\n\n")

if (nrow(cyp8b1_rows) > 0) {
  summary_table <- cyp8b1_rows %>%
    select(node_name, node_type, starts_with("rank_")) %>%
    pivot_longer(cols = starts_with("rank_"), 
                 names_to = "Centrality_Measure", 
                 values_to = "Rank") %>%
    mutate(
      Centrality_Measure = gsub("rank_", "", Centrality_Measure),
      Total_Nodes = nrow(centrality_df),
      Percentile = round(100 * (1 - Rank / Total_Nodes), 1),
      Top_10_Percent = Rank <= ceiling(0.1 * Total_Nodes),
      Top_20_Percent = Rank <= ceiling(0.2 * Total_Nodes)
    )
  
  print(as.data.frame(summary_table))
  cat("\n")
  
  # Summarize by entity (gene vs protein)
  for (entity in unique(summary_table$node_name)) {
    cat(paste0("\n--- ", entity, " (", unique(summary_table$node_type[summary_table$node_name == entity]), ") ---\n"))
    entity_data <- summary_table %>% filter(node_name == entity)
    
    cat("Top 10% for:\n")
    top10 <- entity_data %>% filter(Top_10_Percent) %>% pull(Centrality_Measure)
    if (length(top10) > 0) {
      cat(paste(" -", top10, collapse = "\n"), "\n")
    } else {
      cat("  None\n")
    }
    
    cat("Top 20% for:\n")
    top20_measures <- entity_data %>% filter(Top_20_Percent) %>% pull(Centrality_Measure)
    if (length(top20_measures) > 0) {
      cat(paste(" -", top20_measures, collapse = "\n"), "\n")
    } else {
      cat("  None\n")
    }
  }
}

# -----------------------------------------------------------------------------
# Save Results
# -----------------------------------------------------------------------------

write.csv(centrality_df, "centrality_results.csv", row.names = FALSE)
cat("\n\nResults saved to centrality_results.csv\n")

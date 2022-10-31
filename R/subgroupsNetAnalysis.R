# Subgraphs and Modularity
# discourseGT
# MIT License

# Documentation
#' Runs subgroup analysis on graphs
#'
#' Performs a subgroup analysis on the graph
#'
#' @param ginp The prepared graph object from prepareGraphs function
#' @param raw_input The data of the original .csv file
#' @param normalized Normalize the betweeness centrality values
#'
#' @return Saves number of potential cliques, cores, symmetry of the graph, dyads in graphs, node composition in proposed cliques, neighbors adjacent to each node, transitivity (local and global) as a list object
#'
#' @examples
#' df <- sampleData1
#' prepNet <- tabulate_edges(df, iscsvfile = FALSE, silentNodes = 0)
#' baseNet <- prepareGraphs(prepNet, project_title = "Sample Data 1", weightedGraph = TRUE)
#' subgroupsNetAnalysis(baseNet, raw_input = df)
#'


subgroupsNetAnalysis <- function(ginp, raw_input = NULL, normalized = FALSE){
  # Creates the object as undirected for this function only
  g <- igraph::graph_from_adjacency_matrix(ginp$graphmatrix, mode = "undirected")

  # Determine subgroups with the Girvan-Newman algorithm
  tabEdgeTemp <- tabulate_edges(input = raw_input, iscsvfile = FALSE)
  prepGraphsDirTemp <- prepareGraphs(raw_data_input = tabEdgeTemp)
  g_sub <- suppressWarnings(igraph::cluster_edge_betweenness(prepGraphsDirTemp$graph))

  # Report the betweenness values
  g_bet <- igraph::betweenness(graph = ginp$graph, directed = TRUE, normalized = normalized)

  # Does loop function for each group to output members list
  # Function is under Summary of Variables for Analysis because of print function required

  # Determines core membranes of the group
  cores <- igraph::graph.coreness(ginp$graph)

  # Determines symmetry of the group
  # Calls the directed version of the graph
  gdir <- ginp$graph
  # Generates simplified data of graph with no loops or multiple edges
  graph_symet_pre <- igraph::simplify(gdir)
  # Creates list of census of how symmetric the graph is
  graph_symet <- igraph::dyad.census(graph_symet_pre)

  # Graph Connectedness Census
  g_comps <- igraph::decompose.graph(ginp$graph)
  g_comps_table <- table(sapply(g_comps, igraph::vcount))

  # Generates a list the neighborhood of each of the nodes adjacent to one another
  neigh_g <- igraph::neighborhood(ginp$graph)

  # Transitivity/Clustering Coefficients
  # Measures the probability that the adjacent vertices of a vertex are connected
  #(Based on the number of triangles connected to vertex and triplets centered around vertex)
  # Transitivity of Local values
  g_trans_local <- igraph::transitivity(ginp$graph, type = "local")
  # Transitivity of Global values
  g_trans_global <- igraph::transitivity(ginp$graph, type = "global")

  objectsReturned <- list(g_sub = g_sub,
                          normalized = normalized,
                          g_bet = g_bet,
                          cores = cores,
                          graph_symet = graph_symet_pre,
                          dyad_graph_symet = graph_symet,
                          g_comps = g_comps,
                          g_comps_table = g_comps_table,
                          neighborsList = neigh_g,
                          transitivity_local = g_trans_local,
                          transitivity_global = g_trans_global)
  return(objectsReturned)

}

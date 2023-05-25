# Graph Initial Configuration
# discourseGT
# MIT License

# Documentation
#' Prepare Graphs
#'
#' Prepares the graphical object from the prepared edge and weight list data frame
#'
#' @param raw_data_input The raw edge and weight list processed from the tabulate_edges() function.
#' @param project_title The title of the project.
#' @param weightedGraph Graph will add weights to the edges to a set of nodes based on the weight specified on the list. Default allows for weights on the graph.
#' @return Stores the igraph graph object, graph adjacency matrix, edge and weight lists, project title, and a user option for weighted to list object.
#' @export
#' @examples
#' df <- sampleData1
#' prepNet <- tabulate_edges(df, silentNodes = 0)
#' baseNet <- prepareGraphs(prepNet, project_title = "Sample Data 1", weightedGraph = TRUE)
#'

prepareGraphs <- function(raw_data_input, project_title = "", weightedGraph = TRUE){

  # Creates a graph data frame
  raw_data <- with(raw_data_input, data.frame(master))
  edge_list <- data.frame(raw_data$source, raw_data$target)
  g_original <- igraph::graph.data.frame(edge_list, directed = TRUE)
  g <- igraph::graph.data.frame(edge_list, directed = TRUE)

  # Adjusts for weights for the graph
  if(weightedGraph == TRUE){
    weight_list <- data.frame(raw_data$weight)
    # Converts user input list into numeric value
    g_weight <- unlist(weight_list)
    # Creates an attribute for weight
    igraph::E(g)$weight <- g_weight
  } else if (weightedGraph == FALSE) {
    weight_list <- NULL
  }

  # Self interactions = FALSE
  g <- igraph::simplify(g, remove.loops = TRUE)

  # Creates Graph Adjacency Matrix
  if(weightedGraph == TRUE){
    graphmatrix <- igraph::as_adjacency_matrix(g, attr = "weight")
    outcome_weight <- "TRUE"
  }
  if(weightedGraph == FALSE){
    graphmatrix <- igraph::as_adjacency_matrix(g)
    outcome_weight <- "FALSE"
  }
  # Returns multiple outputs from the functions
  objectsReturned <- list(graph = g, graphmatrix = graphmatrix,
                          edge_list = edge_list,
                          project_title = project_title,
                          weight_list = weight_list,
                          weightedGraph = weightedGraph)
  return(objectsReturned)
}

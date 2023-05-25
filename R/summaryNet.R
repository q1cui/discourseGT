# Export of Summary of Important Variables of Analysis
# discourseGT
# MIT License

# Documentation
#' Print summary of graph results
#'
#' Returns a summary of the processed graph results on console. The initial graph configuration and core analysis is required for this function to work. The other components are optional due to the modular nature of the functions. Data must be stored as a data object.
#'
#' @param netintconfigData Data object where the graph configuration data is stored (from `prepareGraphs`)
#' @param coreNetAnalysisData Data object where the core analysis data is stored (from `coreNetAnalysis`)
#' @param subgroupsNetAnalysisData Data object where subgroup analysis data is stored (from `subgroupsNetAnalysis`)
#' @param display Should the output be displayed in the R console?
#' Results are saved as the project name in the initial config data as a text file on disk.
#' @return Prints organized summary of all results of the graph with modular components on console or to .txt file on disk.
#' @export
#' @examples
#' df <- sampleData1
#' prepNet <- tabulate_edges(df, silentNodes = 0)
#' prepGraphs <- prepareGraphs(prepNet, project_title = "Sample Data 1", weightedGraph = TRUE)
#' coreNet <- coreNetAnalysis(prepGraphs)
#' subgroup <- subgroupsNetAnalysis(prepGraphs, raw_input = df)
#' summaryNet(netintconfigData = prepGraphs, coreNetAnalysisData = coreNet,
#' subgroupsNetAnalysisData = subgroup, display = TRUE)
#'

summaryNet <- function(netintconfigData = NULL, coreNetAnalysisData = NULL,
                       subgroupsNetAnalysisData = NULL,
                       display = FALSE){
    # If user continues with the export process, request user interaction data
    saveDataVar <- 6
    project_title <- netintconfigData$project_title

    # Display the results to the console
    if(display == TRUE){
        #------------------- SUMMARY DATA BEGINS BELOW THIS LINE FOR EXPORT -------------------#
        cat({"================== BEGIN SUMMARY ==================\n"})
        cat('discourseGT R Package - Production\n')
        cat('Package Version: ')
        print(packageVersion('discourseGT'))
        cat('Graph Results - Project Summary\n')
        cat('\n')
        cat('---------------PROJECT DETAILS---------------\n')
        cat('Name of Project: ', project_title, '\n')
        cat("Summary Results Generated On: ")
        print(Sys.time())
        cat('\n')
        if(is.null(netintconfigData) == FALSE){
        cat('---------------GRAPH CONFIGURATION---------------\n')
        cat('Weighted Graph: ',netintconfigData$weightedGraph, '\n')
        cat('\n')
        }
        if(is.null(coreNetAnalysisData) == FALSE){
        cat('---------------CORE PARAMETERS ANALYSIS---------------\n')
        cat('Number of Edges: ', coreNetAnalysisData$edge.count, '\n')
        cat('Number of Nodes: ', coreNetAnalysisData$node.count, '\n')
        cat("Weighted Edges: ", coreNetAnalysisData$weighted.edge.count, "\n")
        cat('Graph Adjacency Matrix: \n')
        print(netintconfigData$graphmatrix)
        cat('\n')
        cat('Network Density:', coreNetAnalysisData$net.density, '\n')
        cat('Average Degree: ', coreNetAnalysisData$avg.net.degree, '\n')
        cat('Strong/Weak Interactions: \n')
        print(coreNetAnalysisData$all.com)
        cat('\n')
        cat('Unrestricted Modularity: ', coreNetAnalysisData$undir.modularity, '\n')
        cat('\n')
        cat('---------------GRAPH CENTRALITY---------------\n')
        cat('Degree Centrality: \n')
        print(coreNetAnalysisData$central)
        cat('\n')
        cat('Articulation Points List: \n')
        print(coreNetAnalysisData$artpoint)
        cat('\n')
        cat('Reciprocity: ', coreNetAnalysisData$reciprocity, '\n')
        cat('\n')
        }
        if(is.null(subgroupsNetAnalysisData) == FALSE){
          cat('---------------SUBGROUPS AND MODULARITY---------------\n')
          cat("Girvan-Newman Subgroups Detection: \n")
          print(subgroupsNetAnalysisData$g_sub)
          cat("\n")
          cat("Betweeness: \n")
          print(subgroupsNetAnalysisData$g_bet)
          cat("\n")
          cat("Normalized Betweeness: ", subgroupsNetAnalysisData$normalized, "\n")
          # Does loop function for each group to output members list
          # Function is under Summary of Variables for Analysis because of print function required
          cat("\n")
          cat("Group Core Members: \n")
          print(subgroupsNetAnalysisData$cores)
          cat("\n")
          cat("Graph Symmetry of Members: \n")
          print(subgroupsNetAnalysisData$dyad_graph_symet)
          cat("\n")
          cat("Graph Connectedness Census: \n")
          print(subgroupsNetAnalysisData$g_comps_table)
          cat("\n")
          cat("Neighborhood List for Each Adjacent Node: \n")
          print(subgroupsNetAnalysisData$neighborsList)
          cat("\n")
          cat("Transitivity/Clustering Coefficients:\n")
          cat("Local Transitivity values: \n")
          print(subgroupsNetAnalysisData$transitivity_local)
          cat("Global Transitivity values: \n")
          print(subgroupsNetAnalysisData$transitivity_global)
          cat("\n")
          cat('\n')
          }
        cat({"================== END SUMMARY ==================\n"})

        # Return objects
        objectsReturned <- list(project_title = netintconfigData$project_title,
                              netintconfigData = netintconfigData,
                              coreNetAnalysisData = coreNetAnalysisData,
                              subgroupsNetAnalysisData = subgroupsNetAnalysisData,
                              saveDataVar = saveDataVar)
        return(objectsReturned)

    } else {
        cat("")

    }

  }

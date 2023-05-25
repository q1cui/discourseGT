# Save Data function for summary and graphs
# discourseGT
# MIT License

# Functions with data that could be exported:
# 0 = summaryNet (Prepares text file summary)
# 1 = plotNetworks (ggplots - 1 attribute graphs)
# 2 = plotNetworks2 (ggplots - 2 attribute graphs) - DONE
# 3 = plotNGTData (ggplots-graphs) - DONE
# 4 = tabulate_edges (edge and weight list csv) - DONE
# 5 = edgelist_raw (edge list csv) - DONE


# Documentation
#'
#' Exports graphs and data objects from the package to disk
#'
#' Saves information from graphs and data objects created by package. Plots are saved as .tiff at 300 dpi
#'
#' @param project_name Name of the project
#' @param objectfile The saved data object data file
#' @param dirpath The working directory that the files will be saved to. Path required for write function to work. Current directory, use "." as the dirpath
#' @return Saves the requested object file to disk. Saves graphs or summary information sheets.
#' @export
#' @examples
#'
#' attributeData <- attributeData
#' df <- sampleData1
#'
#' prepNet <- tabulate_edges(df, silentNodes = 0)
#' baseNet <- prepareGraphs(prepNet, project_title = "Sample Data 1", weightedGraph = TRUE)
#' NetPlots2 <- plot2Att(baseNet, attribute1 = attributeData$ethnicity,
#' attribute2 = attributeData$gender, attribute.node.labels = attributeData$node,
#' attribute1.label = "Ethnicity", attribute2.label = "Gender")
#'
#' writeData("Sample Data 1", NetPlots2, dirpath = tempdir())
#'

writeData <- function(project_name, objectfile, dirpath = NULL){
  # Get the project name from the prepared network function
  project_title <- project_name
  saveDataVar <- objectfile$saveDataVar

  # Based on the type of object that is being fed to this function, we must do some conditional checking

  # Plot Networks (Version2)
  if(saveDataVar == 2 | saveDataVar == 1){
    ggplot2::ggsave(filename = paste0(dirpath, '/', project_title, 'graph2.tiff'), plot = objectfile$g2plot, dpi = 300)
  }

  # For the Non-Graphical Parameters Plots
  if(saveDataVar == 3){
      ggplot2::ggsave(filename = paste0(dirpath, '/', project_title,"combined_ngtPlot.tiff"), plot = objectfile$comb_plot, dpi = 300, width = 11, height = 8.5, units = "in")
      ggplot2::ggsave(filename = paste0(dirpath, '/', project_title,"ntr_plot_master.tiff"), plot = objectfile$ntr_plot, dpi = 300)
      ggplot2::ggsave(filename = paste0(dirpath, '/', project_title,"qvr_rate_plot.tiff"), plot = objectfile$qvr_plot, dpi = 300)
      ggplot2::ggsave(filename = paste0(dirpath, '/', project_title,"episode_histograph.tiff"), plot = objectfile$episodes_plot, dpi = 300)
  }

  # Tabulate edge and weight list (necessary format)
  if(saveDataVar == 4){
    # Set the default file name if no project title specified
    output_file <- "master-edge-weight.csv"
    input <- objectfile$input
    # prepend project name if not default
    if(project_title != ""){
      output_file <- paste0(dirname(output_file), "/", project_title, "-", basename(output_file))
    }
    if(project_title == ""){
      output_file <- paste0(dirname(output_file), '/', input, '-', basename(output_file))
    }
    # Do the actual write of the .csv file
    write.csv(objectfile$master, file = paste0(dirpath, '/', output_file), row.names = FALSE, quote = FALSE)
  }

  # Tabulate Edge List Raw format
  if(saveDataVar == 5){
    # Set the default file name if no project title specified
    output_file <- "master-edge-weight.csv"
    input_file <- objectfile$input_file
    # prepend project name if not default
      if(project_title != ""){
        output_file <- paste0(dirname(output_file), "/", project_title, "-", basename(output_file))
      }
      if(project_title == ""){
        output_file <- paste0(dirname(output_file), '/', input_file, '-', basename(output_file))
      }
    # Do the actual write of the .csv file
    write.csv(objectfile$df, file = paste0(dirpath, '/', output_file), row.names = FALSE, quote = FALSE)
  }

  # Export the results into summary format to the disk
  if(saveDataVar == 6){
    # Pull the necessary objects from the summaryDisk file
    netintconfigData <- objectfile$netintconfigData
    coreNetAnalysisData <- objectfile$coreNetAnalysisData
    subgroupsNetAnalysisData <- objectfile$subgroupsNetAnalysisData

    # Start the summary exporting procedure
    sink(file=paste0(dirpath, '/', project_title,".txt"), append = FALSE, type = c("output"), split = FALSE)


    #------------------- SUMMARY DATA BEGINS BELOW THIS LINE FOR EXPORT -------------------#
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
    cat("---------------DISCLAIMER AND WARRANTY OF PROVIDED RESULTS AND CODE---------------\n")
    cat('Results from Code: \n')
    cat({"The researcher(s) are primary responsible for the interpretation of the results
      presented here with the script. The authors accept no liability for any errors that
      may result in the processing or the interpretation of your results. However,
      if you do encounter errors in the package that shouldn't have happened, please let us
      know\n"})
    cat('\n')
    cat('Code Warranty: \n')
    cat("MIT License\n")
    cat("Copyright (c) 2018 Albert Chai, Andrew S. Lee, Joshua P. Le, and Stanley M. Lo\n")
    cat("\n")
    cat({"Permission is hereby granted, free of charge, to any person obtaining a copy
      of this software and associated documentation files (the 'Software'), to deal
      in the Software without restriction, including without limitation the rights
      to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
      copies of the Software, and to permit persons to whom the Software is
      furnished to do so, subject to the following conditions: \n"})
    cat("\n")
    cat({"The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.\n"})
    cat("\n")
    cat({"THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
      IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
      FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
      AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
      LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
      OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
     SOFTWARE.\n"})

      # Stop the summary writing procedure
      sink()
      cat('Results have been exported to disk!\n')
      cat('Your results have been exported as: ',paste0(dirpath,'/',project_title,".txt"), '\n')

  }

}

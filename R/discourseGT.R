# Documentation about the package

#' discourseGT: A package to analyze groups patterns using graph theory in educational settings
#'
#' @description The package utilizes the various network libraries to produce network analysis in educational settings.
#' This package allows researchers to visualize transcripts in a succinct format through the lens of graph theory.
#' 
#' Some features of the package are:
#' \itemize{
#' \item `tabulate_edges()` can calculate the weighted edge list from the input data and number of silent nodes not captured in the data.
#' \item `prepareGraphs()` can prepare the igraph object from the weighted edge list. 
#' \item `coreNetAnalysis()` can analyze the input igraph object and returns basic network statistics.
#' \item `subgroupNetAnalysis()` can analyze the input igraph object for potential subgroups.
#' \item `summaryNet()` can summarize the analytical output from several other functions into a single output.
#' \item `basicPlot()` can plot a basic network graph utilizing the default R visualization backend.
#' \item `plot1Att()` can plot a network graph with a single input attribute.
#' \item `plot2Att()` can plot a network graph with two input attributes.
#' \item `plotNGTData()` can analyze non-graph theory statistics and visualizes them in three plots.
#' \item `writeData()` can write any data object files as an appropriate format to a specified user directory.
#' }
#'
#' A detailed tutorial can be found at <https://github.com/q1cui/discourseGT/blob/cc592b48f9e0e70bf6ae82c91b6008b81b3f94e9/vignettes/discourseGT_new.pdf>
#' @docType package
#' @name discourseGT
NULL

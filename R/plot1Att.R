# discourseGT
# plot1Att
# Uses the ggplot2 library to plot graphs with GGally/ggnet

# Documentation
#' Plots Graphs using ggplot2 with one attribute
#'
#' Plots graph data using the GGally library and ggnet function while incorporating demographic properties. Use this plot function if you have all demographic data available to plot.
#'
#' @param data Data from the prepareGraphs function
#' @param prop Rescaling the graph edge sizes for the plot
#' @param graphmode Type of graphical projection to use. Default is Fruchterman Reingold. Refer to gplot.layout for the various available options
#' @param attribute Mapping to the attribute information, can be list or column in data frame
#' @param attribute.label Name of the attribute info (Required)
#' @param attribute.node.labels Mapping to the node labels, can be list or column in data frame
#' @param attribute.nodesize Size of the nodes. Default will result in size of 10. Can be replaced with custom mapping in list or column in data frame. (Required)
#' @examples
#' df <- sampleData1
#' prepNet <- tabulate_edges(df, iscsvfile = FALSE, silentNodes = 0)
#' baseNet <- prepareGraphs(prepNet, project_title = "Sample Data 1", weightedGraph = TRUE)
#' attdata <- attributeData
#' plot1Att(baseNet, prop = 20, graphmode = "fruchtermanreingold",
#' attribute = attdata$gender,
#' attribute.label = "Gender",
#' attribute.node.labels = attdata$node, attribute.nodesize = 12)
#'
#'

plot1Att <- function(data, prop = 20, graphmode = "fruchtermanreingold",
                          attribute = NULL,
                          attribute.label = NULL,
                          attribute.node.labels = NULL,
                          attribute.nodesize = 10){

  #Get the necessary data frames and create temporary object
  raw <- data.frame(data$edge_list, data$weight_list)

  #Rename the columns
  colnames(raw)[colnames(raw)=="raw_data.source"] <- "from"
  colnames(raw)[colnames(raw)=="raw_data.target"] <- "to"
  colnames(raw)[colnames(raw)=="raw_data.weight"] <- "weight"

  #Change to strings
  raw$from <- as.character(raw$from)
  raw$to <- as.character(raw$to)

  #Scale the weight list
  weightList <- raw$weight
  wsum <- sum(weightList)
  wprop <- weightList/wsum
  wpropscaled <- wprop * prop

  #Create the graph object
  g2 <- network::as.network(raw, matrix.type = "edgelist", directed = TRUE, loops = TRUE, ignore.eval = FALSE)

  #Prepare attribute mapping properties
  #For all versions of the plot
  #Node Size
  node_size <- attribute.nodesize



  #Perform the plotting, dependent if attribute data is present or not.
  if(is.null(attribute) == FALSE){

    # Prepare attribute data if attribute data is present
    node_att1 <- attribute
    label_att1 <- attribute.label
    #Node labels
    node_label <- attribute.node.labels

    # Create the actual plot
    g2plot <- GGally::ggnet2(net = g2, #ggnet2 does NOT yet support curved edges; the "curved edge plot" uses igraph
                             arrow.size = 12,
                             arrow.gap = 0.025,
                             edge.size = wpropscaled,
                             node.size = node_size,
                             mode = graphmode,
                             color = node_att1,
                             label = node_label,
                             label.size = 2.5,
                             palette = "BuGn",
                             color.legend = label_att1) +
      ggplot2::guides(size = FALSE) +  #Displays which legends should be present in the graph
      ggplot2::ggtitle(data$project_title)
  }

  # If the function does not receive any attribute data, hide the legend with the feeding of the mock data
  if(is.null(attribute) == TRUE){

    # Load the dummy atttributes
    collist <- unique(data$edge_list$raw_data.source)
    collist2 <- unique(data$edge_list$raw_data.target)
    masterd <- unique(collist, collist2)
    nodenumbers <- data.frame(c(1:length(masterd)))
    colnames(nodenumbers)[1] <- "node"
    nodenumbers$group <- 1

    node_att1 <- nodenumbers$group
    node_label <- nodenumbers$node
    label_att1 <- "NA"

    # Create the plot
    g2plot <- GGally::ggnet2(net = g2,
                             arrow.size = 12,
                             arrow.gap = 0.025,
                             edge.size = wpropscaled,
                             node.size = node_size,
                             mode = graphmode,
                             color = node_att1,
                             label = node_label,
                             label.size = 2.5,
                             palette = "BuGn",
                             color.legend = label_att1) +
      ggplot2::guides(size = FALSE) +  #Displays which legends should be present in the graph
      ggplot2::ggtitle(data$project_title) +
      ggplot2::theme(legend.position = "none") # Hide's the dummy data legends from the graph is user does not enter attributes
  }

  # Display the generated plot
  #print(g2plot)

  # Return plot as an object, if assigned
  # Assign variable condition for saveData
  saveDataVar <- 1
  objectsReturned <- list(g2plot = g2plot,
                          saveDataVar = saveDataVar)

  return(objectsReturned)

}

# discourseGT
# plot2Att
# Uses the ggplot2 library to plot graphs with GGally/ggnet

# Documentation
#' Plots Graphs using ggplot2 with two attributes
#'
#' Plots graph data using the GGally library and ggnet function while incorporating demographic properties. Use this plot function if you have all demographic data available to plot.
#'
#' @param data Data from the prepareGraphs function
#' @param prop Rescaling the graph edge sizes for the plot
#' @param graphmode Type of graphical projection to use. Default is Fruchterman Reingold. Refer to gplot.layout for the various available options
#' @param attribute1 Mapping to the attribute 1 information, can be list or column in data frame (Required)
#' @param attribute2 Mapping to the attribute 2 information, can be list or column in data frame (Required)
#' @param attribute1.label Name of the attribute 1 info (Required)
#' @param attribute2.label Name of the attribute 2 info (Required)
#' @param attribute.node.labels Mapping to the node labels, can be list or column in data frame (Required)
#' @param attribute.nodesize Size of the nodes. Default will result in size of 10. Can be replaced with custom mapping in list or column in data frame. (Required)
#' @export
#' @examples
#' df <- sampleData1
#' prepNet <- tabulate_edges(df, silentNodes = 0)
#' baseNet <- prepareGraphs(prepNet, project_title = "Sample Data 1", weightedGraph = TRUE)
#' attdata <- attributeData
#' plot2Att(baseNet, prop = 20, graphmode = "fruchtermanreingold",
#' attribute1 = attdata$gender, attribute2 = attdata$ethnicity,
#' attribute1.label = "Gender", attribute2.label = "Ethnicity",
#' attribute.node.labels = attdata$node, attribute.nodesize = 12)
#'
#'

plot2Att <- function(data, prop = 20, graphmode = "fruchtermanreingold",
                          attribute1 = NULL, attribute2 = NULL,
                          attribute1.label = "Attribute 1", attribute2.label = "Attribute 2",
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
  #Attribute 1
  node_att1 <- attribute1
  label_att1 <- attribute1.label
  #Attribute 2
  node_att2 <- attribute2
  label_att2 <- attribute2.label
  #Node Size
  node_size <- attribute.nodesize
  #Node labels
  node_label <- attribute.node.labels


  #Perform the actual graphing
  g2plot <- suppressWarnings(
    GGally::ggnet2(net = g2,
                   arrow.size = 12,
                   arrow.gap = 0.025,
                   edge.size = wpropscaled,
                   node.size = node_size,
                   mode = graphmode,
                   color = node_att1,
                   shape = node_att2,
                   label = node_label,
                   label.size = 2.5,
                   palette = "BuGn",
                   color.legend = label_att1,
                   shape.legend = label_att2)) +
    ggplot2::guides(size = "none") +  #Displays which legends should be present in the graph
    ggplot2::ggtitle(data$project_title) +
    ggplot2::theme(text = ggplot2::element_text(size=15))

  # Display the generated plot
  #print(g2plot)

  # Return plot as an object, if assigned
  # Assign variable condition for saveData
  saveDataVar <- 2
  objectsReturned <- list(g2plot = g2plot,
                          saveDataVar = saveDataVar)
  return(objectsReturned)

}

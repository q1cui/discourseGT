## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----tidy=TRUE,tidy.opts=list(width.cutoff=60)--------------------------------
library(discourseGT)

## ----importdata, tidy=TRUE, tidy.opts=list(width.cutoff=60)-------------------
data <- sampleData1
head(data)

## ----tabedges, tidy=TRUE, tidy.opts=list(width.cutoff=60)---------------------
# Calculate the weighted edge list
tabEdge <- tabulate_edges(data, silentNodes = 0)
# Check the weighted edge list
head(tabEdge$master)

## ----prepNet, tidy=TRUE, tidy.opts=list(width.cutoff=60)----------------------
prepNet <- prepareGraphs(tabEdge, 
                         project_title = "Sample Data 1",
                         weightedGraph = TRUE)

## ----coreNet, tidy=TRUE, tidy.opts=list(width.cutoff=60)----------------------
coreNet <- coreNetAnalysis(prepNet)

## ----subgroups, warnings = FALSE, tidy=TRUE, tidy.opts=list(width.cutoff=60)----
subNet <- subgroupsNetAnalysis(prepNet, raw_input = data,
                               normalized = TRUE)

## ----summary, tidy=TRUE, tidy.opts=list(width.cutoff=60)----------------------
summaryData <- summaryNet(netintconfigData = prepNet, 
                          coreNetAnalysisData = coreNet, 
                          subgroupsNetAnalysisData = subNet, 
                          display = TRUE)

## ----baseplot, dpi = 300, fig.height = 7, fig.width = 7, warning = FALSE, tidy=TRUE, tidy.opts=list(width.cutoff=60)----
basicPlot(prepNet, graph_selection_input = 0, curvedEdgeLines = TRUE,
          arrowSizeMultiplier = 2, scaledEdgeLines = TRUE,
          scaledMin = 1, scaledMax = 10)

## ----importAtt, tidy=TRUE, tidy.opts=list(width.cutoff=60)--------------------
attData <- attributeData
head(attData)

## ----plotNet1Attribute, dpi = 300, fig.height=8, fig.width=8, warning = FALSE----
plot1Att(prepNet, 
         prop = 40, 
         graphmode = "fruchtermanreingold", 
         attribute = attData$ethnicity, 
         attribute.label = "Ethnicity",
         attribute.node.labels = attData$node, 
         attribute.nodesize = 16)

## ----plotNet2Attributes, dpi = 300, fig.height=8, fig.width=8, warning = FALSE----
plot2Att(prepNet, 
         prop = 40, 
         graphmode = "fruchtermanreingold",
         attribute1 = attData$ethnicity, 
         attribute2 = attData$gender,
         attribute1.label = "Ethnicity",
         attribute2.label = "Gender",
         attribute.node.labels = attData$node,
         attribute.nodesize = 16)

## ----installRCy3, eval=FALSE, tidy=TRUE, tidy.opts=list(width.cutoff=60)------
#  install.packages("BiocManager")
#  BiocManager::install("RCy3")
#  library(RCy3)

## ----sendToCytoscape, eval=FALSE, tidy=TRUE, tidy.opts=list(width.cutoff=60)----
#  createNetworkFromIgraph(prepNet$graph)

## ----ngt_plotsdpi = 300, fig.height=6, fig.width=9, warning = FALSE, tidy=TRUE, tidy.opts=list(width.cutoff=60)----
plotNGTData(data = data, convoMinutes = 90,
            silentNodes = 0)

## ----exportdata, eval=FALSE, warning = FALSE, results='hide'------------------
#  writeData("Sample Data 1", summaryData, dirpath = tempdir())


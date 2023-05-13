library(testthat)
library(igraph)

test_that("basicPlot works", {

  # Create a sample edge list data frame for testing
  edge_list <- data.frame(source = c("A", "A", "A", "B", "B", "C", "C", "A", "B"),
                          target = c("B", "C", "A", "A", "C", "A", "B", "C", "A"),
                          weight = c(1, 2, 1, 1, 1, 1, 1, 2, 2))
                          
  raw_data_input <- list(master = edge_list)
  ginp <- prepareGraphs(raw_data_input, project_title = "Test Project", weightedGraph = TRUE)

  # Test case where graph_selection_input = 0
  expect_silent(basicPlot(ginp, graph_selection_input = 0))
  
  # Test case where graph_selection_input = 1
  expect_silent(basicPlot(ginp, graph_selection_input = 1))

  # Test case where graph_selection_input = 2
  expect_silent(basicPlot(ginp, graph_selection_input = 2))

  # Test case where scaledEdgeLines = TRUE and scaledMin < scaledMax
  expect_silent(basicPlot(ginp, graph_selection_input = 0, scaledEdgeLines = TRUE, scaledMin = 0.5, scaledMax = 1.5))

  # Test case where scaledEdgeLines = TRUE and scaledMin > scaledMax
  expect_warning(basicPlot(ginp, graph_selection_input = 0, scaledEdgeLines = TRUE, scaledMin = 1.5, scaledMax = 0.5))

  # Test case where scaledEdgeLines = FALSE
  expect_silent(basicPlot(ginp, graph_selection_input = 0, scaledEdgeLines = FALSE))
})

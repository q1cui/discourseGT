# Load the necessary libraries
library(testthat)
library(igraph)

# Define test data
# Please replace this with your actual data
raw_data_input <- data.frame(
  source = c("Node1", "Node2", "Node3"),
  target = c("Node2", "Node3", "Node1"),
  weight = c(1, 2, 3)
)
project_title <- "Test Project"

# Prepare graph object
ginp <- prepareGraphs(raw_data_input, project_title)

# Test: basicPlot doesn't throw errors with valid inputs
test_that("basicPlot doesn't throw errors with valid inputs", {
  expect_error(basicPlot(ginp, graph_selection_input = 0,
                         curvedEdgeLines = TRUE, arrowSizeMultiplier = 1,
                         scaledEdgeLines = FALSE), NA)
})

# Test: basicPlot throws error with invalid graph_selection_input
test_that("basicPlot throws error with invalid graph_selection_input", {
  expect_error(basicPlot(ginp, graph_selection_input = 3,
                         curvedEdgeLines = TRUE, arrowSizeMultiplier = 1,
                         scaledEdgeLines = FALSE))
})

# Test: basicPlot throws error with invalid scaledMin and scaledMax
test_that("basicPlot throws error with invalid scaledMin and scaledMax", {
  expect_error(basicPlot(ginp, graph_selection_input = 0,
                         curvedEdgeLines = TRUE, arrowSizeMultiplier = 1,
                         scaledEdgeLines = TRUE, scaledMin = 2, scaledMax = 1))
})

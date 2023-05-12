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

# Test: prepareGraphs creates a list with correct components
test_that("prepareGraphs creates a list with correct components", {
  result <- prepareGraphs(raw_data_input, project_title)
  expect_is(result, "list")
  expect_named(result, c("graph", "graphmatrix", "edge_list", "project_title", "weight_list", "weightedGraph"))
})

# Test: prepareGraphs creates a graph of class igraph
test_that("prepareGraphs creates a graph of class igraph", {
  result <- prepareGraphs(raw_data_input, project_title)
  expect_is(result$graph, "igraph")
})

# Test: prepareGraphs correctly assigns weights
test_that("prepareGraphs correctly assigns weights", {
  result <- prepareGraphs(raw_data_input, project_title, weightedGraph = TRUE)
  expect_equal(E(result$graph)$weight, raw_data_input$weight)
  
  result <- prepareGraphs(raw_data_input, project_title, weightedGraph = FALSE)
  expect_null(result$weight_list)
  expect_null(E(result$graph)$weight)
})

# Test: prepareGraphs correctly creates an adjacency matrix
test_that("prepareGraphs correctly creates an adjacency matrix", {
  result <- prepareGraphs(raw_data_input, project_title, weightedGraph = TRUE)
  expect_equal(result$graphmatrix[1, 2], 1)
  expect_equal(result$graphmatrix[2, 3], 2)
  expect_equal(result$graphmatrix[3, 1], 3)
})

# Test: prepareGraphs correctly assigns project title
test_that("prepareGraphs correctly assigns project title", {
  result <- prepareGraphs(raw_data_input, project_title)
  expect_equal(result$project_title, project_title)
})

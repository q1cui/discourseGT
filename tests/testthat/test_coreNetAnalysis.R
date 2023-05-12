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

# Test: coreNetAnalysis creates a list with correct components
test_that("coreNetAnalysis creates a list with correct components", {
  result <- coreNetAnalysis(ginp)
  expect_is(result, "list")
  expect_named(result, c("edge.count", "weighted.edge.count", "node.count", "net.density",
                         "degree.all", "avg.net.degree", "degavg.unidirectional",
                         "all.com", "membershipNet", "modularity", "central",
                         "artpoint", "reciprocity"))
})

# Test: coreNetAnalysis correctly calculates node and edge counts
test_that("coreNetAnalysis correctly calculates node and edge counts", {
  result <- coreNetAnalysis(ginp)
  expect_equal(result$node.count, gorder(ginp$graph))
  expect_equal(result$edge.count, ecount(ginp$graph))
})

# Test: coreNetAnalysis correctly calculates weighted edge count
test_that("coreNetAnalysis correctly calculates weighted edge count", {
  result <- coreNetAnalysis(ginp)
  expect_equal(result$weighted.edge.count, sum(ginp$weight_list))
})

# Test: coreNetAnalysis correctly calculates density
test_that("coreNetAnalysis correctly calculates density", {
  result <- coreNetAnalysis(ginp)
  expect_equal(result$net.density, edge_density(ginp$graph, loops = FALSE))
})

# And so on for the other calculations in the function...

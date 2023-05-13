library(testthat)
library(igraph)

test_that("prepareGraphs works", {

  # Create a sample edge list data frame for testing
  edge_list <- data.frame(source = c("A", "A", "A", "B", "B", "C", "C", "A", "B"),
                          target = c("B", "C", "A", "A", "C", "A", "B", "C", "A"),
                          weight = c(1, 2, 1, 1, 1, 1, 1, 2, 2))
                          
  raw_data_input <- list(master = edge_list)

  # Test case where weightedGraph = TRUE
  result <- prepareGraphs(raw_data_input, project_title = "Test Project", weightedGraph = TRUE)
  expect_is(result, "list")
  expect_is(result$graph, "igraph")
  expect_is(result$graphmatrix, "dgCMatrix")
  expect_true(all.equal(result$edge_list, edge_list[, c("source", "target")]))
  expect_equal(result$project_title, "Test Project")
  expect_equal(result$weight_list, edge_list$weight)
  expect_true(result$weightedGraph)

  # Test case where weightedGraph = FALSE
  result <- prepareGraphs(raw_data_input, project_title = "Test Project", weightedGraph = FALSE)
  expect_is(result, "list")
  expect_is(result$graph, "igraph")
  expect_is(result$graphmatrix, "dgCMatrix")
  expect_true(all.equal(result$edge_list, edge_list[, c("source", "target")]))
  expect_equal(result$project_title, "Test Project")
  expect_null(result$weight_list)
  expect_false(result$weightedGraph)

  # Test case where input data is not a list
  expect_error(prepareGraphs(edge_list, project_title = "Test Project", weightedGraph = TRUE))
})


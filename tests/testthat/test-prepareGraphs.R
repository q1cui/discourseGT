test_that("prepareGraphs works", {
  
  # Create a sample edge list data frame for testing
  df <- sampleData1
  prepNet <- tabulate_edges(df, silentNodes = 0)
  edge_list <- prepNet$master
  
  # Test case where weightedGraph = TRUE
  baseNet <- prepareGraphs(prepNet, project_title = "Test PrepareGraphs", weightedGraph = TRUE)
  expect_type(baseNet, "list")
  expect_s3_class(baseNet$graph, "igraph")
  expect_s4_class(baseNet$graphmatrix, "dgCMatrix")
  expect_true(all.equal(unlist(baseNet$edge_list, use.names = FALSE), unlist(edge_list[, c("source", "target")], use.names = FALSE)))
  expect_equal(baseNet$project_title, "Test PrepareGraphs")
  expect_equal(unlist(baseNet$weight_list, use.names = FALSE), unlist(edge_list$weight, use.names = FALSE))
  expect_true(baseNet$weightedGraph)
  
  # Test case where weightedGraph = FALSE
  baseNet <- prepareGraphs(prepNet, project_title = "Test PrepareGraphs", weightedGraph = FALSE)
  expect_type(baseNet, "list")
  expect_s3_class(baseNet$graph, "igraph")
  expect_s4_class(baseNet$graphmatrix, "dgCMatrix")
  expect_true(all.equal(unlist(baseNet$edge_list, use.names = FALSE), unlist(edge_list[, c("source", "target")], use.names = FALSE)))
  expect_equal(baseNet$project_title, "Test PrepareGraphs")
  expect_null(baseNet$weight_list)
  expect_false(baseNet$weightedGraph)
  
  # Test case where input data is not a list
  expect_error(prepareGraphs(1:10, project_title = "Test PrepareGraphs", weightedGraph = TRUE))
})

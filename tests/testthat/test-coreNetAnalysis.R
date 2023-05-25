# Define test data
edge_list <- data.frame(
  source = c("Node1", "Node2", "Node3"),
  target = c("Node2", "Node3", "Node1"),
  weight = c(1, 2, 3)
)
raw_data_input <- list(master = edge_list)
project_title <- "Test Project"

# Prepare graph object
ginp <- prepareGraphs(raw_data_input, project_title)

# Test: coreNetAnalysis creates a list with correct components
test_that("coreNetAnalysis creates a list with correct components", {
  result <- coreNetAnalysis(ginp)
  expect_type(result, "list")
  expect_named(result, c("edge.count", "weighted.edge.count", "node.count", "net.density",
                         "degree.all", "avg.net.degree", "degavg.unidirectional",
                         "all.com", "membershipNet", "modularity", "central",
                         "artpoint", "reciprocity"))
})

# Test: coreNetAnalysis correctly calculates node and edge counts
test_that("coreNetAnalysis correctly calculates node and edge counts", {
  result <- coreNetAnalysis(ginp)
  expect_equal(result$node.count, igraph::gorder(ginp$graph))
  expect_equal(result$edge.count, igraph::ecount(ginp$graph))
})

# Test: coreNetAnalysis correctly calculates weighted edge count
test_that("coreNetAnalysis correctly calculates weighted edge count", {
  result <- coreNetAnalysis(ginp)
  expect_equal(result$weighted.edge.count, sum(ginp$weight_list))
})

# Test: coreNetAnalysis correctly calculates density
test_that("coreNetAnalysis correctly calculates density", {
  result <- coreNetAnalysis(ginp)
  expect_equal(result$net.density, igraph::edge_density(ginp$graph, loops = FALSE))
})

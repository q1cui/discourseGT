# Load the necessary libraries
library(testthat)
library(igraph)
library(GGally)
library(ggplot2)

# Define test data
# Please replace this with your actual data
raw_data_input <- data.frame(
  source = c("Node1", "Node2", "Node3"),
  target = c("Node2", "Node3", "Node1"),
  weight = c(1, 2, 3)
)
project_title <- "Test Project"
attributeData <- data.frame(
  node = c("Node1", "Node2", "Node3"),
  gender = c("Male", "Female", "Male")
)

# Prepare graph object
ginp <- prepareGraphs(raw_data_input, project_title)

# Test: plot1Att returns a list with correct components
test_that("plot1Att returns a list with correct components", {
  result <- plot1Att(ginp, prop = 20, graphmode = "fruchtermanreingold",
                     attribute = attributeData$gender,
                     attribute.label = "Gender",
                     attribute.node.labels = attributeData$node, attribute.nodesize = 12)
  expect_is(result, "list")
  expect_named(result, c("g2plot", "saveDataVar"))
})

# Test: plot1Att returns a ggplot object
test_that("plot1Att returns a ggplot object", {
  result <- plot1Att(ginp, prop = 20, graphmode = "fruchtermanreingold",
                     attribute = attributeData$gender,
                     attribute.label = "Gender",
                     attribute.node.labels = attributeData$node, attribute.nodesize = 12)
  expect_is(result$g2plot, "ggplot")
})

# Test: plot1Att returns saveDataVar as 1
test_that("plot1Att returns saveDataVar as 1", {
  result <- plot1Att(ginp, prop = 20, graphmode = "fruchtermanreingold",
                     attribute = attributeData$gender,
                     attribute.label = "Gender",
                     attribute.node.labels = attributeData$node, attribute.nodesize = 12)
  expect_equal(result$saveDataVar, 1)
})

# And so on for the other tests...

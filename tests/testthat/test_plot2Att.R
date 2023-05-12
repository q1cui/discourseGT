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
  gender = c("Male", "Female", "Male"),
  ethnicity = c("Asian", "Caucasian", "African American")
)

# Prepare graph object
ginp <- prepareGraphs(raw_data_input, project_title)

# Test: plot2Att returns a list with correct components
test_that("plot2Att returns a list with correct components", {
  result <- plot2Att(ginp, prop = 20, graphmode = "fruchtermanreingold",
                     attribute1 = attributeData$gender, attribute2 = attributeData$ethnicity,
                     attribute1.label = "Gender", attribute2.label = "Ethnicity",
                     attribute.node.labels = attributeData$node, attribute.nodesize = 12)
  expect_is(result, "list")
  expect_named(result, c("g2plot", "saveDataVar"))
})

# Test: plot2Att returns a ggplot object
test_that("plot2Att returns a ggplot object", {
  result <- plot2Att(ginp, prop = 20, graphmode = "fruchtermanreingold",
                     attribute1 = attributeData$gender, attribute2 = attributeData$ethnicity,
                     attribute1.label = "Gender", attribute2.label = "Ethnicity",
                     attribute.node.labels = attributeData$node, attribute.nodesize = 12)
  expect_is(result$g2plot, "ggplot")
})

# Test: plot2Att returns saveDataVar as 2
test_that("plot2Att returns saveDataVar as 2", {
  result <- plot2Att(ginp, prop = 20, graphmode = "fruchtermanreingold",
                     attribute1 = attributeData$gender, attribute2 = attributeData$ethnicity,
                     attribute1.label = "Gender", attribute2.label = "Ethnicity",
                     attribute.node.labels = attributeData$node, attribute.nodesize = 12)
  expect_equal(result$saveDataVar, 2)
})

# And so on for the other tests...

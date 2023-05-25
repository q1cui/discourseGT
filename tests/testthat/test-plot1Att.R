# Define test data
# Please replace this with your actual data
df <- sampleData1
project_title <- "Test Plot1 Att"
prepNet <- tabulate_edges(df, silentNodes = 0)
attdata <- attributeData

# Prepare graph object
baseNet <- prepareGraphs(prepNet, project_title = project_title, weightedGraph = TRUE)


# Test: plot1Att returns a list with correct components
test_that("plot1Att returns a list with correct components", {
  result <- plot1Att(baseNet, prop = 20, graphmode = "fruchtermanreingold",
                     attribute = attdata$gender,
                     attribute.label = "Gender",
                     attribute.node.labels = attdata$node, attribute.nodesize = 12)
  expect_type(result, "list")
  expect_named(result, c("g2plot", "saveDataVar"))
})

# Test: plot1Att returns a ggplot object
test_that("plot1Att returns a ggplot object", {
  result <- plot1Att(baseNet, prop = 20, graphmode = "fruchtermanreingold",
                     attribute = attdata$gender,
                     attribute.label = "Gender",
                     attribute.node.labels = attdata$node, attribute.nodesize = 12)
  expect_s3_class(result$g2plot, "ggplot")
})

# Test: plot1Att returns saveDataVar as 1
test_that("plot1Att returns saveDataVar as 1", {
  result <- plot1Att(baseNet, prop = 20, graphmode = "fruchtermanreingold",
                     attribute = attdata$gender,
                     attribute.label = "Gender",
                     attribute.node.labels = attdata$node, attribute.nodesize = 12)
  expect_equal(result$saveDataVar, 1)
})

# And so on for the other tests...

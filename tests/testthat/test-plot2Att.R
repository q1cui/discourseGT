# Define test data
# Please replace this with your actual data
df <- sampleData1
project_title <- "Test Plot1 Att"
prepNet <- tabulate_edges(df, silentNodes = 0)
attdata <- attributeData

# Prepare graph object
baseNet <- prepareGraphs(prepNet, project_title = project_title, weightedGraph = TRUE)

# Test: plot2Att returns a list with correct components
test_that("plot2Att returns a list with correct components", {
  result <- plot2Att(baseNet, prop = 20, graphmode = "fruchtermanreingold",
                     attribute1 = attdata$gender, attribute2 = attdata$ethnicity,
                     attribute1.label = "Gender", attribute2.label = "Ethnicity",
                     attribute.node.labels = attdata$node, attribute.nodesize = 12)
  expect_type(result, "list")
  expect_named(result, c("g2plot", "saveDataVar"))
})

# Test: plot2Att returns a ggplot object
test_that("plot2Att returns a ggplot object", {
  result <- plot2Att(baseNet, prop = 20, graphmode = "fruchtermanreingold",
                     attribute1 = attdata$gender, attribute2 = attdata$ethnicity,
                     attribute1.label = "Gender", attribute2.label = "Ethnicity",
                     attribute.node.labels = attdata$node, attribute.nodesize = 12)
  expect_s3_class(result$g2plot, "ggplot")
})

# Test: plot2Att returns saveDataVar as 2
test_that("plot2Att returns saveDataVar as 2", {
  result <- plot2Att(baseNet, prop = 20, graphmode = "fruchtermanreingold",
                     attribute1 = attdata$gender, attribute2 = attdata$ethnicity,
                     attribute1.label = "Gender", attribute2.label = "Ethnicity",
                     attribute.node.labels = attdata$node, attribute.nodesize = 12)
  expect_equal(result$saveDataVar, 2)
})

# And so on for the other tests...

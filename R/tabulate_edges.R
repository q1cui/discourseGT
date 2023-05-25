# Edge and Weight List Generator from Q/R Format (2 Column)
# discourseGT
# MIT License

# Documentation
#' Process raw order lists from two column format to edge and weight lists
#'
#' Takes raw input that is in a 2 column format/question-and-response format and generates an appropriate edge and weight lists in a combined .csv file. The weights in this function are determined by the number of occurrences a specific edge has occurred in the graph
#'
#' @param input Input in question-and-response format. Must be a data.frame or file name of a .csv
#' @param silentNodes The number of nodes that do not interact with other nodes but are in the group
#' @return Saves the weight and edge lists as a data.frame object or a .csv file to disk.
#' @export
#' @examples
#' df <- sampleData1
#' tabData <- tabulate_edges(df,  silentNodes = 0)
#'

tabulate_edges <- function(input, silentNodes = 0) UseMethod("tabulate_edges")

#' @export
tabulate_edges.default <- function(input, silentNodes = 0) stop_txt()

#' @export
tabulate_edges.character <- function(input, silentNodes = 0) {
  if(!file.exists(input)) {
    stop ("FILE NOT FOUND!", call. = FALSE)
  } else {
    df <- read.csv(input)
    tabulate_edges(df, silentNodes)
  }
}

#' @export
tabulate_edges.data.frame <- function(input, silentNodes = 0){

  # assign data.frame "df" from "input_file"
  df <- input

  # Turn two column input into a single column.
  # Assumes there was an NA value in each row
  df[is.na(df)] <- 0
  df <- df[1] + df[2]

  # create talk turn record
  # duplicate column, shift by 1 up, then delete last row
  df$r <- append(df[2:length(df[,1]),], 1) # the 1 at the end is a placeholder
  df <- df[1:length(df[,1])-1,] # delete last row

  # tabulation: uniquify and count talk turns
  if(silentNodes == 0){
    master <- setNames(aggregate(df[[1]], by=list(df[[1]], df[[2]]), FUN=length),
                      c("source", "target", "weight"))
  } else if(silentNodes > 0){
    master <- setNames(aggregate(df[[1]], by=list(df[[1]], df[[2]]), FUN=length),
                       c("source", "target", "weight"))
    baseSilentNode <- max(master["source"], master["target"]) + 1
    c <- 0

    while(c < silentNodes){
      dfSN <- data.frame(source = c(baseSilentNode), target = c(baseSilentNode), weight = c(1))
      master <- dplyr::bind_rows(master, dfSN)
      baseSilentNode <- baseSilentNode + 1
      c <- c + 1
    }
  }

  # Return objects
  # Assign variable for the saveData function
  saveDataVar <- 4
  # Run the actual return object
  objectsReturned <- list(master = master,
                          input = input,
                          saveDataVar = saveDataVar)
  return(objectsReturned)
}


stop_txt <- function() {
  stop_txt = "Invalid input type. \nPlease input file path as character or input data.frame directly."
  stop(stop_txt, call. = FALSE)
}

# generic_char <- function(input, fun, ...) {
#   if(!file.exists(input)) {
#     stop ("FILE NOT FOUND!", call. = FALSE)
#   } else {
#     df <- read.csv(input)
#     fun(df)
#   }
# }

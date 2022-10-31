# Edge List Generator from Q/R Format (2 Column)
# discourseGT
# MIT License

# Documentation
#' Process raw order lists from two column format to edge lists
#'
#' Takes raw input that is in a 2 column format/question-and-response format and generates an appropriate edge lists in a combined .csv file.
#'
#' @param input_file Source of the raw input file. Must be in a .csv format
#' @param iscsvfile Sets if the input_file is a csv file or a R data frame object
#' @return Saves the weight and edge lists as a data.frame object or a .csv file to disk.
#' @examples
#' df <- sampleData1
#' prepNet <- edgelist_raw(df, iscsvfile = FALSE)
#'

edgelist_raw <- function(input_file, iscsvfile = TRUE){

  # read input file into data frame
  ifelse(iscsvfile == TRUE, df <- read.csv(input_file), df <- input_file)

  # Turn two column input into a single column.
  # Assumes there was an NA value in each row
  df[is.na(df)] <- 0
  df <- df[1] + df[2]

  # create talk turn record
  # duplicate column, shift by 1 up, then delete last row
  df$r <- append(df[2:length(df[,1]),], 1) # the 1 at the end is a placeholder
  df <- df[1:length(df[,1])-1,] # delete last row

  # Return objects
  # Assign variable for the saveData function
  saveDataVar <- 5
  # Run the actual return object
  objectsReturned <- list(df = df,
                          input_file = input_file,
                          saveDataVar = saveDataVar)
  return(objectsReturned)

}

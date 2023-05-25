# Edge List Generator from Q/R Format (2 Column)
# discourseGT
# MIT License

# Documentation
#' Process raw order lists from two column format to edge lists
#'
#' Takes raw input that is in a 2 column format/question-and-response format and generates an appropriate edge lists in a combined .csv file.
#'
#' @param input_file Source of the raw input file. Must be in a .csv format
#' @return Saves the weight and edge lists as a data.frame object or a .csv file to disk.
#' @export
#' @examples
#' df <- sampleData1
#' prepNet <- edgelist_raw(df)
#'

edgelist_raw <- function(input_file) UseMethod("edgelist_raw")

#' @export
edgelist_raw.default <- function(input_file) {
  stop_txt = "Invalid input type. \nPlease input file path as character or input data.frame directly."
  stop(stop_txt, call. = FALSE)
}

#' @export
edgelist_raw.character <- function(input_file) {
  if(!file.exists(input_file)) {
    stop ("FILE NOT FOUND!", call. = FALSE)
  } else {
    df <- read.csv(input_file)
    edgelist_raw(df)
  }
}

#' @export
edgelist_raw.data.frame <- function(input_file){

  # assign data.frame "df" from "input_file"
  df <- input_file

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

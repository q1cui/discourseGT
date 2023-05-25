# Create graphs for non-graphical parameters
# discourseGT
# MIT License

# Uses the ggplot2 library to create the following plots:
# Questions per hour verus responses per hour
# Number of episodes by frequency
# Determine normalized turn ratio

# Documentation
#' Plot non-graphical parameters
#'
#' Creates plots for non-graph theory parameters for episode lengths, questions per hour versus responses per hour, and normalized turn ratio
#'
#' @param data Original raw input data in ordered question/response 2 column format
#' @param convoMinutes Time length of the conversation in the graph in minutes
#' @param silentNodes The number of nodes that do not interact with other nodes but are in the group
#' @return Creates a plot returning the questions per hour versus responses per hour, frequency plot of the number of episodes, and normalized turn ratio
#' @export
#' @examples
#' df <- sampleData1
#' plotNGTData(df, convoMinutes = 60, silentNodes = 0)

plotNGTData <- function(data, convoMinutes, silentNodes = 0) UseMethod("plotNGTData")

#' @export
plotNGTData.default  <- function(data, convoMinutes, silentNodes = 0) stop_txt()

#' @export
plotNGTData.character  <- function(data, convoMinutes, silentNodes = 0) {
  if(!file.exists(data)) {
    stop ("FILE NOT FOUND!", call. = FALSE)
  } else {
    df <- read.csv(data)
    plotNGTData(df, convoMinutes, silentNodes)
  }
}

#' @export
plotNGTData.data.frame <- function(data, convoMinutes, silentNodes = 0){

  #Create a copy of raw file for processing
  raw <- data

  #colnames(raw)[colnames(raw)=="ï..q"] <- "q"

  ##### Histogram for Frequency of Episodes #####
  #Initalize empty columns
  #raw$select <- NA
  raw$counter <- NA
  raw$round <- NA

  #Retrieve total number of rows
  totalrows <- nrow(raw)

  #Classify which rows are start of new episode
  #11 is new episode defined by new question
  #99 is successive responses to question
  #raw$select[is.na(raw$q) == FALSE] <- 11
  #raw$select[is.na(raw$r) == FALSE] <- 99

  #Initalize necessary variables outside of loop
  #Episode number counter
  q <- 0

  #Loop through data and count number of episodes(q) and episode index number per each episode (n)
  for (i in 1:totalrows){
    if(is.na(raw$ep_start[i])==FALSE & is.na(raw$ep_cont[i]) == TRUE){
      n <- 1
      q <- q+1
      raw$counter[i] <- n
      raw$round[i] <- q
    }
    if(is.na(raw$ep_start[i]) == TRUE & is.na(raw$ep_cont[i]) == FALSE){
      n <- n + 1
      raw$counter[i] <- n
      raw$round[i] <- q

    }
  }

  #Collect the number of episodes
  eps_list <- unique(raw$round)
  eps <- max(eps_list)

  #Initalize List
  eps_len_list <- NULL

  #Map each episode number with the length of each individual episodes
  for(var in eps_list){
    #Create a temporary data frame
    temp <- subset(raw, raw$round == var)
    #Retreive the max counter value from the episode
    maxCount <- max(temp$counter)
    eps_len_list <- c(eps_len_list, maxCount)
  }

  #Create a table with the episode number and max number of occurances
  eps_master <- data.frame(eps_list, eps_len_list)

  #Count number of occurances that each length appears and store as data frame
  eps_st <- data.frame(table(eps_master$eps_len_list))
  colnames(eps_st)[colnames(eps_st)=="Var1"] <- "episode_length"

  # modify the df so that there is a continuous x-axis
  max <- as.integer(as.vector(eps_st$episode_length[length(eps_st$episode_length)]))
  missingNodes <- data.frame("episode_length" = factor(as.vector(1:max)), "Freq" = as.vector(as.integer(0)))

  eps_st <- dplyr::bind_rows(eps_st, missingNodes)
  eps_st <- aggregate(Freq~episode_length, data = eps_st, FUN = sum)
  eps_st <- eps_st[order(as.integer(eps_st$episode_length)),]
  row.names(eps_st) <- 1:nrow(eps_st)

  #Create a histogram plot of lengths
  #View all color fill options through this command: RColorBrewer::display.brewer.all()
  #Color can be an option for the function, else go with the default of blue
  eps_plot <- ggplot2::ggplot(eps_st, ggplot2::aes(x = reorder(episode_length, 1:max), weight = Freq)) + ggplot2::geom_bar(show.legend = FALSE) + ggplot2::xlab('Length of Episodes') + ggplot2::ylab('Frequency of Episodes') + ggplot2::theme(text = ggplot2::element_text(size=15), panel.background = ggplot2::element_blank(), panel.grid.minor = ggplot2::element_line(colour="gray85", size=0.25), panel.grid.major = ggplot2::element_line(colour="gray85", size=0.25), axis.text.x = ggplot2::element_text(angle = 90, hjust = 1)) + ggplot2::scale_y_continuous(limits = c(0, NA))
  #Displays the plot to memory
  #print(eps_plot)

  ##### Question per hour versus Responses per hour Plots #####
  #Tally all unique users
  #Two rounds are performed to ensure that all users are retreived in the event that one participant may never interact in one column
  #From question column
  participants_raw1 <- unique(raw$ep_start)
  participants1 <- participants_raw1[is.na(participants_raw1) == FALSE]
  #From response column
  participants_raw2 <- unique(raw$ep_cont)
  participants2 <- participants_raw2[is.na(participants_raw2) == FALSE]
  #Merge unique participant count from both question and response columns
  participants <- unique(participants1, participants2)

  #Get table of questions
  qcount <- data.frame(table(raw$ep_start))
  #Get table of responses
  rcount <- data.frame(table(raw$ep_cont))

  # Check for silent nodes & modify the master table if necessary
  if(silentNodes > 0){
    baseSilentNode <- max(as.numeric(as.character(qcount[,1])), as.numeric(as.character(rcount[,1]))) + 1

    z <- 0
    while(z < silentNodes){
      dfSN <- data.frame(Var1 = c(as.character(baseSilentNode)), Freq = c(0))
      qcount <- dplyr::bind_rows(qcount, dfSN)
      rcount <- dplyr::bind_rows(rcount, dfSN)
      baseSilentNode <- baseSilentNode + 1
      z <- z + 1
    }
  }

  #Merge the questions and responses of each participant together
  #Checks to see if there are both ep_starts and ep_conts or if there is a missing column (all of one, for instance)
  if((length(qcount) == 2) & (length(rcount) == 2)){
    count_master <- merge(qcount, rcount, by = "Var1", all.x = TRUE, all.y = TRUE)
  }
  else if((length(qcount) == 2) & (length(rcount) == 1)){
    count_master <- qcount
    colnames(count_master)[colnames(count_master)=="Freq"] <- "Freq.x"
    count_master$Freq.y <- 0
    count_master <- count_master[, c("Var1", "Freq.x", "Freq.y")]
  }
  else if((length(qcount) == 1) & (length(rcount) == 2)){
    count_master <- rcount
    colnames(count_master)[colnames(count_master)=="Freq"] <- "Freq.y"
    count_master$Freq.x <- 0
    count_master <- count_master[, c("Var1", "Freq.x", "Freq.y")]
  }

  colnames(count_master)[colnames(count_master)=="Var1"] <- "participant"
  colnames(count_master)[colnames(count_master)=="Freq.x"] <- "ep_start"
  colnames(count_master)[colnames(count_master)=="Freq.y"] <- "ep_cont"
  count_master <- count_master[order(count_master$participant),]

  #Change all NAs to 0 in the data, so results are plotted
  count_master$ep_start[is.na(count_master$ep_start)] <- 0
  count_master$ep_cont[is.na(count_master$ep_cont)] <- 0

  #Calculate talk-turns of each node & put into count_master
  count_master$total_count <- rowSums(count_master[,c("ep_start","ep_cont")], na.rm = TRUE)
  count_master$total_edges <- count_master$total_count * 2

  #Subtract out extra edges
  #Testing to see if the ep_start column has the first node & removing an edge if necessary
  first_ep_start <- raw$ep_start[1]
  if(!is.na(first_ep_start)){
    r = 1
    for(e in count_master$participant){
      if(e == first_ep_start){
        count_master$total_edges[r] = count_master$total_edges[r] - 1

      }
      r = r + 1
    }
  }

  #Testing to see if the ep_cont column has the first node & removing an edge if necessary
  first_ep_cont <- raw$ep_cont[1]
  if(!is.na(first_ep_cont)){
    r = 1
    for(e in count_master$participant){
      if(e == first_ep_cont){
        count_master$total_edges[r] = count_master$total_edges[r] - 1

      }
      r = r + 1
    }
  }

  #Testing to see if the ep_start column has the last node & removing an edge if necessary
  last_ep_start <- tail(raw$ep_start, n = 1)
  if(!is.na(last_ep_start)){
    r = 1
    for(e in count_master$participant){
      if(e == last_ep_start){
        count_master$total_edges[r] = count_master$total_edges[r] - 1

      }
      r = r + 1
    }
  }

  #Testing to see if the ep_cont column has the last node & removing an edge if necessary
  last_ep_cont <- tail(raw$ep_cont, n = 1)
  if(!is.na(last_ep_cont)){
    r = 1
    for(e in count_master$participant){
      if(e == last_ep_cont){
        count_master$total_edges[r] = count_master$total_edges[r] - 1

      }
      r = r + 1
    }
  }

  #Initialized the edge_by_part column
  count_master$edge_by_part <- 0

  #Determine starting edge points in ep_start
  e <- 1
  for(e in 1:length(raw$ep_start)){
    if(!is.na(raw$ep_start[e])){
      index <- match(raw$ep_start[e], count_master$participant)
      count_master$edge_by_part[index] <- count_master$edge_by_part[index] + 1
    }
  }
  if(!is.na(tail(raw$ep_start, n = 1))){
    final_ep_start <- tail(raw$ep_start, n = 1)
    index <- match(final_ep_start, count_master$participant)
    count_master$edge_by_part[index] = count_master$edge_by_part[index] - 1

  }

  #Determine starting edge points in ep_cont
  e <- 1
  for(e in 1:length(raw$ep_cont)){
    if(!is.na(raw$ep_cont[e])){
      index <- match(raw$ep_cont[e], count_master$participant)
      count_master$edge_by_part[index] <- count_master$edge_by_part[index] + 1

    }
  }
  if(!is.na(tail(raw$ep_cont, n = 1))){
    final_ep_cont <- tail(raw$ep_cont, n = 1)
    index <- match(final_ep_cont, count_master$participant)
    count_master$edge_by_part[index] = count_master$edge_by_part[index] - 1

  }

  #Get time as input from user as minutes
  timeMin <- convoMinutes
  timeHours <- timeMin/60

  #Find rate
  count_master$ep_starts_hour <- count_master$ep_start/timeHours
  count_master$ep_conts_hour <- count_master$ep_cont/timeHours

  #Create plot for questions per hour versus responses per hour from data frame object
  qvr_plot <- ggplot2::ggplot(count_master, ggplot2::aes(x=ep_starts_hour, y = ep_conts_hour, label = participant)) + ggplot2::geom_point(na.rm = TRUE) + ggplot2::xlab('Episode Starts per hour') + ggplot2::ylab('Episode Continuations per hour') + ggrepel::geom_label_repel() + ggplot2::theme(text = ggplot2::element_text(size=15), panel.background = ggplot2::element_blank(), panel.grid.minor = ggplot2::element_line(colour="gray85", size=0.25), panel.grid.major = ggplot2::element_line(colour="gray85", size=0.25)) + ggplot2::scale_y_continuous(limits = c(0, NA)) + ggplot2::scale_x_continuous(limits = c(0, NA))
  #Displays the plot to memory
  #print(qvr_plot)


  ##### Normalized Turn Ratios #####
  #Find total number of talk turns
  total_turns <- sum(count_master$total_count) - 1

  #Find total number of actual participants
  part_len <- length(count_master$participant)

  #Determine fair ratio based on total responses and actual participants
  fair_ratio <- total_turns/part_len

  #Calculate normalized turn ratios for all participants
  count_master$normalized_turn_ratio <- count_master$edge_by_part/fair_ratio

  #Calculate the Shannon Diversity Index for all participants
  n <- 1
  total_edges <- sum(count_master$total_edges)
  while(n < length(count_master$participant) + 1){
    prop <- count_master$total_edges[n]/total_edges
    nat_log_prop <- log(prop)
    ind_SDI <- prop * nat_log_prop

    if(is.nan(ind_SDI)){
      count_master$ind_SDI[n] <- 0
    } else {
      count_master$ind_SDI[n] <- ind_SDI
    }

    n <- n + 1
  }

  count_master$shannon_diversity_index <- -1* sum(count_master$ind_SDI)
  count_master$SDI_evenness <- count_master$shannon_diversity_index/(log(length(count_master[[1]])))

  #Create plot of the normalized turn ratios
  #First, create a subset of the necessary columns into a new data frame
  temp_plot <- data.frame(count_master$participant, count_master$normalized_turn_ratio)
  colnames(temp_plot)[colnames(temp_plot)=="count_master.participant"] <- "participant"
  colnames(temp_plot)[colnames(temp_plot)=="count_master.normalized_turn_ratio"] <- "normalized_turn_ratio"
  #Second, sort the data based on the length of the normalized turn ratios
  temp_plot$participant <- factor(temp_plot$participant, levels = temp_plot$participant[order(temp_plot$normalized_turn_ratio, decreasing = TRUE)])
  #Third, create the grouping for the line attribute for ggplot
  temp_plot$group <- 1
  #Fourth, create a plot based on the sorted data
  ntr_plot <- ggplot2::ggplot(temp_plot, ggplot2::aes(x = participant, y = normalized_turn_ratio, group = group, color = group)) + ggplot2::geom_point(show.legend = FALSE) + ggplot2::geom_line(show.legend = FALSE) + ggplot2::theme(text = ggplot2::element_text(size=15), panel.background = ggplot2::element_blank(), panel.grid.minor = ggplot2::element_line(colour="gray85", size=0.25), panel.grid.major = ggplot2::element_line(colour="gray85", size=0.25)) + ggplot2::xlab('Participants') + ggplot2::ylab('Normalized Turn Ratio') + ggplot2::scale_y_continuous(limits = c(0, NA))
  #Displays the plot to memory
  #print(ntr_plot)

  # Split count_master up into visually-appealing data.frames
  count_master_sub1 <- data.frame("participant" = count_master$participant, "ep_start" = count_master$ep_start, "ep_cont" = count_master$ep_cont, "total_count" = count_master$total_count, "total_edges_in_out" = count_master$total_edges, "edge_by_part" = count_master$edge_by_part, "ep_starts_hour" = count_master$ep_starts_hour, "ep_conts_hour" = count_master$ep_conts_hour)
  count_master_plotA <- data.frame("length_of_ep" = eps_st$episode_length, "freq_of_ep" = eps_st$Freq)
  count_master_sub2 <- data.frame("participant" = count_master$participant, "normalized_turn_ratio" = count_master$normalized_turn_ratio, "indv_SDI_arg" = count_master$ind_SDI, "SDI" = count_master$shannon_diversity_index, "SEI" = count_master$SDI_evenness)

  ##### Return Objects from Function #####
  # For the new saveData function
  saveDataVar <- 3
  # Returns multiple outputs from the functions
  objectsReturned <- list(ngt_std_stats1 = count_master_sub1,
                          ngt_std_stats2 = count_master_plotA,
                          ngt_adv_stats = count_master_sub2,
                          episodes_plot = eps_plot,
                          qvr_plot = qvr_plot,
                          ntr_plot = ntr_plot,
                          saveDataVar = saveDataVar)
  return(objectsReturned)
}

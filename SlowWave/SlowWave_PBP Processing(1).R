# Takes point data from .eeg files exported from Neuroscan
# (1) Adds point, time point, and trial information.
# (2) Cuts file at time points of interest.
# (3) Removes rejected files and adds accuracy information.
# (4) creates additional files for each subject, and a global file, with number of rejected and incorrect trials.

require(magrittr)

# Doesn't include trials that are rejected because of artifacts
# Only includes correct trials

# Not using an R project. So set a directory.
setwd("C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing")
# For easier specification later.
path = "C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"

# Headers are strange for data file so we want to make our own.
# Make a .txt file of "pretty" column names manually
# Make sure the electrodes are in the right order (has to include all electrodes that were exported by SCAN)
elec = read.delim(paste(path, "electrodesFromScan.txt", sep=""), header = F)
elec = as.character(elec$V1) # converts to vector of strings
electrodeList = c("F3", "Fz", "F4", "FC3", "FCz", "FC4", "C3", "Cz", "C4") # specify electrodes that you want quantified

# Creating subject list.
# Creating subject numbers with 3 places using "str_pad".
#library(stringr)
#a <- 1:142
#sublist <- str_pad(a, 3, pad = "0")
#Removing bad subjects.
#bad <- (36:58)
#bad <- str_pad(bad, 3, pad = "0")
#badsub <- c("020", "031", bad, "064", "075", "078", "116", "131", "139")
#sublist <- sublist[!sublist %in% badsub]
#length(sublist)

#sublist <- c(002, 005, 008, 014, 019, 032, 036, 043, 046, 055, 057, 059, 060, 065, 072, 074, 078, 091,
# 092, 100, 108, 115, 117, 135, 137, 004, 013, 016, 017, 021, 023, 024, 027, 030,
# 037, 039, 040, 042, 051, 053, 054, 056, 061, 064, 068, 070, 071, 084, 104, 105, 112, 129)

sublist <- c("002", "005", "008", "014", "019", "032",     
             "055", 
             "059", "060", "065", 
             "072", "074",        
             "091",
             "092", "100", "108", "115", "117", "135", "137", "004", "013", "016", 
             "017", "021", "023", "024", "027", "030",
             "061", 
             "068", "070", "071", "084", "104", "105", "112", "129")
#bad <- (36:58)
#bad <- str_pad(bad, 3, pad = "0")
#badsub <- c("020", "031", bad, "064", "075", "078", "116", "131", "139")
#sublist <- sublist[!sublist %in% badsub]
length(sublist)

#numSubjects = 59 # number of subjects included in analysis

beginEpoch = -100 # how many ms before onset does epoch start
endEpoch = 1200 # how many ms after onset does epoch end
lengthEpoch = endEpoch - beginEpoch + 1

# If you want to specify different windows to quantify ERP in for each subject, create excel file 
# separately specifying beginning and end of time window for each subject
#subInts = read.delim(paste(path, "subjectP2QuantIntervals.txt", sep=""), header = T)
# Otherwise, specify interval you want to quantify within
intBegin = 600
intEnd = 1150

NumAcceptedTrials = NULL # will become file that has how many trials were accepted for each subject


for (k in sublist) { # If you're not using all subjects, you can specify a list of which subjects for which
                     # you want to make these files and use that instead of 1:numSubjects
  
  # Read in trial-by-trial point data
  temp = read.delim(paste(path, "SCAN_Output/_", k, "_TBT_2.dat", sep=""), skip=2, header=FALSE, colClasses = "numeric") 
  names(temp) = elec # replace column names
  temp = temp[,1:length(elec)] # get rid of last NA column
  
  numTrials = nrow(temp)/lengthEpoch # figures out how many trials are in data
  
  # add identifiers
  temp$Subject = k
  temp$Points = rep(1:lengthEpoch, numTrials)
  temp$Time = rep(beginEpoch:endEpoch, numTrials)
  temp$Trial = rep(1:numTrials, each = lengthEpoch)
 
  # set quant interval for subject
    #intBegin = subInts$Begin[subInts$Subject == k]
    #intEnd = subInts$End[subInts$Subject == k]
    #intLength = intEnd-intBegin + 1
  
  # select only points of interest
  temp = temp[temp$Time >= intBegin & temp$Time <= intEnd,]
  
  # read in file of rejected trials
  rej = read.delim(paste(path, "SCAN_Output/_", k, "_REJ_2.dat", sep=""), header=FALSE, colClasses = "numeric") 
  
  # read in event file to add whether response was correct, condition, etc.
  ev2 = read.delim(paste(path, "Event_Stimulus_Files/", k, "flk_rev.ev2", sep=""), header=FALSE)
  

  for (i in 1:numTrials) {
    # add rejection status from Scan: 0 = reject, 1 = accept
    temp$Rejected[temp$Trial == i] = rej[i,1] 
    # add whether response was correct:  2 = correct, 1 = incorrect, 3 = timeout
    temp$Correct[temp$Trial == i] = ev2$V4[ev2$V1 == i] 
    # add trigger codes
    temp$Trigger[temp$Trial == i] = ev2$V2[ev2$V1 == i] 
  }

  
  # Calculate the number of trials that were correct and rejected due to
  # EEG artifacts and how many trials in total that were accepted (no artifacts)
  temp.select = temp[temp$Rejected == 1,] # selects subset of just accepted trials
  
  numAccepted = length(unique(temp.select$Trial))
  numAccTemp = data.frame(Subject = k,
                          numTrials = numTrials, # number of trials recorded total
                          numArtifact = numTrials - sum(rej), # number of trials that were rejected because of EEG artifacts
                          numAccept = numAccepted, # total number of accepted trials to be used for averages
                          numIncorrect = length(unique(temp$Trial[!(temp$Correct == 1)]))) # number of trials where subject had incorrect reponse
                          
  NumAcceptedTrials = rbind(NumAcceptedTrials, numAccTemp)
  
  # write file (only correct trials that haven't been rejected for artifacts, only quant interval of interest)
  write.table(temp.select, paste(path, "Created by R_ArtRej/SlowWave/", k, "_SlowWave_PBP_(600-1150).txt", sep=""),
              sep="\t", row.names = F)
  
  write.table(numAccTemp, paste(path,"Created by R_ArtRej/SlowWave/", k, "_SlowWave_NumberOfAcceptedTrials.txt", sep=""), sep = "\t", row.names = F)
}

write.table(NumAcceptedTrials, paste(path,"Created by R_ArtRej/SlowWave/SlowWave_NumberOfAcceptedTrials.txt", sep=""), sep = "\t", row.names = F)

# Note: these files still don't have trial condition information in them. Need to use event file to add that info



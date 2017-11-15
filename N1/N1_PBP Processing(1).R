# Takes point data from .eeg files exported from Neuroscan
# (1) Adds point, time point, and trial information.
# (2) Cuts file at time points of interest.
# (3) Removes rejected files andaq adds accuracy information.
# (4) creates additional files for each subject, and a global file, with number of rejected and incorrect trials.

require(magrittr)

setwd("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing")
path = "C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"

elec = read.delim(paste(path, "electrodesFromScan_N1.txt", sep=""), header = F)
elec = as.character(elec$V1) # converts to vector of strings
electrodeList = c("P3", "Pz", "P4", "01", "O2") # specify electrodes that you want quantified

sublist <- c("002", "005", "008", "014", "019", "032",    "055", "059", "060", "065", 
             "072", "074",         "091",  "092", "100", "108", "115", "117", "135", "137", 
             "004", "013", "016", 
             "017", "021", "023", "024", "027", "030",  "061", 
             "068", "070", "071", "084", "104", "105", "112", "129")

length(sublist)

beginEpoch = -100 # how many ms before onset does epoch start
endEpoch = 1200 # how many ms after onset does epoch end
lengthEpoch = endEpoch - beginEpoch + 1

intBegin = 125
intEnd = 220

NumAcceptedTrials = NULL # will become file that has how many trials were accepted for each subject


for (k in sublist) { # If you're not using all subjects, you can specify a list of which subjects for which
                     # you want to make these files and use that instead of 1:numSubjects
  
  # Read in trial-by-trial point data
  temp = read.delim(paste(path, "SCAN_Output_Rev_N1/", k, "_TBT_2.dat", sep=""), skip=2, header=FALSE, colClasses = "numeric") 
  names(temp) = elec # replace column names
  temp = temp[,1:length(elec)] # get rid of last NA column
  
  numTrials = nrow(temp)/lengthEpoch # figures out how many trials are in data
  
  # add identifiers
  temp$Subject = k
  temp$Points = rep(1:lengthEpoch, numTrials)
  temp$Time = rep(beginEpoch:endEpoch, numTrials)
  temp$Trial = rep(1:numTrials, each = lengthEpoch)
 
  temp = temp[temp$Time >= intBegin & temp$Time <= intEnd,]
  
  rej = read.delim(paste(path, "SCAN_Output_Rev_N1/", k, "_REJ_2.dat", sep=""), header=FALSE, colClasses = "numeric") 
  ev2 = read.delim(paste(path, "Event_Stimulus_Files/Reg&Mod_Event_Files/", k, "flk_rev.ev2", sep=""), header=FALSE)
  

  for (i in 1:numTrials) {
    temp$Rejected[temp$Trial == i] = rej[i,1] 
    temp$Correct[temp$Trial == i] = ev2$V4[ev2$V1 == i] 
    temp$Trigger[temp$Trial == i] = ev2$V2[ev2$V1 == i] 
  }

  
  temp.select = temp[temp$Rejected == 1,] # selects subset of just accepted trials
  
  numAccepted = length(unique(temp.select$Trial))
  numAccTemp = data.frame(Subject = k,
                          numTrials = numTrials, # number of trials recorded total
                          numArtifact = numTrials - sum(rej), # number of trials that were rejected because of EEG artifacts
                          numAccept = numAccepted, # total number of accepted trials to be used for averages
                          numIncorrect = length(unique(temp$Trial[!(temp$Correct == 1)]))) # number of trials where subject had incorrect reponse
                          
  NumAcceptedTrials = rbind(NumAcceptedTrials, numAccTemp)
  
  # write file (only correct trials that haven't been rejected for artifacts, only quant interval of interest)
  write.table(temp.select, paste(path, "Created by R_ArtRej/N1/", k, "_N1_PBP_(125-220).txt", sep=""),
              sep="\t", row.names = F)
  
  write.table(numAccTemp, paste(path,"Created by R_ArtRej/N1/", k, "_N1_NumberOfAcceptedTrials.txt", sep=""), sep = "\t", row.names = F)
}

write.table(NumAcceptedTrials, paste(path,"Created by R_ArtRej/N1/N1_NumberOfAcceptedTrials.txt", sep=""), sep = "\t", row.names = F)

# Note: these files still don't have trial condition information in them. Need to use event file to add that info



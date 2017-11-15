


#####################################################################
###               Mergine RT, N2, SlowWave datsets                ###
#####################################################################
setwd("C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej")
path = "C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/"

#Reading in the RT, N2, SlowWave data sets. The ERP sets have had incorrect and art rejected trials removed.
RTdat = read.delim(paste(path, "RT/","FlankerRT_forR.txt", sep = ""))

N2dat = read.delim(paste(path, "N2/","AllSubs_TBTaverages_N2_Correct_withPrevious.txt", sep = ""))
                   
SlowWavedat = read.delim(paste(path, "SlowWave/", "SlowWave_TBT_Cond_Wprev_3subs.txt", sep = ""))

colnames(N2dat) <- c("Subject", "Trial", "Electrode", "N2curr", "Acc", "Condition", "notFirst", 
                  "prevCondTrigger", "prevCondAcc", "prevCond", "TrialCondition")

colnames(SlowWavedat) <- c("Subject", "Trial", "Electrode", "SlowWavecurr", "Acc", "Condition", "notFirst", 
                           "prevCondTrigger", "prevCondAcc", "prevCond", "TrialCondition")

#Merging just N2 and SlowWave first. Can's use "by" if the varibles aren't in both datasets.
N2_SlowWave_dat <- merge(N2dat, SlowWavedat, by = c("Subject", "Trial", "Electrode",
                                                       "Acc", "Condition", "notFirst", 
                                                       "prevCondTrigger", "prevCondAcc", "prevCond", "TrialCondition"))

head(N2_SlowWave_dat)
tail(N2_SlowWave_dat)

###RT data##
#Trial variable repeats 1:100 for each of the 8 blocks. Need to format Trial to be 1:800 for merge with ERP data sets.
#Subject 92 only has 700 trials so I add trial info to 92 separately and then rbind at the end.
#Makind data set with only 92.
Sub92 <- RTdat[RTdat$Subject == 92,]
#Trial is 1 through 700.
Trial <-  rep(1:700)
#Add Trial column to the end of 92 dataset.
Sub92 <- cbind(Sub92, Trial)

#Making data set without 92.
RTdat <- RTdat[RTdat$Subject != 92,]
#Trial is now 1 through 800. Had to use the same name (e.g., "Trial) here and above since the names need to be the same for rbind below.
Trial <-  rep(1:800, length(unique(RTdat$Subject)))
#Add Trial column to the end of RT dataset.
RTdat <- cbind(RTdat, Trial)

#Attach 92 to the dataset without 92.
RTdat <- rbind(RTdat, Sub92)

#Remove variables not of interest.
RTdatshort <- RTdat[, c(2,27,28)]


#Merging RTdat with ERPdat. Using the previously merged RT data since it seems like the merge BY
#variables need to be in each dataset. So doing the ERPs first allows us to collapse the 
#variables that are common to the ERP data sets but not common to the RT data set.
#Note: it turns out that "all.y=TRUE" was not needed to maintain the columns in the ERP dataset that weren't contained in the RT data set.
#I'm not sure why I didn't need it.
RT_N2_SlowWave_dat_allERP <- merge(RTdatshort, N2_SlowWave_dat, by = c("Subject", "Trial")) 

#Remove "notfirst" and precCondTrigger.
Alldat <- RT_N2_SlowWave_dat_allERP[,c(-7,-8)]

colnames(Alldat) <- c("Subject", "Trial", "RT", "Electrode", "AccCurr", "CondCurr",
                           "AccPrev", "CondPrev", "Cell", "N2Curr", "SlowWaveCurr")


#####################################################################
###               Adding previous SlowWave variable               ###
#####################################################################

#Decided to just remove the first row of the data and the last row of the SlowWave variable to add SlowWavePrev.   
#Tried using just the relationships between the trials to do this but ran into problems. Wasted almost an entire day on this.
#Need to sort first.
AlldatSort <- Alldat[order(Alldat$Subject, Alldat$Trial, Alldat$Electrode),] 
#Saving just the SlowWave.
SlowWaveSolo <- AlldatSort$SlowWaveCurr          
#Forcing to a dataframe.
SlowWaveSolo <- data.frame(SlowWaveSolo)
#Removing the last row so that row sizes are equal.
SlowWaveSolo <- SlowWaveSolo[-196785,]

#Removing the first row from the data.
AlldatMinus1 <- AlldatSort[-1,]

#Adding the SlowWave collumn.
AlldatMinus1Prev <- cbind(AlldatMinus1, SlowWaveSolo)


#####################################################################
### Removing trial where the previous trial was artifcat rejected ###
#####################################################################

####### Using Rej file from SCAN for this. Tried another way but couldn't get it to work. ###########################
sublist <- c(2, 5, 8, 14, 19, 32,     
             55, 
             59, 60, 65, 
             72, 74,        
             91,
             92, 100, 108, 115, 117, 135, 137, 4, 13, 16, 
             17, 21, 23, 24, 27, 30,
             61, 
             68, 70, 71, 84, 104, 105, 112, 129)

path2 <- "C:/Users/psycworks/Desktop//Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"

for (h in sublist) {
  #h <- 2
  # read in file of rejected trials
  rej <- read.delim(paste(path2, "SCAN_Output/_", h, "_REJ_2.dat", sep=""), header=FALSE, colClasses = "numeric")
  rej <- data.frame(rej)
  length(rej[,1])
  Trialcol <- 1:length(rej[,1])
  rej <- cbind(Trialcol, rej)
  colnames(rej) <- c("TrialCol", "Status")
  SubjectTemp <- AlldatMinus1Prev[AlldatMinus1Prev$Subject == h,]
  for (i in unique(SubjectTemp$Trial)) {
    # add rejection status from Scan: 0 = reject, 1 = accept
    AlldatMinus1Prev$Rej[AlldatMinus1Prev$Subject == h & AlldatMinus1Prev$Trial == i] <- rej$Status[rej$TrialCol == i-1] 
  }
}

colnames(AlldatMinus1Prev) <- c("Subject", "Trial", "RT", "Electrode", "AccCurr", "CondCurr",
                      "AccPrev", "CondPrev", "Cell", "N2Curr", "SlowWaveCurr", "SlowWavePrev", "RejStatus")

write.table(AlldatMinus1Prev, paste(path, "RT_N2_SlowWave_SlowWavePrev.txt", sep=""), sep = "\t", row.names = F)






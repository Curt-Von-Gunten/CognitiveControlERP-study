


#####################################################################
###               Merging RT, N2, SlowWave datsets                ###
#####################################################################
setwd("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej")
path = "C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/"

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

setwd("C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej")
path = "C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/"

sublist <- c(2, 5, 8, 14, 19, 32,     
             55, 
             59, 60, 65, 
             72, 74,        
             91,
             92, 100, 108, 115, 117, 135, 137, 4, 13, 16, 
             17, 21, 23, 24, 27, 30,
             61, 
             68, 70, 71, 84, 104, 105, 112, 129)

electrodeList = c("F3", "Fz", "F4", "FC3", "FCz", "FC4", "C3", "Cz", "C4")

# Hannah
#h <- 2
#i <- 8
#j <- "Fz"
Alldat$SlowWavePrev = NA
for (h in sublist){
  # h <- 2
  SubjectTemp <- Alldat[Alldat$Subject == h,]
  trials = sort(unique(SubjectTemp$Trial))
  prevTrials = trials-1
  for (i in trials[prevTrials %in% trials]) {
    for (j in electrodeList){
      Alldat$SlowWavePrev[Alldat$Subject == h & Alldat$Electrode == j & Alldat$Trial == i] <- Alldat$SlowWaveCurr[Alldat$Subject == h & Alldat$Electrode == j & Alldat$Trial == i-1]
    }
  }
}

write.table(Alldat, paste(path, "RT_N2_SlowWave_SlowWavePrev_v.2.txt", sep=""), sep = "\t", row.names = F)





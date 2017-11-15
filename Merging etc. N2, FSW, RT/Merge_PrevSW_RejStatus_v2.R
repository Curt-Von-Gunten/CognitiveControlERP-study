
setwd("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej")
path = "C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/"

RTdat = read.delim(paste(path, "RT/","FlankerRT_forR.txt", sep = ""))

N2dat = read.delim(paste(path, "N2/","AllSubs_TBTaverages_N2_Correct_withPrevious.txt", sep = ""))
                   
SlowWavedat = read.delim(paste(path, "SlowWave/", "SlowWave_TBT_Cond_Wprev_3subs.txt", sep = ""))

colnames(N2dat) <- c("Subject", "Trial", "Electrode", "N2curr", "Acc", "Condition", "notFirst", 
                  "prevCondTrigger", "prevCondAcc", "prevCond", "TrialCondition")

colnames(SlowWavedat) <- c("Subject", "Trial", "Electrode", "SlowWavecurr", "Acc", "Condition", "notFirst", 
                           "prevCondTrigger", "prevCondAcc", "prevCond", "TrialCondition")

#This Works.
N2_SlowWave_dat <- merge(N2dat, SlowWavedat, by = c("Subject", "Trial", "Electrode",
                                                       "Acc", "Condition", "notFirst", 
                                                       "prevCondTrigger", "prevCondAcc", "prevCond", "TrialCondition"))


head(RT_N2_SlowWave_dat_all)
tail(RT_N2_SlowWave_dat_all)
head(RT_N2_SlowWave_dat)
tail(RT_N2_SlowWave_dat)
head(RT_N2_SlowWave_dat_allERP)
tail(RT_N2_SlowWave_dat_allERP)


Sub92 <- RTdat[RTdat$Subject == 92,]
Trial <-  rep(1:700)
Sub92 <- cbind(Sub92, Trial)

RTdat <- RTdat[RTdat$Subject != 92,]
Trial <-  rep(1:800, length(unique(RTdat$Subject)))   
RTdat <- cbind(RTdat, Trial)


RTdat <- rbind(RTdat, Sub92)

#RTdat <- RTdat[,-1]

RTdatshort <- RTdat[, c(2,27,28)]



RT_N2_SlowWave_dat_allERP <- merge(RTdatshort, N2_SlowWave_dat, by = c("Subject", "Trial")) 

#Remove "notfirst".
Alldat <- RT_N2_SlowWave_dat_allERP[,c(-7,-8)]

colnames(Alldat) <- c("Subject", "Trial", "RT", "Electrode", "AccCurr", "CondCurr",
                           "AccPrev", "CondPrev", "Cell", "N2Curr", "SlowWaveCurr")


#Trying with RTdat. Using the previously merged RT data since it seems like the merge BY
#variables need to be in each dataset. So doing the ERPs first allows us to collapse the 
#variables that are common to the ERP data sets but not common to the RT data set.

RT_N2_SlowWave_dat <- merge(RTdat, N2_SlowWave_dat, by = c("Subject"), all.x=TRUE, all.y=TRUE)  


#####################################################################
###               Adding previous SlowWave variable               ###
#####################################################################
electrodeList = c("F3", "Fz", "F4", "FC3", "FCz", "FC4", "C3", "Cz", "C4")
#This works for one row.
      
      h <- 2
      i <- 7
      j <- "Fz"
      #if ((Trial[i] - Trial[i-1])!= 1) NA
      #if (i - (i-1)!= 1) {
        #Alldat$SlowWavePrev <- NA
        #} else {
          Alldat$SlowWavePrev[Alldat$Subject == h & Alldat$Trial == i & Alldat$Electrode == j] <- Alldat$SlowWaveCurr[Alldat$Subject == h & Alldat$Trial == i-1 & Alldat$Electrode == j]
      
AlldatSort <- Alldat[order(Alldat$Subject, Alldat$Trial, Alldat$Electrode),] 
SlowWaveSolo <- AlldatSort$SlowWaveCurr          

SlowWaveSolo <- data.frame(SlowWaveSolo)
SlowWaveSolo <- SlowWaveSolo[-196785,]

AlldatMinus1 <- AlldatSort[-1,]

AlldatMinus1Prev <- cbind(AlldatMinus1, SlowWaveSolo)

#################### Removing rejection files################
####### Trying to use Rej file ###########################
#Adding rejection info for rej files output from SCAN.
sublist <- c(2, 5, 8, 14, 19, 32,     
             55, 
             59, 60, 65, 
             72, 74,        
             91,
             92, 100, 108, 115, 117, 135, 137, 4, 13, 16, 
             17, 21, 23, 24, 27, 30,
             61, 
             68, 70, 71, 84, 104, 105, 112, 129)

path2 <- "C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"
for (h in sublist) {
  
  
  ##################This Works. Copy and paste below and try to add subject###########
  h <- 2
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
    AlldatMinus1Prev$Rej[AlldatMinus1Prev$Trial == 5] <- rej$Status[rej$TrialCol == 5] 
  }
}



##################This Works. Copy and paste below and try to add subject###########
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

write.table(AlldatMinus1Prev, paste(path, "RT_N2_SlowWave_SlowWavePrev.txt", sep=""), sep = "\t", row.names = F)






for (i in 1:numTrials) {
  # add rejection status from Scan: 0 = reject, 1 = accept
  temp$Rejected[temp$Trial == i] = rej[i,1] 



####  It works Bitches!!###
h <- 2
TrialUnique <- unique(Alldat$Trial)
TrialUnique <- sort(TrialUnique)
#TrialSamp <- c(1,2,4,5,7)
for (i in 2:length(unique(Alldat$Trial))){
  #i <- 5
  #if ((Trial[i] - Trial[i-1])!= 1) NA
  if (TrialUnique[i] - TrialUnique[i-1] == 1)
    print(rep(NA, 9))
  else print(rep(1, 9))
}
          
    
  #####################################################################
  ###               Adding previous SlowWave variable               ###
  #####################################################################
  electrodeList = c("F3", "Fz", "F4", "FC3", "FCz", "FC4", "C3", "Cz", "C4")
  # Begin loop to quantify interval for each trial, for each electrode
  for (h in sublist) {
    
    h <- 2
    #TrialSamp <- c(1,2,4,5,7)
    for (i in 1:length(unique(Alldat$Trial))){
    #for (i in unique(TrialSamp)){
      for (j in electrodeList){ 
        
        #########Works
        h <- 2
        i <- 8
        j <- "Fz"
        #if ((Trial[i] - Trial[i-1])!= 1) NA
        #if (Trial[i] - Trial[i-1] == 1) {
          Alldat$SlowWavePrev[Alldat$Subject == h & Alldat$Trial == i & Alldat$Electrode == j] <- Alldat$SlowWaveCurr[Alldat$Subject == h & Alldat$Trial == i-1 & Alldat$Electrode == j]
        #} else {
          #Alldat$SlowWavePrev <- NA 
        }
      }
    }
    
  
###Copy and Paste from above###
electrodeList = c("F3", "Fz", "F4", "FC3", "FCz", "FC4", "C3", "Cz", "C4")
# Begin loop to quantify interval for each trial, for each electrode
for (h in sublist) {
  
  h <- 2
  #TrialSamp <- c(1,2,4,5,7)
  for (i in 1:length(unique(Alldat$Trial))){
    #for (i in unique(TrialSamp)){
    for (j in electrodeList){ 
      
    ##### Works on one electrode.
      h <- 4
      #i <- 8
      j <- "Fz"
      SubjectTemp <- Alldat[Alldat$Subject == h,]
      for (i in 2:length(unique(SubjectTemp$Trial))) {
        #if ((SubjectTemp$Trial[i] - SubjectTemp$Trial[i-1]) == 1) 
          Alldat$SlowWavePrev[Alldat$Subject == h & Alldat$Electrode == j & Alldat$Trial[4]] <- Alldat$SlowWaveCurr[Alldat$Subject == h & Alldat$Electrode == j & Alldat$Trial[i-1]]
        #else Alldat$SlowWavePrev <- NA
      }

      
      # Hannah
      h <- 2
      #i <- 8
      j <- "Fz"
      SubjectTemp <- Alldat[Alldat$Subject == h,]
      trials = sort(unique(SubjectTemp$Trial))
      prevTrials = trials-1
      for (i in trials[prevTrials %in% trials]) {
        Alldat$SlowWavePrev[Alldat$Subject == h & Alldat$Electrode == j & Alldat$Trial == i] <- Alldat$SlowWaveCurr[Alldat$Subject == h & Alldat$Electrode == j & Alldat$Trial == i-1]
      }
     
      
      #Trying above but without array.
      h <- 2
      i <- 8
      j <- "Fz"
      SubjectTemp <- Alldat[Alldat$Subject == h,]
      for (i in unique(SubjectTemp$Trial)) {
        #if ((SubjectTemp$Trial[i] - SubjectTemp$Trial[i-1]) == 1) 
        Alldat$SlowWavePrev[Alldat$Subject == h & Alldat$Electrode == j & Alldat$Trial == i] <- Alldat$SlowWaveCurr[Alldat$Subject == h & Alldat$Electrode == j & Alldat$Trial == i-1]
        #else Alldat$SlowWavePrev <- NA
      }
      
      
      
      
      
      #if ((Trial[i] - Trial[i-1])!= 1) NA
      #if (Trial[i] - Trial[i-1] == 1) {
      Alldat$SlowWavePrev[Alldat$Subject == h & Alldat$Trial == i & Alldat$Electrode == j] <- Alldat$SlowWaveCurr[Alldat$Subject == h & Alldat$Trial == i-1 & Alldat$Electrode == j]
      #} else {
      #Alldat$SlowWavePrev <- NA 
    }
  }
}



###Copy and pasted from above (above works on one electrode)
##### Works on one electrode.
electrodeList = c("F3", "Fz", "F4", "FC3", "FCz", "FC4", "C3", "Cz", "C4")
h <- 2
#i <- 8
j <- "Fz"
SubjectTemp <- Alldat[Alldat$Subject == h,]
for (i in 2:length(unique(SubjectTemp$Trial))) {
  #for (j in electrodeList){ 
  if ((SubjectTemp$Trial[i] - SubjectTemp$Trial[i-1]) == 1) 
    Alldat$SlowWavePrev[Alldat$Subject == h & Alldat$Trial[i] & Alldat$Electrode == j] <- Alldat$SlowWaveCurr[Alldat$Subject == h & Alldat$Trial[i-1] & Alldat$Electrode == j]
  else Alldat$SlowWavePrev <= NA
    }
  


  
####From completed script###.
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






  for (h in sublist) {
    
    
    ####  It works Bitches!!###
    h <- 2
    TrialUnique <- unique(Alldat$Trial)
    TrialUnique <- sort(TrialUnique)
    #TrialSamp <- c(1,2,4,5,7)
    for (i in 2:length(unique(Alldat$Trial))){
      #i <- 5
      #if ((Trial[i] - Trial[i-1])!= 1) NA
      if (TrialUnique[i] - TrialUnique[i-1] == 1)
        print(rep("Fuck Yeah", 9))
      else print(rep("Bummer Deluxe", 9))
    }
    
    
    
    
    
#Runs but wrong.
    h <- 2
    TrialUnique <- unique(Alldat$Trial)
    TrialUnique <- sort(TrialUnique)
    #TrialSamp <- c(1,2,4,5,7)
    for (i in 2:length(unique(Alldat$Trial))){
#i <- 5
      for (j in electrodeList){ 
        #for (k in Alldat$Trial){
        #if ((Trial[i] - Trial[i-1])!= 1) NA
        if (TrialUnique[i] - TrialUnique[i-1] == 1)
          Alldat$SlowWavePrev[Alldat$Subject == h & Alldat$Trial[i] & Alldat$Electrode == j] <- Alldat$SlowWaveCurr[Alldat$Subject == h & Alldat$Trial[i-1] & Alldat$Electrode == j]
        else Alldat$SlowWavePrev <- NA
        }  
      }
    }
    
    
    h <- 2
    TrialUnique <- unique(Alldat$Trial)
    TrialUnique <- sort(TrialUnique)
    #TrialSamp <- c(1,2,4,5,7)
    for (i in unique(Alldat$Trial)){
      #i <- 5
      for (j in electrodeList){ 
        #if ((Trial[i] - Trial[i-1])!= 1) NA
        if (i - (i-1) == 1)
          Alldat$SlowWavePrev[Alldat$Subject == h & Alldat$Trial == i & Alldat$Electrode == j] <- Alldat$SlowWaveCurr[Alldat$Subject == h & Alldat$Trial == i-1 & Alldat$Electrode == j]
        else Alldat$SlowWavePrev <- NA
      }
    }
    
    
    
    
    }
          {
        Alldat$SlowWavePrev[Alldat$Subject == h & Alldat$Trial == i & Alldat$Electrode == j] <- Alldat$SlowWaveCurr[Alldat$Subject == h & Alldat$Trial == i-1 & Alldat$Electrode == j
      }
    }
  }
  
  
  
  
  
  
  
    
    avgTemp$CompPrev1[avgTemp$Trial[i] & avgTemp$Electrode == l] = mean(temp2$Correct[temp2$Trial[i-1]])
    avgTemp$Comprev2[avgTemp$Trial[i] & avgTemp$Electrode == l] = mean(temp2$Correct[temp2$Trial[i-2]])
    
    avgCur = temp2[temp2$Trial == avgTemp$Trial[i], l] %>% # this is a piping command, can see more at http://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf
      mean()
    avgPrev = temp2[temp2$Trial == avgTemp$Trial[i-1], l] %>% 
      mean()
    avgTemp$MeanCurr[avgTemp$Trial[i] & avgTemp$Electrode == l] = avgCur
    avgTemp$MeanPrev[avgTemp$Trial[i] & avgTemp$Electrode == l] = avgPrev
    
    avgTemp$AccCurr[avgTemp$Trial[i] & avgTemp$Electrode == l] = mean(temp2$Correct[temp2$Trial[i]])
    avgTemp$AccPrev1[avgTemp$Trial[i] & avgTemp$Electrode == l] = mean(temp2$Correct[temp2$Trial[i-1]])
    avgTemp$AccPrev2[avgTemp$Trial[i] & avgTemp$Electrode == l] = mean(temp2$Correct[temp2$Trial[i-2]])
    
    avgTemp$CompCurr[avgTemp$Trial[i] & avgTemp$Electrode == l] = mean(temp2$Correct[temp2$Trial[i]])
    avgTemp$CompPrev1[avgTemp$Trial[i] & avgTemp$Electrode == l] = mean(temp2$Correct[temp2$Trial[i-1]])
    avgTemp$Comprev2[avgTemp$Trial[i] & avgTemp$Electrode == l] = mean(temp2$Correct[temp2$Trial[i-2]])
  }
}



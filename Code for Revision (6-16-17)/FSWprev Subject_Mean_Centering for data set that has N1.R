####SlowWave###
########################################################################
##########Person Mean Centering with Cell in the data###################
setwd("C:/Users/Cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej")
#path = "C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"
SubLevDat <- read.delim("Revision Data Sets/RT_N1_N2_FSW_FSWPrev_SubNoCond.txt")
TrialLevDat <- read.delim("Revision Data Sets/RT_N1_N2_FSW_FSWPrev_TrialLev.txt")

for (h in unique(SubLevDat$Subject)) {
  for (i in unique(TrialLevDat$Cell)) {
    TrialLevDat$SWPrevMean[TrialLevDat$Subject == h & TrialLevDat$Cell == i] <- SubLevDat$SlowWavePrev[SubLevDat$Subject == h]
  }
}

TrialLevDat$SWPrevCent <- (TrialLevDat$SlowWavePrev - TrialLevDat$SWPrevMean)

#Removing current trials that don't have previous slowwave data.
#TrialLevDateRem <- TrialLevDat[!is.na(TrialLevDat$SlowWavePrev),]

write.table(TrialLevDateRem, "Revision Data Sets/RT_N1_N2_FSW_FSWPrev_MeanCent.txt", sep = "\t", row.names = F)

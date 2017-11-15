####SlowWave###
########################################################################
##########Person Mean Centering with Cell in the data###################
setwd("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej")
#path = "C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"
SubLevDat <- read.delim("RT_N2_SlowWave_SubNoCond_EventFixed.txt")
TrialLevDat <- read.delim("RT_N2_SlowWave_TrialLev_EventFixed.txt")

for (h in unique(SubLevDat$Subject)) {
  for (i in unique(TrialLevDat$Cell)) {
    TrialLevDat$SWPrevMean[TrialLevDat$Subject == h & TrialLevDat$Cell == i] <- SubLevDat$SlowWavePrev[SubLevDat$Subject == h]
  }
}

TrialLevDat$SWPrevCent <- (TrialLevDat$SlowWavePrev - TrialLevDat$SWPrevMean)

#Removing current trials that don't have previous slowwave data.
TrialLevDateRem <- TrialLevDat[!is.na(TrialLevDat$SlowWavePrev),]

write.table(TrialLevDateRem, "RT_N2_SlowWave_MeanCent_EventFixed.txt", sep = "\t", row.names = F)

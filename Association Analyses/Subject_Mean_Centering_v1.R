####SlowWave###
########################################################################
##########Person Mean Centering with Cell in the data###################
setwd("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej")
#path = "C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"
SubLevDat <- read.delim("RT_N2_SlowWave_SubNoCond.txt")
TrialLevDat <- read.delim("RT_N2_SlowWave_TrialLev.txt")

for (h in unique(SubLevDat$Subject)) {
  for (i in unique(TrialLevDat$Cell)) {
    TrialLevDat$SWPrevMean[TrialLevDat$Subject == h & TrialLevDat$Cell == i] <- SubLevDat$SlowWavePrev[SubLevDat$Subject == h]
  }
}

TrialLevDat$SWPrevCent <- (TrialLevDat$SlowWavePrev - TrialLevDat$SWPrevMean)

write.table(TrialLevDat, "RT_N2_SlowWave_MeanCent.txt", sep = "\t", row.names = F)



##########Person Mean Centering withOUT Cell in the data###################
setwd("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej")
#path = "C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"
SubLevDat <- read.delim("RT_N2_SlowWave_SubNoCond.txt")
TrialLevDat <- read.delim("RT_N2_SlowWave_TrialLevNoCond.txt")

for (h in unique(SubLevDat$Subject)) {
    TrialLevDat$SWPrevMean[TrialLevDat$Subject == h] <- SubLevDat$SlowWavePrev[SubLevDat$Subject == h]
}

TrialLevDat$SWPrevCent <- (TrialLevDat$SlowWavePrev - TrialLevDat$SWPrevMean)

write.table(TrialLevDat, "RT_N2_SlowWave_MeanCentNoCond.txt", sep = "\t", row.names = F)



##################Same but for RT#####################
setwd("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej")
#path = "C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"
SubLevDat <- read.delim("RT_N2_SlowWave_SubNoCond.txt")
TrialLevDat <- read.delim("RT_N2_SlowWave_TrialLev.txt")

for (h in unique(SubLevDat$Subject)) {
  for (i in unique(TrialLevDat$Cell)) {
    TrialLevDat$RTMean[TrialLevDat$Subject == h & TrialLevDat$Cell == i] <- SubLevDat$RT[SubLevDat$Subject == h]
  }
}

TrialLevDat$RTCent <- (TrialLevDat$RT - TrialLevDat$RTMean)

write.table(TrialLevDat, "RT_N2_SlowWave_MeanCentRT.txt", sep = "\t", row.names = F)

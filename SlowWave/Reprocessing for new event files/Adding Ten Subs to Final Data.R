
library(psych)

setwd("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave")
path = "C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave/"
SlowWavedat = read.delim("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave/AllSubs_TBTaverages_SlowWave_Cond_withPrevious.txt", header=T)
SlowWavedat_10subs = read.delim("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave/AllSubs_TBTaverages_SlowWave_Correct_withPrevious_10subs.txt", header=T)

sublist1 <- c("002", "004", "008", "016", "017", "019", "030", "059", "070", "074", "137")
sublist2 <- c(2, 4, 8, 16, 17, 19, 30, 59, 70, 74, 137) 

#SlowWavedatshort = SlowWavedat[SlowWavedat$Subject %in% sublist2] 

SlowWavedat_short = SlowWavedat[SlowWavedat$Subject != 2 & SlowWavedat$Subject != 4 & SlowWavedat$Subject != 8 &
                   SlowWavedat$Subject != 16 & SlowWavedat$Subject != 17 & SlowWavedat$Subject != 19 &
                   SlowWavedat$Subject != 30 & SlowWavedat$Subject != 59 & SlowWavedat$Subject != 70 &
                   SlowWavedat$Subject != 74 & SlowWavedat$Subject != 137,] 
unique(SlowWavedat_short$Subject)
unique(SlowWavedat_10subs$Subject)

SlowWavedat_All <- rbind(SlowWavedat_10subs, SlowWavedat_short)

unique(SlowWavedat$Subject)
unique(SlowWavedat_short$Subject)
unique(SlowWavedat_10subs$Subject)
unique(SlowWavedat_All$Subject)
describe(unique(SlowWavedat$Subject))
describe(unique(SlowWavedat_short$Subject))
describe(unique(SlowWavedat_10subs$Subject))
describe(unique(SlowWavedat_All$Subject))

write.table(SlowWavedat_All, paste(path,"AllSubs_TBTaverages_SlowWave_Correct_withPrevious_EventFixed.txt", sep=""), sep = "\t", row.names = F)
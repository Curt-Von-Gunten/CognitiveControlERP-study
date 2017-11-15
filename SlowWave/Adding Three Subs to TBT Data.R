
setwd("C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave")
path = "C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave/"
SlowWavedat = read.delim("C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave/AllSubs_TBT_SlowWave.txt", header=T)

SlowWavedatshort = SlowWavedat[SlowWavedat$Subject != 19 & SlowWavedat$Subject != 74 & SlowWavedat$Subject != 137,] 

sublist <- c( "019", "074",  "137")

for (k in sublist) {
  
  tempSub = read.delim(paste(path, k, "_TBT_SlowWave.txt", sep=""))
  
  QuantDat = rbind(SlowWavedatshort, tempSub)
  
}

write.table(QuantDat, paste(path,"AllSubs_TBT_SlowWave_3Subs.txt", sep=""), sep = "\t", row.names = F)
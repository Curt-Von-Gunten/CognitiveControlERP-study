setwd("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave")
pathN2 = "C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/N2/"
pathFSW = "C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave/"
path = "C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/"

SlowWavedat = read.delim("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/RT_N2_SlowWave_SlowWavePrev_EventFixed.txt", header=T)
SlowWavedat_10subs = read.delim("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave/AllSubs_TBTaverages_SlowWave_Correct_withPrevious_10subs.txt", header=T)
SlowWavedat_137 = read.delim("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave/137_RT_N2_SlowWave_SlowWavePrev_EventFixed.txt", header=T)




SlowWavedat_All <- rbind(SlowWavedat, SlowWavedat_137)

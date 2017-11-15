
setwd("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave")
pathN2 = "C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/N2/"
pathFSW = "C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave/"
path = "C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/"

SlowWavedat = read.delim("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave/AllSubs_TBTaverages_SlowWave_Cond_withPrevious.txt", header=T)
SlowWavedat_10subs = read.delim("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave/AllSubs_TBTaverages_SlowWave_Correct_withPrevious_10subs.txt", header=T)
SlowWavedat_137 = read.delim("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave/137_TBTaverages_SlowWave_Correct_withPrevious_10subs.txt", header=T)


#N2 and FSW prev data set.
N2FSW_prev = read.delim("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/N2prev_FSWprev_MeanCent_EventFixed.txt", header=T)
Sub37 <- N2FSW_prev[N2FSW_prev$Subject==137,]

#N2prev.
N2FSW_prev = read.delim(paste(path, "RT_N2_FSW_N2prev_Trial&ElecLev_EventFixed.txt", sep = ""), header=T)
Sub37 <- N2FSW_prev[N2FSW_prev$Subject==137,]

#N2prev.
N2FSW_prev = read.delim(paste(path, "RT_N2_FSW_N2prev_TrialLev_EventFixed.txt", sep = ""), header=T)
Sub37 <- N2FSW_prev[N2FSW_prev$Subject==137,]

#N2prev.
N2FSW_prev = read.delim(paste(path, "RT_N2_SlowWave_N2Prev_EventFixed.txt", sep = ""), header=T)
Sub37 <- N2FSW_prev[N2FSW_prev$Subject==137,]



#FSWprev
N2FSW_prev = read.delim(paste(path, "RT_N2_SlowWave_MeanCent_EventFixed.txt", sep = ""), header=T)
Sub37 <- N2FSW_prev[N2FSW_prev$Subject==137,]

#FSWprev
N2FSW_prev = read.delim(paste(path, "RT_N2_SlowWave_Trial&ElecLev.txt", sep = ""), header=T)
Sub37 <- N2FSW_prev[N2FSW_prev$Subject==137,]

#FSWprev
N2FSW_prev = read.delim(paste(path, "RT_N2_SlowWave_SubNoCond_EventFixed.txt", sep = ""), header=T)
Sub37 <- N2FSW_prev[N2FSW_prev$Subject==137,]

N2FSW_prev = read.delim(paste(path, "AllSubs_TBTaverages_SlowWave_Correct_withPrevious_EventFixed.txt", sep = ""), header=T)
Sub37 <- N2FSW_prev[N2FSW_prev$Subject==137,]





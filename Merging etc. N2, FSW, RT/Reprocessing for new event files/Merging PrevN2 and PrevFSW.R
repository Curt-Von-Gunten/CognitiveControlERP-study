
library(psych)

#####################################################################
###               Merging N2prev and FSWprev datsets                ###
#####################################################################
setwd("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej")
path = "C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/"

#N2, SlowWave data sets. The ERP sets have had incorrect and art rejected trials removed.
N2prev = read.delim(paste(path, "RT_N2_FSW_N2prev_MeanCent_EventFixed.txt", sep = ""))
                   
FSWprev = read.delim(paste(path, "RT_N2_SlowWave_MeanCent_EventFixed.txt", sep = ""))

colnames(N2prev) <- c("Subject", "Trial", "Cell", "RT", "N2curr", "SlowWaveCurr", "N2Prev", "N2Mean", "N2Cent")

colnames(FSWprev) <- c("Subject", "Trial", "Cell", "RT", "N2curr", "SlowWaveCurr", "SlowWavePrev", "SlowWaveMean", "SlowWaveCent")

#Merging just N2 and SlowWave first. Can's use "by" if the varibles aren't in both datasets.
N2_SlowWave_dat <- merge(N2prev, FSWprev, by = c("Subject", "Trial", "Cell", "RT", "N2curr", "SlowWaveCurr"), all.y=TRUE)
head(N2_SlowWave_dat)
tail(N2_SlowWave_dat)

write.table(N2_SlowWave_dat, paste(path, "N2prev_FSWprev_MeanCent_EventFixed.txt", sep=""), sep = "\t", row.names = F)

aaaa <- N2_SlowWave_dat[N2_SlowWave_dat$Subject == 2,]
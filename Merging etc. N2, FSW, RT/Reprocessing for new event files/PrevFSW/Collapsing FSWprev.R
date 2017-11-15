require(dplyr)

setwd("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej")
#path = "C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"
RT_N2_SlowWave <- read.delim("RT_N2_SlowWave_SlowWavePrev_EventFixed.txt")

Sub137 <- RT_N2_SlowWave[RT_N2_SlowWave$Subject == 137,]

#Removing RT that is -7 and greater than 1200.
range(RT_N2_SlowWave$RT)
RT_N2_SlowWave2 <- RT_N2_SlowWave[RT_N2_SlowWave$RT != -7,]
range(RT_N2_SlowWave2$RT)
RT_N2_SlowWave2 <- RT_N2_SlowWave2[RT_N2_SlowWave2$RT < 1201,]
range(RT_N2_SlowWave2$RT)

#Removing current trials that don't have previous slowwave data.
#RT_N2_SlowWave2 <- RT_N2_SlowWave2[!is.na(RT_N2_SlowWave2$SlowWavePrev),]

#Trial and Electrode Level.
dat1 <- select(RT_N2_SlowWave2, Subject, Trial, Electrode, Cell, RT, N2Curr, SlowWaveCurr, SlowWavePrev)
dat2 <- group_by(dat1, Subject, Trial, Electrode, Cell)
(RT_N2_SlowWave_Coll <-   summarise(dat2, mean(RT), mean(N2Curr), mean(SlowWaveCurr), mean(SlowWavePrev)))
colnames(RT_N2_SlowWave_Coll) <- c("Subject", "Trial", "Electrode", "Cell", "RT", "N2Curr", "SlowWaveCurr", "SlowWavePrev")
write.table(RT_N2_SlowWave_Coll, "RT_N2_SlowWave_Trial&ElecLev_EventFixed.txt", sep = "\t", row.names = F)

#Trial Level.
dat1 <- select(RT_N2_SlowWave2, Subject, Trial, Electrode, Cell, RT, N2Curr, SlowWaveCurr, SlowWavePrev)
dat2 <- group_by(dat1, Subject, Trial, Cell)
(RT_N2_SlowWave_Coll <-   summarise(dat2, mean(RT), mean(N2Curr), mean(SlowWaveCurr), mean(SlowWavePrev)))
colnames(RT_N2_SlowWave_Coll) <- c("Subject", "Trial", "Cell", "RT", "N2Curr", "SlowWaveCurr", "SlowWavePrev")
write.table(RT_N2_SlowWave_Coll, "RT_N2_SlowWave_TrialLev_EventFixed.txt", sep = "\t", row.names = F)

#Subject level with no condition variable.
dat1 <- select(RT_N2_SlowWave2, Subject, Trial, Electrode, Cell, RT, N2Curr, SlowWaveCurr, SlowWavePrev)
dat2 <- group_by(dat1, Subject)
(RT_N2_SlowWave_Coll <-   summarise(dat2, mean(RT), mean(N2Curr), mean(SlowWaveCurr), mean(SlowWavePrev)))
colnames(RT_N2_SlowWave_Coll) <- c("Subject", "RT", "N2Curr", "SlowWaveCurr", "SlowWavePrev")
write.table(RT_N2_SlowWave_Coll, "RT_N2_SlowWave_SubNoCond_EventFixed.txt", sep = "\t", row.names = F)


setwd("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej")
path = "C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/"

sublist <- c(2, 5, 8, 14, 19, 32,     
             55, 
             59, 60, 65, 
             72, 74,        
             91,
             92, 100, 108, 115, 117, 135, 137, 4, 13, 16, 
             17, 21, 23, 24, 27, 30,
             61, 
             68, 70, 71, 84, 104, 105, 112, 129)

electrodeList = c("F3", "Fz", "F4", "FC3", "FCz", "FC4", "C3", "Cz", "C4")

# Hannah
#h <- 2
#i <- 8
#j <- "Fz"
Alldat$SlowWavePrev = NA
for (h in sublist){
 # h <- 2
SubjectTemp <- Alldat[Alldat$Subject == h,]
trials = sort(unique(SubjectTemp$Trial))
prevTrials = trials-1
for (i in trials[prevTrials %in% trials]) {
for (j in electrodeList){
  Alldat$SlowWavePrev[Alldat$Subject == h & Alldat$Electrode == j & Alldat$Trial == i] <- Alldat$SlowWaveCurr[Alldat$Subject == h & Alldat$Electrode == j & Alldat$Trial == i-1]
}
}
}

write.table(Alldat, paste(path, "RT_N2_SlowWave_SlowWavePrev_v.2.txt", sep=""), sep = "\t", row.names = F)
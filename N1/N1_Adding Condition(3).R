



############Condition Information Loop###########
setwd("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing")
path = "C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"
temp = read.delim("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/N1/AllSubs_TBT_N1.txt", header=T)

sublist <- c(2, 4, 5, 8, 13, 14, 16, 17, 21, 23, 24, 27, 30, 32, 55, 59, 60, 61, 65, 68, 70, 71, 
             72, 84, 91, 92, 100, 104, 105, 108, 112, 115, 117, 129, 135, 137)

electrodeList = c("P3", "Pz", "P4", "O2", "O1")
#library(stringr)
#newSub <- data.frame(str_pad(temp$Subject, 3, pad = "0"))
#colnames(newSub) <- c("Subject")
#dim(newSub)
#dim(temp)
#temp <- cbind(newSub, temp)
#temp = temp[,-2]
#head(temp)

QuantDatCondFull = NULL # will become data frame with all data plus conditions
ev2names = c("Trial", "Trigger", "Resp", "Correct", "RT", "Onset")

for (k in unique(temp$Subject)) {
  
 
  temp2 = subset(temp, Subject == k)
  ev2 = read.delim(paste(path, "Event_Stimulus_Files/Reg&Mod_Event_Files_NoZeroes/", k, "flk_rev.ev2", sep=""), header=FALSE)
  names(ev2) = ev2names
  
  Comp = ev2$Trial[ev2$Trigger == 110 | ev2$Trigger == 130]
  temp2$Condition[temp2$Trial %in% Comp] = "Comp"
  
  InComp = ev2$Trial[ev2$Trigger == 150 | ev2$Trigger == 170]
  temp2$Condition[temp2$Trial %in% InComp] = "InComp"
  
  Trig = ev2$Trial[ev2$Trigger == 110]
  temp2$Tigger[temp2$Trial %in% Trig] = 110
  Trig = ev2$Trial[ev2$Trigger == 130]
  temp2$Tigger[temp2$Trial %in% Trig] = 130
  Trig = ev2$Trial[ev2$Trigger == 150]
  temp2$Tigger[temp2$Trial %in% Trig] = 150
  Trig = ev2$Trial[ev2$Trigger == 170]
  temp2$Tigger[temp2$Trial %in% Trig] = 170
  
  
  dim(temp2)
  dim(QuantDatCondFull)

  QuantDatCondFull = rbind(QuantDatCondFull, temp2)
  
}

write.table(QuantDatCondFull, paste(path,"Created by R_ArtRej/N1/AllSubs_TBT_N1_Cond.txt", sep=""), sep = "\t", row.names = F)



QuantDatCondFull$N1Prev = NA
for (h in sublist){
  # h <- 2
  SubjectTemp <- QuantDatCondFull[QuantDatCondFull$Subject == h,]
  trials = sort(unique(SubjectTemp$Trial))
  prevTrials = trials-1
  for (i in trials[prevTrials %in% trials]) {
    for (j in electrodeList){
      QuantDatCondFull$N1Prev[QuantDatCondFull$Subject == h & QuantDatCondFull$Electrode == j & QuantDatCondFull$Trial == i] <- QuantDatCondFull$MeanCurr[QuantDatCondFull$Subject == h & QuantDatCondFull$Electrode == j & QuantDatCondFull$Trial == i-1]
    }
  }
}

write.table(QuantDatCondFull, paste(path,"Created by R_ArtRej/N1/AllSubs_TBT_N1_Cond_Prev.txt", sep=""), sep = "\t", row.names = F)




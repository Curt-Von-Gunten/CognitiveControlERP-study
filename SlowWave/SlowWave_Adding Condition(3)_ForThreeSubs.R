



############Condition Information Loop###########
setwd("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave")
path = "C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"
temp = read.delim("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave/AllSubs_TBT_SlowWave_3Subs.txt", header=T)



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
  ev2 = read.delim(paste(path, "Event_Stimulus_Files_NoZeros/", k, "flk_rev.ev2", sep=""), header=FALSE)
  names(ev2) = ev2names
  
  Comp = ev2$Trial[ev2$Trigger == 110 | ev2$Trigger == 130]
  temp2$Condition[temp2$Trial %in% Comp] = "Comp"
  
  InComp = ev2$Trial[ev2$Trigger == 150 | ev2$Trigger == 170]
  temp2$Condition[temp2$Trial %in% InComp] = "InComp"
  
  dim(temp2)
  dim(QuantDatCondFull)

  QuantDatCondFull = rbind(QuantDatCondFull, temp2)
  
  #For Test purposes
  write.table(temp, paste(path,"Created by R_ArtRej/SlowWave/", k, "_TBT_SlowWave_Cond.txt", sep=""), sep = "\t", row.names = F)
}

write.table(QuantDatCondFull, paste(path,"Created by R_ArtRej/SlowWave/AllSubs_TBT_SlowWave_Cond_3subs.txt", sep=""), sep = "\t", row.names = F)


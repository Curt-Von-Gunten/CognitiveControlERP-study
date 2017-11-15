#### Takes smaller files from "PBP Processing State 1":
#(1) Creates a file at the trial level (rather than point level).
#(2) Adds averages for each trial and electrod for each subject.
#(3) Removes bad and skipped electrodes,
#(4) Adds condition information.

require(magrittr)

setwd("C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R")
path = "C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"
sublist <- c("002", "005", "008", "014", "019", "032",     
  "055", 
  "059", "060", "065", 
  "072", "074",        
  "091",
  "092", "100", "108", "115", "117", "135", "137", "004", "013", "016", 
  "017", "021", "023", "024", "027", "030",
  "061", 
  "068", "070", "071", "084", "104", "105", "112", "129")
#sublist = c(2)
#badsubs = c(1,11,15,22,28,48,49,54,59,64,65)
#sublist=sublist[!sublist %in% badsubs]

electrodeList = c("F3", "Fz", "F4", "FC3", "FCz", "FC4", "C3", "Cz", "C4")

QuantDat = NULL # will become long form with following columns: Subject, Trial, Electrode, MeanAmp

###########Average amplitude loop###########
for (k in sublist) {
  
  # read in smaller point-by-point data files
  temp2 = read.delim(paste(path, "Created by R/", k, "_PBP_(220-320).txt", sep=""), header=T) 
  
  # Now for each trial, calculate mean amplitude in time window of interest and add value for each trial to new data set
  # Could also do peak amplitude by using max instead of mean
  
  # create data set to put average amp for each trial
  avgTemp = data.frame(Subject = k,
                       Trial = rep(unique(temp2$Trial), each = length(electrodeList)),
                       Electrode = rep(electrodeList, length(unique(temp2$Trial))))

  #For test purposes.
  #write.table(avgTemp, paste(path,"Created by R/avgTemp_", k, ".txt", sep=""), sep = "\t", row.names = F)
  
  
  # Begin loop to quantify interval for each trial, for each electrode
  for (i in 1:length(avgTemp$Trial)) {  # go one trial at a time
    for (l in electrodeList) { # one electrode at a time
      avgCur = temp2[temp2$Trial == avgTemp$Trial[i], l] %>% # this is a piping command, can see more at http://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf
        mean()
      avgPrev = temp2[temp2$Trial == avgTemp$Trial[i-1], l] %>% 
        mean()
      avgTemp$MeanCurr[avgTemp$Trial[i] & avgTemp$Electrode == l] = avgCur
      avgTemp$MeanPrev[avgTemp$Trial[i] & avgTemp$Electrode == l] = avgPrev
      
      avgTemp$AccCurr[avgTemp$Trial[i] & avgTemp$Electrode == l] = mean(temp2$Correct[temp2$Trial[i]])
      avgTemp$AccPrev1[avgTemp$Trial[i] & avgTemp$Electrode == l] = mean(temp2$Correct[temp2$Trial[i-1]])
      avgTemp$AccPrev2[avgTemp$Trial[i] & avgTemp$Electrode == l] = mean(temp2$Correct[temp2$Trial[i-2]])
      
      avgTemp$CompCurr[avgTemp$Trial[i] & avgTemp$Electrode == l] = mean(temp2$Correct[temp2$Trial[i]])
      avgTemp$CompPrev1[avgTemp$Trial[i] & avgTemp$Electrode == l] = mean(temp2$Correct[temp2$Trial[i-1]])
      avgTemp$Comprev2[avgTemp$Trial[i] & avgTemp$Electrode == l] = mean(temp2$Correct[temp2$Trial[i-2]])
    }
  }
  
  ###########Bad, skipped electrode loop###########
  badElec = read.table(file = paste(path, "SCAN_Output/", k, "_CHAN.log", sep=""), header = T)
  for (l in electrodeList) {
    if (badElec$Bad[badElec$Channel == l] == 1){
      avgTemp$MeanCurr[avgTemp$Electrode == l] = NA
      avgTemp$MeanPrev[avgTemp$Electrode == l] = NA
    } else if (badElec$Skip[badElec$Channel == l] == 1) {
      avgTemp$MeanCurr[avgTemp$Electrode == l] = NA
      avgTemp$MeanPrev[avgTemp$Electrode == l] = NA
    }
  }
  QuantDat = rbind(QuantDat, avgTemp)
  write.table(avgTemp, paste(path,"Created by R/QuantDat", k, ".txt", sep=""), sep = "\t", row.names = F)
}
write.table(QuantDat, paste(path,"Created by R/AllSubs_TBTaverages_N2.txt", sep=""), sep = "\t", row.names = F)




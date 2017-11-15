#### Takes smaller files from "PBP Processing State 1":
#(1) Creates a file at the trial level (rather than point level).
#(2) Adds averages for each trial and electrod for each subject.
#(3) Removes bad and skipped electrodes,
#(4) Adds condition information.

require(magrittr)

setwd("C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave")
path = "C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"
sublist <- c( "019", "074",  "137")
#sublist = c(2)
#badsubs = c(1,11,15,22,28,48,49,54,59,64,65)
#sublist=sublist[!sublist %in% badsubs]

electrodeList = c("F3", "Fz", "F4", "FC3", "FCz", "FC4", "C3", "Cz", "C4")

QuantDat = NULL # will become long form with following columns: Subject, Trial, Electrode, MeanAmp

###########Average amplitude loop###########
for (k in sublist) {
  
  # read in smaller point-by-point data files
  temp2 = read.delim(paste(path, "Created by R_ArtRej/SlowWave/", k, "_SlowWave_PBP_(600-1150).txt", sep=""), header=T) 
  
  # Now for each trial, calculate mean amplitude in time window of interest and add value for each trial to new data set
  # Could also do peak amplitude by using max instead of mean
  
  # create data set to put average amp for each trial
  avgTemp = data.frame(Subject = k,
                       Trial = rep(unique(temp2$Trial), each = length(electrodeList)),
                       Electrode = rep(electrodeList, length(unique(temp2$Trial))))

  # Begin loop to quantify interval for each trial, for each electrode
  for (i in unique(avgTemp$Trial)) {  # go one trial at a time
    for (l in electrodeList) { # one electrode at a time
      avg = temp2[temp2$Trial == i, l] %>% # this is a piping command, can see more at http://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf
        mean()
      avgTemp$MeanCurr[avgTemp$Trial == i & avgTemp$Electrode == l] = avg
      avgTemp$Acc[avgTemp$Trial == i & avgTemp$Electrode == l] = mean(temp2$Correct[temp2$Trial == i])
    }
  }
  
  ###########Bad, skipped electrode loop###########
  badElec = read.table(file = paste(path, "SCAN_Output/", k, "_CHAN.log", sep=""), header = T)
  for (l in electrodeList) {
    if (badElec$Bad[badElec$Channel == l] == 1){
      avgTemp$MeanCurr[avgTemp$Electrode == l] = NA
    } else if (badElec$Skip[badElec$Channel == l] == 1) {
      avgTemp$MeanCurr[avgTemp$Electrode == l] = NA
    }
  }
  
  QuantDat = rbind(QuantDat, avgTemp)
  
  write.table(avgTemp, paste(path,"Created by R_ArtRej/SlowWave/", k, "_TBT_SlowWave.txt", sep=""), sep = "\t", row.names = F)
  
}






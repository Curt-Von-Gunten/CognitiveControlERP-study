#### Takes smaller files from "PBP Processing State 1":
#(1) Creates a file at the trial level (rather than point level).
#(2) Adds averages for each trial and electrod for each subject.
#(3) Removes bad and skipped electrodes,
#(4) Adds condition information.

require(magrittr)

setwd("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing")
path = "C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"
sublist <- c("002", "005", "008", "014", "019", "032",    "055", "059", "060", "065", 
             "072", "074",         "091",  "092", "100", "108", "115", "117", "135", "137", "004", "013", "016", 
             "017", "021", "023", "024", "027", "030",  "061", 
             "068", "070", "071", "084", "104", "105", "112", "129")
#sublist = c(2)
#badsubs = c(1,11,15,22,28,48,49,54,59,64,65)
#sublist=sublist[!sublist %in% badsubs]

electrodeList = c("P3", "Pz", "P4", "O2", "O1")

QuantDat = NULL # will become long form with following columns: Subject, Trial, Electrode, MeanAmp

###########Average amplitude loop###########
for (k in sublist) {
  # read in smaller point-by-point data files
  temp2 = read.delim(paste(path, "Created by R_ArtRej/N1/", k, "_N1_PBP_(125-220).txt", sep=""), header=T) 
  
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
  badElec = read.table(file = paste(path, "SCAN_Output_Rev_N1/", k, "_CHAN.dat", sep=""), header = T)
  for (l in electrodeList) {
    if (badElec$Bad[badElec$Channel == "P3"] == 1){
      avgTemp$MeanCurr[avgTemp$Electrode == l] = NA
    } else if (badElec$Skip[badElec$Channel == l] == 1) {
      avgTemp$MeanCurr[avgTemp$Electrode == l] = NA
    }
  }
  
  QuantDat = rbind(QuantDat, avgTemp)
  
  write.table(avgTemp, paste(path,"Created by R_ArtRej/N1/", k, "_TBT_N1.txt", sep=""), sep = "\t", row.names = F)
  
}

write.table(QuantDat, paste(path,"Created by R_ArtRej/N1/AllSubs_TBT_N1.txt", sep=""), sep = "\t", row.names = F)




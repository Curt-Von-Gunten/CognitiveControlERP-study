

setwd("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing")
path = "C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"

# read in quantified N2 TBT data
N2dat = read.delim("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/N2/AllSubs_TBTaverages_N2_Correct_withPrevious_EventFixed.txt")


N2dat$currCondTrigger = NA
N2dat$prevCondTrigger = NA
N2dat$prevCondAcc = 0

#setwd("C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing")

numAccTrials = NULL # will become data frame with number of trials accepted for each subject
for (i in unique(N2dat$Subject)) {
  temp = N2dat[N2dat$Subject == i,]
  event = read.delim(paste("./Event_Stimulus_Files/Reg&Mod_Event_Files_NoZeroes/", i, "flk_rev.ev2", sep=""), header=FALSE)
  names(event) = c("trial", "trigger", "C1", "Acc", "C3", "C4")
  # put in previous trial condition into N2 data set, pulling info from event file
  for (j in unique(temp$Trial[temp$notFirst == 1])) {
    N2dat$currCondTrigger[N2dat$Subject == i & N2dat$Trial == j] = event$trigger[event$trial == j]
    N2dat$prevCondTrigger[N2dat$Subject == i & N2dat$Trial == j] = event$trigger[event$trial == j - 1]
    N2dat$prevCondAcc[N2dat$Subject == i & N2dat$Trial == j] = event$Acc[event$trial == j - 1]
  }
  # check number of trials accepted for each subject
  numAccTrials = rbind(numAccTrials, data.frame(Subject = i, numTrials = length(unique(temp$Trial))))
}

#Adding repetition type.
#Comp: Target Left, Flanker Left = 110.
#Comp: Target Right, Flanker Right = 130.
#Incomp: Target Left, Flanker Right = 150.
#Incomp: Target Right, Flanker Left = 170.
N2dat$CompleteRep = NA
N2dat$CompleteRep[N2dat$currCondTrigger == 110 & N2dat$prevCondTrigger == 110] = 1
N2dat$CompleteRep[N2dat$currCondTrigger == 110 & N2dat$prevCondTrigger == 130] = 0
N2dat$CompleteRep[N2dat$currCondTrigger == 110 & N2dat$prevCondTrigger == 150] = 0
N2dat$CompleteRep[N2dat$currCondTrigger == 110 & N2dat$prevCondTrigger == 170] = 0
N2dat$CompleteRep[N2dat$currCondTrigger == 130 & N2dat$prevCondTrigger == 110] = 0
N2dat$CompleteRep[N2dat$currCondTrigger == 130 & N2dat$prevCondTrigger == 130] = 1
N2dat$CompleteRep[N2dat$currCondTrigger == 130 & N2dat$prevCondTrigger == 150] = 0
N2dat$CompleteRep[N2dat$currCondTrigger == 130 & N2dat$prevCondTrigger == 170] = 0
N2dat$CompleteRep[N2dat$currCondTrigger == 150 & N2dat$prevCondTrigger == 110] = 0
N2dat$CompleteRep[N2dat$currCondTrigger == 150 & N2dat$prevCondTrigger == 130] = 0
N2dat$CompleteRep[N2dat$currCondTrigger == 150 & N2dat$prevCondTrigger == 150] = 1
N2dat$CompleteRep[N2dat$currCondTrigger == 150 & N2dat$prevCondTrigger == 170] = 0
N2dat$CompleteRep[N2dat$currCondTrigger == 170 & N2dat$prevCondTrigger == 110] = 0
N2dat$CompleteRep[N2dat$currCondTrigger == 170 & N2dat$prevCondTrigger == 130] = 0
N2dat$CompleteRep[N2dat$currCondTrigger == 170 & N2dat$prevCondTrigger == 150] = 0
N2dat$CompleteRep[N2dat$currCondTrigger == 170 & N2dat$prevCondTrigger == 170] = 1

N2dat$AnyRep = NA
N2dat$AnyRep[N2dat$currCondTrigger == 110 & N2dat$prevCondTrigger == 110] = 1
N2dat$AnyRep[N2dat$currCondTrigger == 110 & N2dat$prevCondTrigger == 130] = 0
N2dat$AnyRep[N2dat$currCondTrigger == 110 & N2dat$prevCondTrigger == 150] = 1
N2dat$AnyRep[N2dat$currCondTrigger == 110 & N2dat$prevCondTrigger == 170] = 1
N2dat$AnyRep[N2dat$currCondTrigger == 130 & N2dat$prevCondTrigger == 110] = 0
N2dat$AnyRep[N2dat$currCondTrigger == 130 & N2dat$prevCondTrigger == 130] = 1
N2dat$AnyRep[N2dat$currCondTrigger == 130 & N2dat$prevCondTrigger == 150] = 1
N2dat$AnyRep[N2dat$currCondTrigger == 130 & N2dat$prevCondTrigger == 170] = 1
N2dat$AnyRep[N2dat$currCondTrigger == 150 & N2dat$prevCondTrigger == 110] = 1
N2dat$AnyRep[N2dat$currCondTrigger == 150 & N2dat$prevCondTrigger == 130] = 1
N2dat$AnyRep[N2dat$currCondTrigger == 150 & N2dat$prevCondTrigger == 150] = 1
N2dat$AnyRep[N2dat$currCondTrigger == 150 & N2dat$prevCondTrigger == 170] = 0
N2dat$AnyRep[N2dat$currCondTrigger == 170 & N2dat$prevCondTrigger == 110] = 1
N2dat$AnyRep[N2dat$currCondTrigger == 170 & N2dat$prevCondTrigger == 130] = 1
N2dat$AnyRep[N2dat$currCondTrigger == 170 & N2dat$prevCondTrigger == 150] = 0
N2dat$AnyRep[N2dat$currCondTrigger == 170 & N2dat$prevCondTrigger == 170] = 1

N2dat$TargetRep = NA
N2dat$TargetRep[N2dat$currCondTrigger == 110 & N2dat$prevCondTrigger == 110] = 0
N2dat$TargetRep[N2dat$currCondTrigger == 110 & N2dat$prevCondTrigger == 130] = 0
N2dat$TargetRep[N2dat$currCondTrigger == 110 & N2dat$prevCondTrigger == 150] = 1
N2dat$TargetRep[N2dat$currCondTrigger == 110 & N2dat$prevCondTrigger == 170] = 0
N2dat$TargetRep[N2dat$currCondTrigger == 130 & N2dat$prevCondTrigger == 110] = 0
N2dat$TargetRep[N2dat$currCondTrigger == 130 & N2dat$prevCondTrigger == 130] = 0
N2dat$TargetRep[N2dat$currCondTrigger == 130 & N2dat$prevCondTrigger == 150] = 0
N2dat$TargetRep[N2dat$currCondTrigger == 130 & N2dat$prevCondTrigger == 170] = 1
N2dat$TargetRep[N2dat$currCondTrigger == 150 & N2dat$prevCondTrigger == 110] = 1
N2dat$TargetRep[N2dat$currCondTrigger == 150 & N2dat$prevCondTrigger == 130] = 0
N2dat$TargetRep[N2dat$currCondTrigger == 150 & N2dat$prevCondTrigger == 150] = 0
N2dat$TargetRep[N2dat$currCondTrigger == 150 & N2dat$prevCondTrigger == 170] = 0
N2dat$TargetRep[N2dat$currCondTrigger == 170 & N2dat$prevCondTrigger == 110] = 0
N2dat$TargetRep[N2dat$currCondTrigger == 170 & N2dat$prevCondTrigger == 130] = 1
N2dat$TargetRep[N2dat$currCondTrigger == 170 & N2dat$prevCondTrigger == 150] = 0
N2dat$TargetRep[N2dat$currCondTrigger == 170 & N2dat$prevCondTrigger == 170] = 0

N2dat$FlankerRep = NA
N2dat$FlankerRep[N2dat$currCondTrigger == 110 & N2dat$prevCondTrigger == 110] = 0
N2dat$FlankerRep[N2dat$currCondTrigger == 110 & N2dat$prevCondTrigger == 130] = 0
N2dat$FlankerRep[N2dat$currCondTrigger == 110 & N2dat$prevCondTrigger == 150] = 0
N2dat$FlankerRep[N2dat$currCondTrigger == 110 & N2dat$prevCondTrigger == 170] = 1
N2dat$FlankerRep[N2dat$currCondTrigger == 130 & N2dat$prevCondTrigger == 110] = 0
N2dat$FlankerRep[N2dat$currCondTrigger == 130 & N2dat$prevCondTrigger == 130] = 0
N2dat$FlankerRep[N2dat$currCondTrigger == 130 & N2dat$prevCondTrigger == 150] = 1
N2dat$FlankerRep[N2dat$currCondTrigger == 130 & N2dat$prevCondTrigger == 170] = 0
N2dat$FlankerRep[N2dat$currCondTrigger == 150 & N2dat$prevCondTrigger == 110] = 0
N2dat$FlankerRep[N2dat$currCondTrigger == 150 & N2dat$prevCondTrigger == 130] = 1
N2dat$FlankerRep[N2dat$currCondTrigger == 150 & N2dat$prevCondTrigger == 150] = 0
N2dat$FlankerRep[N2dat$currCondTrigger == 150 & N2dat$prevCondTrigger == 170] = 0
N2dat$FlankerRep[N2dat$currCondTrigger == 170 & N2dat$prevCondTrigger == 110] = 1
N2dat$FlankerRep[N2dat$currCondTrigger == 170 & N2dat$prevCondTrigger == 130] = 0
N2dat$FlankerRep[N2dat$currCondTrigger == 170 & N2dat$prevCondTrigger == 150] = 0
N2dat$FlankerRep[N2dat$currCondTrigger == 170 & N2dat$prevCondTrigger == 170] = 0

write.table(N2dat, "Created by R_ArtRej/N2/N2_AllSubs_TBT_Cond_Prev_Rep.txt", sep = "\t", row.names = F)

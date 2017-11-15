

setwd("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing")
path = "C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"

# read in quantified SlowWave TBT data
SlowWavedat = read.delim("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave/AllSubs_TBTaverages_SlowWave_Correct_withPrevious_EventFixed.txt")


SlowWavedat$currCondTrigger = NA
SlowWavedat$prevCondTrigger = NA
SlowWavedat$prevCondAcc = 0

#setwd("C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing")

numAccTrials = NULL # will become data frame with number of trials accepted for each subject
for (i in unique(SlowWavedat$Subject)) {
  temp = SlowWavedat[SlowWavedat$Subject == i,]
  event = read.delim(paste("./Event_Stimulus_Files/Reg&Mod_Event_Files_NoZeroes/", i, "flk_rev.ev2", sep=""), header=FALSE)
  names(event) = c("trial", "trigger", "C1", "Acc", "C3", "C4")
  # put in previous trial condition into SlowWave data set, pulling info from event file
  for (j in unique(temp$Trial[temp$notFirst == 1])) {
    SlowWavedat$currCondTrigger[SlowWavedat$Subject == i & SlowWavedat$Trial == j] = event$trigger[event$trial == j]
    SlowWavedat$prevCondTrigger[SlowWavedat$Subject == i & SlowWavedat$Trial == j] = event$trigger[event$trial == j - 1]
    SlowWavedat$prevCondAcc[SlowWavedat$Subject == i & SlowWavedat$Trial == j] = event$Acc[event$trial == j - 1]
  }
  # check number of trials accepted for each subject
  numAccTrials = rbind(numAccTrials, data.frame(Subject = i, numTrials = length(unique(temp$Trial))))
}

#Adding repetition type.
#Comp: Target Left, Flanker Left = 110.
#Comp: Target Right, Flanker Right = 130.
#Incomp: Target Left, Flanker Right = 150.
#Incomp: Target Right, Flanker Left = 170.
SlowWavedat$CompleteRep = NA
SlowWavedat$CompleteRep[SlowWavedat$currCondTrigger == 110 & SlowWavedat$prevCondTrigger == 110] = 1
SlowWavedat$CompleteRep[SlowWavedat$currCondTrigger == 110 & SlowWavedat$prevCondTrigger == 130] = 0
SlowWavedat$CompleteRep[SlowWavedat$currCondTrigger == 110 & SlowWavedat$prevCondTrigger == 150] = 0
SlowWavedat$CompleteRep[SlowWavedat$currCondTrigger == 110 & SlowWavedat$prevCondTrigger == 170] = 0
SlowWavedat$CompleteRep[SlowWavedat$currCondTrigger == 130 & SlowWavedat$prevCondTrigger == 110] = 0
SlowWavedat$CompleteRep[SlowWavedat$currCondTrigger == 130 & SlowWavedat$prevCondTrigger == 130] = 1
SlowWavedat$CompleteRep[SlowWavedat$currCondTrigger == 130 & SlowWavedat$prevCondTrigger == 150] = 0
SlowWavedat$CompleteRep[SlowWavedat$currCondTrigger == 130 & SlowWavedat$prevCondTrigger == 170] = 0
SlowWavedat$CompleteRep[SlowWavedat$currCondTrigger == 150 & SlowWavedat$prevCondTrigger == 110] = 0
SlowWavedat$CompleteRep[SlowWavedat$currCondTrigger == 150 & SlowWavedat$prevCondTrigger == 130] = 0
SlowWavedat$CompleteRep[SlowWavedat$currCondTrigger == 150 & SlowWavedat$prevCondTrigger == 150] = 1
SlowWavedat$CompleteRep[SlowWavedat$currCondTrigger == 150 & SlowWavedat$prevCondTrigger == 170] = 0
SlowWavedat$CompleteRep[SlowWavedat$currCondTrigger == 170 & SlowWavedat$prevCondTrigger == 110] = 0
SlowWavedat$CompleteRep[SlowWavedat$currCondTrigger == 170 & SlowWavedat$prevCondTrigger == 130] = 0
SlowWavedat$CompleteRep[SlowWavedat$currCondTrigger == 170 & SlowWavedat$prevCondTrigger == 150] = 0
SlowWavedat$CompleteRep[SlowWavedat$currCondTrigger == 170 & SlowWavedat$prevCondTrigger == 170] = 1

SlowWavedat$AnyRep = NA
SlowWavedat$AnyRep[SlowWavedat$currCondTrigger == 110 & SlowWavedat$prevCondTrigger == 110] = 1
SlowWavedat$AnyRep[SlowWavedat$currCondTrigger == 110 & SlowWavedat$prevCondTrigger == 130] = 0
SlowWavedat$AnyRep[SlowWavedat$currCondTrigger == 110 & SlowWavedat$prevCondTrigger == 150] = 1
SlowWavedat$AnyRep[SlowWavedat$currCondTrigger == 110 & SlowWavedat$prevCondTrigger == 170] = 1
SlowWavedat$AnyRep[SlowWavedat$currCondTrigger == 130 & SlowWavedat$prevCondTrigger == 110] = 0
SlowWavedat$AnyRep[SlowWavedat$currCondTrigger == 130 & SlowWavedat$prevCondTrigger == 130] = 1
SlowWavedat$AnyRep[SlowWavedat$currCondTrigger == 130 & SlowWavedat$prevCondTrigger == 150] = 1
SlowWavedat$AnyRep[SlowWavedat$currCondTrigger == 130 & SlowWavedat$prevCondTrigger == 170] = 1
SlowWavedat$AnyRep[SlowWavedat$currCondTrigger == 150 & SlowWavedat$prevCondTrigger == 110] = 1
SlowWavedat$AnyRep[SlowWavedat$currCondTrigger == 150 & SlowWavedat$prevCondTrigger == 130] = 1
SlowWavedat$AnyRep[SlowWavedat$currCondTrigger == 150 & SlowWavedat$prevCondTrigger == 150] = 1
SlowWavedat$AnyRep[SlowWavedat$currCondTrigger == 150 & SlowWavedat$prevCondTrigger == 170] = 0
SlowWavedat$AnyRep[SlowWavedat$currCondTrigger == 170 & SlowWavedat$prevCondTrigger == 110] = 1
SlowWavedat$AnyRep[SlowWavedat$currCondTrigger == 170 & SlowWavedat$prevCondTrigger == 130] = 1
SlowWavedat$AnyRep[SlowWavedat$currCondTrigger == 170 & SlowWavedat$prevCondTrigger == 150] = 0
SlowWavedat$AnyRep[SlowWavedat$currCondTrigger == 170 & SlowWavedat$prevCondTrigger == 170] = 1

SlowWavedat$TargetRep = NA
SlowWavedat$TargetRep[SlowWavedat$currCondTrigger == 110 & SlowWavedat$prevCondTrigger == 110] = 0
SlowWavedat$TargetRep[SlowWavedat$currCondTrigger == 110 & SlowWavedat$prevCondTrigger == 130] = 0
SlowWavedat$TargetRep[SlowWavedat$currCondTrigger == 110 & SlowWavedat$prevCondTrigger == 150] = 1
SlowWavedat$TargetRep[SlowWavedat$currCondTrigger == 110 & SlowWavedat$prevCondTrigger == 170] = 0
SlowWavedat$TargetRep[SlowWavedat$currCondTrigger == 130 & SlowWavedat$prevCondTrigger == 110] = 0
SlowWavedat$TargetRep[SlowWavedat$currCondTrigger == 130 & SlowWavedat$prevCondTrigger == 130] = 0
SlowWavedat$TargetRep[SlowWavedat$currCondTrigger == 130 & SlowWavedat$prevCondTrigger == 150] = 0
SlowWavedat$TargetRep[SlowWavedat$currCondTrigger == 130 & SlowWavedat$prevCondTrigger == 170] = 1
SlowWavedat$TargetRep[SlowWavedat$currCondTrigger == 150 & SlowWavedat$prevCondTrigger == 110] = 1
SlowWavedat$TargetRep[SlowWavedat$currCondTrigger == 150 & SlowWavedat$prevCondTrigger == 130] = 0
SlowWavedat$TargetRep[SlowWavedat$currCondTrigger == 150 & SlowWavedat$prevCondTrigger == 150] = 0
SlowWavedat$TargetRep[SlowWavedat$currCondTrigger == 150 & SlowWavedat$prevCondTrigger == 170] = 0
SlowWavedat$TargetRep[SlowWavedat$currCondTrigger == 170 & SlowWavedat$prevCondTrigger == 110] = 0
SlowWavedat$TargetRep[SlowWavedat$currCondTrigger == 170 & SlowWavedat$prevCondTrigger == 130] = 1
SlowWavedat$TargetRep[SlowWavedat$currCondTrigger == 170 & SlowWavedat$prevCondTrigger == 150] = 0
SlowWavedat$TargetRep[SlowWavedat$currCondTrigger == 170 & SlowWavedat$prevCondTrigger == 170] = 0

SlowWavedat$FlankerRep = NA
SlowWavedat$FlankerRep[SlowWavedat$currCondTrigger == 110 & SlowWavedat$prevCondTrigger == 110] = 0
SlowWavedat$FlankerRep[SlowWavedat$currCondTrigger == 110 & SlowWavedat$prevCondTrigger == 130] = 0
SlowWavedat$FlankerRep[SlowWavedat$currCondTrigger == 110 & SlowWavedat$prevCondTrigger == 150] = 0
SlowWavedat$FlankerRep[SlowWavedat$currCondTrigger == 110 & SlowWavedat$prevCondTrigger == 170] = 1
SlowWavedat$FlankerRep[SlowWavedat$currCondTrigger == 130 & SlowWavedat$prevCondTrigger == 110] = 0
SlowWavedat$FlankerRep[SlowWavedat$currCondTrigger == 130 & SlowWavedat$prevCondTrigger == 130] = 0
SlowWavedat$FlankerRep[SlowWavedat$currCondTrigger == 130 & SlowWavedat$prevCondTrigger == 150] = 1
SlowWavedat$FlankerRep[SlowWavedat$currCondTrigger == 130 & SlowWavedat$prevCondTrigger == 170] = 0
SlowWavedat$FlankerRep[SlowWavedat$currCondTrigger == 150 & SlowWavedat$prevCondTrigger == 110] = 0
SlowWavedat$FlankerRep[SlowWavedat$currCondTrigger == 150 & SlowWavedat$prevCondTrigger == 130] = 1
SlowWavedat$FlankerRep[SlowWavedat$currCondTrigger == 150 & SlowWavedat$prevCondTrigger == 150] = 0
SlowWavedat$FlankerRep[SlowWavedat$currCondTrigger == 150 & SlowWavedat$prevCondTrigger == 170] = 0
SlowWavedat$FlankerRep[SlowWavedat$currCondTrigger == 170 & SlowWavedat$prevCondTrigger == 110] = 1
SlowWavedat$FlankerRep[SlowWavedat$currCondTrigger == 170 & SlowWavedat$prevCondTrigger == 130] = 0
SlowWavedat$FlankerRep[SlowWavedat$currCondTrigger == 170 & SlowWavedat$prevCondTrigger == 150] = 0
SlowWavedat$FlankerRep[SlowWavedat$currCondTrigger == 170 & SlowWavedat$prevCondTrigger == 170] = 0

write.table(SlowWavedat, "Created by R_ArtRej/SlowWave/FSW_AllSubs_TBT_Cond_Prev_Rep.txt", sep = "\t", row.names = F)

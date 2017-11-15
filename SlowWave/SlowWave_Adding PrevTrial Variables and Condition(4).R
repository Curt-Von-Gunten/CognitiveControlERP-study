require(dplyr)
require(lme4)
require(lmerTest)
require(ggplot2)

setwd("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave")
path = "C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"

# read in quantified SlowWave TBT data
SlowWavedat = read.delim("AllSubs_TBT_SlowWave_Cond.txt")

SlowWavedat$Condition = as.character(SlowWavedat$Condition)

# mark which trials not to use (the first of each block, since it doesn't have a previous trial)
trials = c(1, 101, 201, 301, 401, 501, 601, 701)
SlowWavedat$notFirst = 1
SlowWavedat$notFirst[SlowWavedat$Trial %in% trials] = 0

# take out subs 92 and 64
SlowWavedat = SlowWavedat[SlowWavedat$Subject != 92 & SlowWavedat$Subject != 64 & SlowWavedat$Subject != 65,] # only 37 subjects- where are the rest

SlowWavedat$prevCondTrigger = NA
SlowWavedat$prevCondAcc = 0

#setwd("C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing")

numAccTrials = NULL # will become data frame with number of trials accepted for each subject
for (i in unique(SlowWavedat$Subject)) {
  temp = SlowWavedat[SlowWavedat$Subject == i,]
  event = read.delim(paste(path, "Event_Stimulus_Files_NoZeros/", i, "flk_rev.ev2", sep=""), header=FALSE)
  names(event) = c("trial", "trigger", "C1", "Acc", "C3", "C4")
  # put in previous trial condition into SlowWave data set, pulling info from event file
  for (j in unique(temp$Trial[temp$notFirst == 1])) {
    SlowWavedat$prevCondTrigger[SlowWavedat$Subject == i & SlowWavedat$Trial == j] = event$trigger[event$trial == j - 1]
    SlowWavedat$prevCondAcc[SlowWavedat$Subject == i & SlowWavedat$Trial == j] = event$Acc[event$trial == j - 1]
  }
  # check number of trials accepted for each subject
  numAccTrials = rbind(numAccTrials, data.frame(Subject = i, numTrials = length(unique(temp$Trial))))
}

# add labels for trigger codes
SlowWavedat$prevCond = NA
SlowWavedat$prevCond[SlowWavedat$prevCondTrigger == 110|SlowWavedat$prevCondTrigger == 130] = "compat"
SlowWavedat$prevCond[SlowWavedat$prevCondTrigger == 150|SlowWavedat$prevCondTrigger == 170] = "incompat"

# put info for current and previous trial together
SlowWavedat$TrialCondition = NA
SlowWavedat$TrialCondition[SlowWavedat$prevCond == "compat" & SlowWavedat$Condition == "InComp"] = 
  "Previous compatible - Current incompatible"
SlowWavedat$TrialCondition[SlowWavedat$prevCond == "compat" & SlowWavedat$Condition == "Comp"] = 
  "Previous compatible - Current compatible"
SlowWavedat$TrialCondition[SlowWavedat$prevCond == "incompat" & SlowWavedat$Condition == "InComp"] = 
  "Previous incompatible - Current incompatible"
SlowWavedat$TrialCondition[SlowWavedat$prevCond == "incompat" & SlowWavedat$Condition == "Comp"] = 
  "Previous incompatible - Current compatible"
SlowWavedat$TrialCondition = factor(SlowWavedat$TrialCondition)

# only take correct trials
SlowWave.correct = subset(SlowWavedat, Acc == 1 & prevCondAcc == 1)

write.table(SlowWave.correct, "AllSubs_TBTaverages_SlowWave_Cond_withPrevious.txt", sep = "\t", row.names = F)

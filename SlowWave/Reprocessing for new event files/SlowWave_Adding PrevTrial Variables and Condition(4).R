
setwd("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing")
path = "C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"

# read in quantified SlowWave TBT data
SlowWavedat = read.delim("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/SlowWave/AllSubs_TBT_SlowWave_Cond_10subs.txt", header=T)

SlowWavedat$Condition = as.character(SlowWavedat$Condition)

# take out subs 92 and 64
SlowWavedat = SlowWavedat[SlowWavedat$Subject != 92 & SlowWavedat$Subject != 64 & SlowWavedat$Subject != 65,] # only 37 subjects- where are the rest

# mark which trials not to use (the first of each block, since it doesn't have a previous trial)
firstTrials_2 <- c(1, 101, 201, 300, 400, 500, 600, 699)
firstTrials_4 <- c(1, 100, 200, 285, 384, 484, 584, 684)
firstTrials_8 <- c(1, 100, 200, 300, 400, 500, 600, 700)
firstTrials_16 <- c(1, 100, 200, 299, 399, 499, 599, 699)
firstTrials_17 <- c(1, 101, 201, 301, 401, 501, 601, 700)
firstTrials_19 <- c(1, 100, 200, 300, 400, 500, 600, 700)
firstTrials_30 <- c(1, 100, 200, 300, 400, 500, 600, 700)
firstTrials_59 <- c(1, 100, 200, 300, 400, 500, 600, 700)
firstTrials_70 <- c(1, 100, 200, 300, 400, 500, 600, 700)
firstTrials_72 <- c(1, 101, 201, 301, 401, 501, 601, 701)
firstTrials_74= c(1, 101, 201, 301, 401, 501, 601, 701)
firstTrials_137= c(1, 101, 201, 301, 401, 501, 601, 701)

SlowWavedat$notFirst = 1
SlowWavedat$notFirst[SlowWavedat$Subject == 2 & SlowWavedat$Trial %in% firstTrials_2] = 0
SlowWavedat$notFirst[SlowWavedat$Subject == 4 & SlowWavedat$Trial %in% firstTrials_4] = 0
SlowWavedat$notFirst[SlowWavedat$Subject == 8 & SlowWavedat$Trial %in% firstTrials_8] = 0
SlowWavedat$notFirst[SlowWavedat$Subject == 16 & SlowWavedat$Trial %in% firstTrials_16] = 0
SlowWavedat$notFirst[SlowWavedat$Subject == 17 & SlowWavedat$Trial %in% firstTrials_17] = 0
SlowWavedat$notFirst[SlowWavedat$Subject == 19 & SlowWavedat$Trial %in% firstTrials_19] = 0
SlowWavedat$notFirst[SlowWavedat$Subject == 30 & SlowWavedat$Trial %in% firstTrials_30] = 0
SlowWavedat$notFirst[SlowWavedat$Subject == 59 & SlowWavedat$Trial %in% firstTrials_59] = 0
SlowWavedat$notFirst[SlowWavedat$Subject == 70 & SlowWavedat$Trial %in% firstTrials_70] = 0
SlowWavedat$notFirst[SlowWavedat$Subject == 72 & SlowWavedat$Trial %in% firstTrials_72] = 0
SlowWavedat$notFirst[SlowWavedat$Subject == 74 & SlowWavedat$Trial %in% firstTrials_74] = 0
SlowWavedat$notFirst[SlowWavedat$Subject == 74 & SlowWavedat$Trial %in% firstTrials_137] = 0

SlowWavedat$prevCondTrigger = NA
SlowWavedat$prevCondAcc = 0

numAccTrials = NULL # will become data frame with number of trials accepted for each subject
for (i in unique(SlowWavedat$Subject)) {
  temp = SlowWavedat[SlowWavedat$Subject == i,]
  event = read.delim(paste("./Event_Stimulus_Files/Modified_Event_Files_NoZeros/", i, "flk_rev_manuallymodifiedHVE.ev2", sep=""), header=FALSE)
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

write.table(SlowWave.correct, "Created by R_ArtRej/SlowWave/AllSubs_TBTaverages_SlowWave_Correct_withPrevious_10subs.txt", sep = "\t", row.names = F)
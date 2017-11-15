require(dplyr)
require(lme4)
require(lmerTest)
require(ggplot2)

setwd("C:/Users/psycworks/Desktop/Sequential Processing")
path = "C:/Users/psycworks/Desktop/Sequential Processing/"

# read in quantified N2 TBT data
N2dat = read.delim("AllSubs_TBTaverages_N2_Cond.txt")

N2dat$Condition = as.character(N2dat$Condition)

# mark which trials not to use (the first of each block, since it doesn't have a previous trial)
trials = c(1, 101, 201, 301, 401, 501, 601, 701)
N2dat$notFirst = 1
N2dat$notFirst[N2dat$Trial %in% trials] = 0

# take out subs 92 and 64
N2dat = N2dat[N2dat$Subject != 92 & N2dat$Subject != 64 & N2dat$Subject != 65,] # only 37 subjects- where are the rest

N2dat$prevCondTrigger = NA
N2dat$prevCondAcc = 0

numAccTrials = NULL # will become data frame with number of trials accepted for each subject
for (i in unique(N2dat$Subject)) {
  temp = N2dat[N2dat$Subject == i,]
  event = read.delim(paste("./Event files_NoZeros/", i, "flk_rev.ev2", sep=""), header=FALSE)
  names(event) = c("trial", "trigger", "C1", "Acc", "C3", "C4")
  # put in previous trial condition into N2 data set, pulling info from event file
  for (j in unique(temp$Trial[temp$notFirst == 1])) {
    N2dat$prevCondTrigger[N2dat$Subject == i & N2dat$Trial == j] = event$trigger[event$trial == j - 1]
    N2dat$prevCondAcc[N2dat$Subject == i & N2dat$Trial == j] = event$Acc[event$trial == j - 1]
  }
  # check number of trials accepted for each subject
  numAccTrials = rbind(numAccTrials, data.frame(Subject = i, numTrials = length(unique(temp$Trial))))
}

# add labels for trigger codes
N2dat$prevCond = NA
N2dat$prevCond[N2dat$prevCondTrigger == 110|N2dat$prevCondTrigger == 130] = "compat"
N2dat$prevCond[N2dat$prevCondTrigger == 150|N2dat$prevCondTrigger == 170] = "incompat"

# put info for current and previous trial together
N2dat$TrialCondition = NA
N2dat$TrialCondition[N2dat$prevCond == "compat" & N2dat$Condition == "InComp"] = 
  "Previous compatible - Current incompatible"
N2dat$TrialCondition[N2dat$prevCond == "compat" & N2dat$Condition == "Comp"] = 
  "Previous compatible - Current compatible"
N2dat$TrialCondition[N2dat$prevCond == "incompat" & N2dat$Condition == "InComp"] = 
  "Previous incompatible - Current incompatible"
N2dat$TrialCondition[N2dat$prevCond == "incompat" & N2dat$Condition == "Comp"] = 
  "Previous incompatible - Current compatible"
N2dat$TrialCondition = factor(N2dat$TrialCondition)

# only take correct trials
N2.correct = subset(N2dat, Acc == 1 & prevCondAcc == 1)

write.table(N2.correct, "AllSubs_TBTaverages_N2_Cond_withPrevious.txt", sep = "\t", row.names = F)
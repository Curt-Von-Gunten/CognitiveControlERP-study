

setwd("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing")
path = "C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"

# read in quantified N2 TBT data
N2dat = read.delim("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/N2/AllSubs_TBT_N2_Cond_10subs.txt", header=T)

N2dat$Condition = as.character(N2dat$Condition)

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

N2dat$notFirst = 1
N2dat$notFirst[N2dat$Subject == 2 & N2dat$Trial %in% firstTrials_2] = 0
N2dat$notFirst[N2dat$Subject == 4 & N2dat$Trial %in% firstTrials_4] = 0
N2dat$notFirst[N2dat$Subject == 8 & N2dat$Trial %in% firstTrials_8] = 0
N2dat$notFirst[N2dat$Subject == 16 & N2dat$Trial %in% firstTrials_16] = 0
N2dat$notFirst[N2dat$Subject == 17 & N2dat$Trial %in% firstTrials_17] = 0
N2dat$notFirst[N2dat$Subject == 19 & N2dat$Trial %in% firstTrials_19] = 0
N2dat$notFirst[N2dat$Subject == 30 & N2dat$Trial %in% firstTrials_30] = 0
N2dat$notFirst[N2dat$Subject == 59 & N2dat$Trial %in% firstTrials_59] = 0
N2dat$notFirst[N2dat$Subject == 70 & N2dat$Trial %in% firstTrials_70] = 0
N2dat$notFirst[N2dat$Subject == 72 & N2dat$Trial %in% firstTrials_72] = 0
N2dat$notFirst[N2dat$Subject == 74 & N2dat$Trial %in% firstTrials_74] = 0

N2dat$prevCondTrigger = NA
N2dat$prevCondAcc = 0

numAccTrials = NULL # will become data frame with number of trials accepted for each subject
for (i in unique(N2dat$Subject)) {
  temp = N2dat[N2dat$Subject == i,]
  event = read.delim(paste("./Event_Stimulus_Files/Modified_Event_Files_NoZeros/", i, "flk_rev_manuallymodifiedHVE.ev2", sep=""), header=FALSE)
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

write.table(N2.correct, "Created by R_ArtRej/N2/AllSubs_TBTaverages_N2_Correct_withPrevious_10subs.txt", sep = "\t", row.names = F)

setwd("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing")
path = "C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"

# read in quantified N1 TBT data
N1dat = read.delim("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/N1/AllSubs_TBT_N1_Cond_Prev.txt", header=T)

N1dat$Condition = as.character(N1dat$Condition)

# take out subs 92 and 64
N1dat = N1dat[N1dat$Subject != 92 & N1dat$Subject != 64 & N1dat$Subject != 65,] # only 37 subjects- where are the rest

#subsNormal <- c( "005",  "014", "032",    "055",  "060", "065", 
#                           "091",  "092", "100", "108", "115", "117", "135",   "013", 
#                  "021", "023", "024", "027",  "061", 
#                 "068", "071", "084", "104", "105", "112", "129")
subsNormal <- c( "5",  "14", "32",    "55",  "60", "65", 
                 "91",  "92", "100", "108", "115", "117", "135",   "13", 
                 "21", "23", "24", "27",  "61", 
                 "68", "71", "84", "104", "105", "112", "129", "137")
# mark which trials not to use (the first of each block, since it doesn't have a previous trial)
firstTrials_norm = c(1, 101, 201, 301, 401, 501, 601, 701)
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


N1dat$notFirst = 1
N1dat$notFirst[N1dat$Subject %in% subsNormal & N1dat$Trial %in% firstTrials_norm] = 0
N1dat$notFirst[N1dat$Subject == 2 & N1dat$Trial %in% firstTrials_2] = 0
N1dat$notFirst[N1dat$Subject == 4 & N1dat$Trial %in% firstTrials_4] = 0
N1dat$notFirst[N1dat$Subject == 8 & N1dat$Trial %in% firstTrials_8] = 0
N1dat$notFirst[N1dat$Subject == 16 & N1dat$Trial %in% firstTrials_16] = 0
N1dat$notFirst[N1dat$Subject == 17 & N1dat$Trial %in% firstTrials_17] = 0
N1dat$notFirst[N1dat$Subject == 19 & N1dat$Trial %in% firstTrials_19] = 0
N1dat$notFirst[N1dat$Subject == 30 & N1dat$Trial %in% firstTrials_30] = 0
N1dat$notFirst[N1dat$Subject == 59 & N1dat$Trial %in% firstTrials_59] = 0
N1dat$notFirst[N1dat$Subject == 70 & N1dat$Trial %in% firstTrials_70] = 0
N1dat$notFirst[N1dat$Subject == 72 & N1dat$Trial %in% firstTrials_72] = 0
N1dat$notFirst[N1dat$Subject == 74 & N1dat$Trial %in% firstTrials_74] = 0


N1dat$prevCondTrigger = NA
N1dat$prevCondAcc = 0

numAccTrials = NULL # will become data frame with number of trials accepted for each subject
for (i in unique(N1dat$Subject)) {
  temp = N1dat[N1dat$Subject == i,]
  event = read.delim(paste("./Event_Stimulus_Files_NoZeros/", i, "flk_rev.ev2", sep=""), header=FALSE)
  names(event) = c("trial", "trigger", "C1", "Acc", "C3", "C4")
  # put in previous trial condition into N1 data set, pulling info from event file
  for (j in unique(temp$Trial[temp$notFirst == 1])) {
    N1dat$prevCondTrigger[N1dat$Subject == i & N1dat$Trial == j] = event$trigger[event$trial == j - 1]
    N1dat$prevCondAcc[N1dat$Subject == i & N1dat$Trial == j] = event$Acc[event$trial == j - 1]
  }
  # check number of trials accepted for each subject
  numAccTrials = rbind(numAccTrials, data.frame(Subject = i, numTrials = length(unique(temp$Trial))))
}


# put info for current and previous trial together
N1dat$TrialCondition = NA
N1dat$TrialCondition[(N1dat$prevCondTrigger == 110 | N1dat$prevCondTrigger ==  130) & N1dat$Condition == "InComp"] = 
  "Previous compatible - Current incompatible"
N1dat$TrialCondition[(N1dat$prevCondTrigger == 110 | N1dat$prevCondTrigger ==  130) & N1dat$Condition == "Comp"] = 
  "Previous compatible - Current compatible"
N1dat$TrialCondition[(N1dat$prevCondTrigger == 150 | N1dat$prevCondTrigger ==  170) & N1dat$Condition == "InComp"] = 
  "Previous incompatible - Current incompatible"
N1dat$TrialCondition[(N1dat$prevCondTrigger == 150 | N1dat$prevCondTrigger ==  170) & N1dat$Condition == "Comp"] = 
  "Previous incompatible - Current compatible"
N1dat$TrialCondition = factor(N1dat$TrialCondition)

#Adding repetition type.
#Comp: Target Left, Flanker Left = 110.
#Comp: Target Right, Flanker Right = 130.
#Incomp: Target Left, Flanker Right = 150.
#Incomp: Target Right, Flanker Left = 170.
N1dat$CompleteRep = NA
N1dat$CompleteRep[N1dat$Tigger == 110 & N1dat$prevCondTrigger == 110] = 1
N1dat$CompleteRep[N1dat$Tigger == 110 & N1dat$prevCondTrigger == 130] = 0
N1dat$CompleteRep[N1dat$Tigger == 110 & N1dat$prevCondTrigger == 150] = 0
N1dat$CompleteRep[N1dat$Tigger == 110 & N1dat$prevCondTrigger == 170] = 0
N1dat$CompleteRep[N1dat$Tigger == 130 & N1dat$prevCondTrigger == 110] = 0
N1dat$CompleteRep[N1dat$Tigger == 130 & N1dat$prevCondTrigger == 130] = 1
N1dat$CompleteRep[N1dat$Tigger == 130 & N1dat$prevCondTrigger == 150] = 0
N1dat$CompleteRep[N1dat$Tigger == 130 & N1dat$prevCondTrigger == 170] = 0
N1dat$CompleteRep[N1dat$Tigger == 150 & N1dat$prevCondTrigger == 110] = 0
N1dat$CompleteRep[N1dat$Tigger == 150 & N1dat$prevCondTrigger == 130] = 0
N1dat$CompleteRep[N1dat$Tigger == 150 & N1dat$prevCondTrigger == 150] = 1
N1dat$CompleteRep[N1dat$Tigger == 150 & N1dat$prevCondTrigger == 170] = 0
N1dat$CompleteRep[N1dat$Tigger == 170 & N1dat$prevCondTrigger == 110] = 0
N1dat$CompleteRep[N1dat$Tigger == 170 & N1dat$prevCondTrigger == 130] = 0
N1dat$CompleteRep[N1dat$Tigger == 170 & N1dat$prevCondTrigger == 150] = 0
N1dat$CompleteRep[N1dat$Tigger == 170 & N1dat$prevCondTrigger == 170] = 1

N1dat$AnyRep = NA
N1dat$AnyRep[N1dat$Tigger == 110 & N1dat$prevCondTrigger == 110] = 1
N1dat$AnyRep[N1dat$Tigger == 110 & N1dat$prevCondTrigger == 130] = 0
N1dat$AnyRep[N1dat$Tigger == 110 & N1dat$prevCondTrigger == 150] = 1
N1dat$AnyRep[N1dat$Tigger == 110 & N1dat$prevCondTrigger == 170] = 1
N1dat$AnyRep[N1dat$Tigger == 130 & N1dat$prevCondTrigger == 110] = 0
N1dat$AnyRep[N1dat$Tigger == 130 & N1dat$prevCondTrigger == 130] = 1
N1dat$AnyRep[N1dat$Tigger == 130 & N1dat$prevCondTrigger == 150] = 1
N1dat$AnyRep[N1dat$Tigger == 130 & N1dat$prevCondTrigger == 170] = 1
N1dat$AnyRep[N1dat$Tigger == 150 & N1dat$prevCondTrigger == 110] = 1
N1dat$AnyRep[N1dat$Tigger == 150 & N1dat$prevCondTrigger == 130] = 1
N1dat$AnyRep[N1dat$Tigger == 150 & N1dat$prevCondTrigger == 150] = 1
N1dat$AnyRep[N1dat$Tigger == 150 & N1dat$prevCondTrigger == 170] = 0
N1dat$AnyRep[N1dat$Tigger == 170 & N1dat$prevCondTrigger == 110] = 1
N1dat$AnyRep[N1dat$Tigger == 170 & N1dat$prevCondTrigger == 130] = 1
N1dat$AnyRep[N1dat$Tigger == 170 & N1dat$prevCondTrigger == 150] = 0
N1dat$AnyRep[N1dat$Tigger == 170 & N1dat$prevCondTrigger == 170] = 1

N1dat$TargetRep = NA
N1dat$TargetRep[N1dat$Tigger == 110 & N1dat$prevCondTrigger == 110] = 0
N1dat$TargetRep[N1dat$Tigger == 110 & N1dat$prevCondTrigger == 130] = 0
N1dat$TargetRep[N1dat$Tigger == 110 & N1dat$prevCondTrigger == 150] = 1
N1dat$TargetRep[N1dat$Tigger == 110 & N1dat$prevCondTrigger == 170] = 0
N1dat$TargetRep[N1dat$Tigger == 130 & N1dat$prevCondTrigger == 110] = 0
N1dat$TargetRep[N1dat$Tigger == 130 & N1dat$prevCondTrigger == 130] = 0
N1dat$TargetRep[N1dat$Tigger == 130 & N1dat$prevCondTrigger == 150] = 0
N1dat$TargetRep[N1dat$Tigger == 130 & N1dat$prevCondTrigger == 170] = 1
N1dat$TargetRep[N1dat$Tigger == 150 & N1dat$prevCondTrigger == 110] = 1
N1dat$TargetRep[N1dat$Tigger == 150 & N1dat$prevCondTrigger == 130] = 0
N1dat$TargetRep[N1dat$Tigger == 150 & N1dat$prevCondTrigger == 150] = 0
N1dat$TargetRep[N1dat$Tigger == 150 & N1dat$prevCondTrigger == 170] = 0
N1dat$TargetRep[N1dat$Tigger == 170 & N1dat$prevCondTrigger == 110] = 0
N1dat$TargetRep[N1dat$Tigger == 170 & N1dat$prevCondTrigger == 130] = 1
N1dat$TargetRep[N1dat$Tigger == 170 & N1dat$prevCondTrigger == 150] = 0
N1dat$TargetRep[N1dat$Tigger == 170 & N1dat$prevCondTrigger == 170] = 0

N1dat$FlankerRep = NA
N1dat$FlankerRep[N1dat$Tigger == 110 & N1dat$prevCondTrigger == 110] = 0
N1dat$FlankerRep[N1dat$Tigger == 110 & N1dat$prevCondTrigger == 130] = 0
N1dat$FlankerRep[N1dat$Tigger == 110 & N1dat$prevCondTrigger == 150] = 0
N1dat$FlankerRep[N1dat$Tigger == 110 & N1dat$prevCondTrigger == 170] = 1
N1dat$FlankerRep[N1dat$Tigger == 130 & N1dat$prevCondTrigger == 110] = 0
N1dat$FlankerRep[N1dat$Tigger == 130 & N1dat$prevCondTrigger == 130] = 0
N1dat$FlankerRep[N1dat$Tigger == 130 & N1dat$prevCondTrigger == 150] = 1
N1dat$FlankerRep[N1dat$Tigger == 130 & N1dat$prevCondTrigger == 170] = 0
N1dat$FlankerRep[N1dat$Tigger == 150 & N1dat$prevCondTrigger == 110] = 0
N1dat$FlankerRep[N1dat$Tigger == 150 & N1dat$prevCondTrigger == 130] = 1
N1dat$FlankerRep[N1dat$Tigger == 150 & N1dat$prevCondTrigger == 150] = 0
N1dat$FlankerRep[N1dat$Tigger == 150 & N1dat$prevCondTrigger == 170] = 0
N1dat$FlankerRep[N1dat$Tigger == 170 & N1dat$prevCondTrigger == 110] = 1
N1dat$FlankerRep[N1dat$Tigger == 170 & N1dat$prevCondTrigger == 130] = 0
N1dat$FlankerRep[N1dat$Tigger == 170 & N1dat$prevCondTrigger == 150] = 0
N1dat$FlankerRep[N1dat$Tigger == 170 & N1dat$prevCondTrigger == 170] = 0


# only take correct trials
N1.correct = subset(N1dat, Acc == 1 & prevCondAcc == 1)

write.table(N1.correct, "Created by R_ArtRej/N1/AllSubs_TBT_N1_Cond_Prev_Rep.txt", sep = "\t", row.names = F)
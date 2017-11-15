

#####################################################################
###               Merging RT, N1, N2, SlowWave datsets                ###
#####################################################################
setwd("C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej")
path = "C:/Users/cdvrmd/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/"

#Reading in the RT, N2, SlowWave data sets. The ERP sets have had incorrect and art rejected trials removed.
RTdat = read.delim(paste(path, "RT/","RT_TrialsRemovedforMerging.txt", sep = ""))

N1dat = read.delim(paste(path, "N1/","N1_AllSubs_TBT_Cond_Prev_Rep.txt", sep = ""))

# add labels for trigger codes
N1dat$prevCond = NA
N1dat$prevCond[N1dat$prevCondTrigger == 110|N1dat$prevCondTrigger == 130] = "compat"
N1dat$prevCond[N1dat$prevCondTrigger == 150|N1dat$prevCondTrigger == 170] = "incompat"

#write.table(N1dat, paste(path, "N1/","N1_AllSubs_TBT_Cond_Prev_Rep.txt", sep=""), sep = "\t", row.names = F)

N2dat = read.delim(paste(path, "N2/","N2_AllSubs_TBT_Cond_Prev_Rep.txt", sep = ""))

SlowWavedat = read.delim(paste(path, "SlowWave/", "FSW_AllSubs_TBT_Cond_Prev_Rep.txt", sep = ""))

colnames(N1dat) <- c("Subject", "Trial", "Electrode", "N1curr", "Acc", "Condition", "currCondTrigger", "N1Prev", "notFirst", 
                     "prevCondTrigger", "prevCondAcc", "TrialCondition", "CompleteRep", "AnyRep", "TargetRep", "FlankerRep", "prevCond")

N1dat_Order <- N1dat[,c(1,2,3,4,5,6,9,10,11,17,12,7,13,14,15,16)]

colnames(N2dat) <- c("Subject", "Trial", "Electrode", "N2curr", "Acc", "Condition", "notFirst", 
                     "prevCondTrigger", "prevCondAcc", "prevCond", "TrialCondition", "currCondTrigger", "CompleteRep", "AnyRep", "TargetRep", "FlankerRep")

colnames(SlowWavedat) <- c("Subject", "Trial", "Electrode", "SlowWavecurr", "Acc", "Condition", "notFirst", 
                           "prevCondTrigger", "prevCondAcc", "prevCond", "TrialCondition", "currCondTrigger", "CompleteRep", "AnyRep", "TargetRep", "FlankerRep")


sum(table(unique(N1dat$Subject)))
sum(table(unique(N2dat$Subject)))
sum(table(unique(SlowWavedat$Subject)))

sum(table(unique(N1dat$Trial)))
sum(table(unique(N2dat$Trial)))
sum(table(unique(SlowWavedat$Trial)))

#Merging just N2 and SlowWave first. Can's use "by" if the varibles aren't in both datasets.
N2_SlowWave_dat <- merge(N1dat_Order, N2dat, SlowWavedat, by  = c("Subject", "Trial", "Electrode",
                                                    "Acc", "Condition", "notFirst", 
                                                    "prevCondTrigger", "prevCondAcc", "prevCond", "TrialCondition", "currCondTrigger", "CompleteRep", "AnyRep", "TargetRep", "FlankerRep"))
head(N2_SlowWave_dat)
tail(N2_SlowWave_dat)


#Merging N1 in.
N1_N2_SlowWave_dat <- merge(N1dat_Order, N2_SlowWave_dat, by = c("Subject", "Trial", "Electrode",
                                                    "Acc", "Condition", "notFirst", 
                                                    "prevCondTrigger", "prevCondAcc", "TrialCondition", "CompleteRep", "AnyRep", "TargetRep", "FlankerRep"))
head(N1_N2_SlowWave_dat)
tail(N1_N2_SlowWave_dat)

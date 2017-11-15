#library() 
require(dplyr)
require(lme4)
require(lmerTest)
require(ggplot2)
search()

setwd("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej")
TrialElectLev_dat = read.delim("RT_N2_SlowWave_trial&ElecLev_R.txt")
MeanCent_dat = read.delim("RT_N2_SlowWave_MeanCent_R.txt" )


#Testing which random effects to include in models.
#To do this, incrementally remove the least significant effects until
#model converges. But remove interactions before main efects.
#**************************************************************************************************************
#  ************************Separate Variable Analyses************************;
#RT.
#Failed to converge.
RT_Sep_Out = lmer(RT ~ 1 +  
            (Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(RT_Sep_Out)
#Did not converge.
#Removing interaction.
RT_Sep_NoInt_Out = lmer(RT ~ 1 +  
                    (Curr+Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(RT_Sep_NoInt_Out)

#N2.
N2_Sep_Out = lmer(N2Curr ~ 1 +  
                    (Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(N2_Sep_Out)
#Correlation of .89.
#Removing interaction.
N2_Sep_Out = lmer(N2Curr ~ 1 +  
                    (Curr+Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(N2_Sep_Out)

#SW.
SW_Sep_Out = lmer(SlowWaveCurr ~ 1 +  
                    (Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(SW_Sep_Out)
#Correlation of .53. Retaining this model.

#**************************************************************************************************************
#  ************************Disaggregation************************;
#N2.
Dis_N2_Out = lmer(N2Curr ~ 1 +  
                    (SWPrevCent|Subject), data = MeanCent_dat)
summary(Dis_N2_Out)

#RT.
Dis_RT_Out = lmer(RT ~ 1 +  
                    (SWPrevCent|Subject), data = MeanCent_dat)
summary(Dis_RT_Out)


#**************************************************************************************************************
#************************Separate Analyses Across Time************************;
#RT.
RT_Time_Out = lmer(RT ~ 1 +  
                    (Trial*Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(RT_Time_Out)
#Removing three-way interaction.
RT_Time_Out = lmer(RT ~ 1 +  
                     (Trial*Curr + Trial*Prev + Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(RT_Time_Out)
#Removing Trial*Curr interaction
RT_Time_TimePrevRem_Out = lmer(RT ~ 1 +  
                     (Trial*Prev + Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(RT_Time_TimePrevRem_Out)
#Removing Prev*Curr interaction
RT_Time_TimePrevCurrPrevRem_Out = lmer(RT ~ 1 +  
                                 (Trial*Prev+Curr|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(RT_Time_TimePrevCurrPrevRem_Out)
#Removing final interaction.
RT_Time_AllIntsRem_Out = lmer(RT ~ 1 +  
                                         (Curr+Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(RT_Time_AllIntsRem_Out)

#N2.
N2_Time_Out = lmer(N2Curr ~ 1 +  
                    (Trial*Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(N2_Time_Out)
#Removing three-way.
N2_Time_Out = lmer(N2Curr ~ 1 +  
                     (Trial*Curr + Trial*Prev + Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(N2_Time_Out)
#Failed to converge.
#Removing Trial*Prev.
N2_Time_TrialPrevRem_Out = lmer(N2Curr ~ 1 +  
                     (Trial*Curr + Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(N2_Time_TrialPrevRem_Out)
#Failed to converge.
#Removing Trial*Curr..
N2_Time_TrialPrevTrialCurrRem_Out = lmer(N2Curr ~ 1 +  
                                  (Curr+Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(N2_Time_TrialPrevTrialCurrRem_Out)
#Converged but contained a correlation of .89.
#Removing final interaction.
N2_Time_AllIntsRem_Out = lmer(N2Curr ~ 1 +  
                                           (Curr+Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(N2_Time_AllIntsRem_Out)

#SW.
SW_Time_Out = lmer(SlowWaveCurr ~ 1 +  
                    (Trial*Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(SW_Time_Out)
#Removig three-way.
SW_Time_Out = lmer(SlowWaveCurr ~ 1 +  
      (Trial*Curr + Trial*Prev + Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(SW_Time_Out)
#Did not converge.
#Removing Trial*Curr.
SW_Time_TrialCurrRem_Out = lmer(SlowWaveCurr ~ 1 +  
                     (Trial*Prev + Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(SW_Time_TrialCurrRem_Out)
#Did not converge.
#Removing Trial*Prev.
SW_Time_TrialCurrTrialPrevRem_Out = lmer(SlowWaveCurr ~ 1 +  
                                  (Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(SW_Time_TrialCurrTrialPrevRem_Out)
#Converged. Contained correlation of .53. Retain this model.


#**************************************************************************************************************
#  ************************Difference Scores Across Time************************;
#SlowWavePrev and N2Curr difference scores across Trial.
N2_SW_diff_Out = lmer(N2_SW_diff ~ 1 +  
                    (Trial*Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(N2_SW_diff_Out)
#Removing three-way.
N2_SW_diff_Out = lmer(N2_SW_diff ~ 1 +  
                    (Trial*Curr + Trial*Prev + Curr*Prev|Subject)  + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(N2_SW_diff_Out)
#Did not converge.
#Removing Trial*Prev.
N2_SW_diff_TrialPrevRem_Out = lmer(N2_SW_diff ~ 1 +  
                        (Trial*Curr + Curr*Prev|Subject)  + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(N2_SW_diff_TrialPrevRem_Out)
#Did not converge.
#Removing Trial*Curr.
N2_SW_diff_TrialPrevTrialCurrRem_Out = lmer(N2_SW_diff ~ 1 +  
                                     (Curr*Prev|Subject)  + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(N2_SW_diff_TrialPrevTrialCurrRem_Out)
#Use this model.

#SlowWavePrev and N2Curr difference scores across Trial.
RT_SW_diff_Out = lmer(RT_SW_diff ~ 1 +  
                        (Trial*Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(RT_SW_diff_Out)
#Removing three-way.
RT_SW_diff_Out = lmer(RT_SW_diff ~ 1 +  
                        (Trial*Curr + Trial*Prev + Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(RT_SW_diff_Out)
#Removing Trial*Curr.
RT_SW_diff_TrialCurrRem_Out = lmer(RT_SW_diff ~ 1 +  
                        (Trial*Prev + Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(RT_SW_diff_TrialCurrRem_Out)
#Removing Trial*Prev.
RT_SW_diff_TrialCurrTrialPrevRem_Out = lmer(RT_SW_diff ~ 1 +  
                                     (Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(RT_SW_diff_TrialCurrTrialPrevRem_Out)
#Converged. Has correlation of .76. Using this model.


#SlowWavePrev and N2Curr difference scores across Trial.
RT_N2_diff_Out = lmer(RT_N2_diff ~ 1 +  
                        (Trial*Curr*Prev|Subject) + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(RT_N2_diff_Out)
#Removing three-way.
RT_N2_diff_Out = lmer(RT_N2_diff ~ 1 +  
                    (Trial*Curr + Trial*Prev + Curr*Prev|Subject)  + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(RT_N2_diff_Out)
#Failed to converge.
#Removing Trial*Curr..
RT_N2_diff_TrialCurrRem_Out = lmer(RT_N2_diff ~ 1 +  
                        (Trial*Prev + Curr*Prev|Subject)  + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(RT_N2_diff_TrialCurrRem_Out)
#Failed to converge.
#Removing Trial*Prev.
RT_N2_diff_TrialCurrTrialPrevRem_Out = lmer(RT_N2_diff ~ 1 +  
                                     (Curr*Prev|Subject)  + (1|Electrode:Subject), data = TrialElectLev_dat)
summary(RT_N2_diff_TrialCurrTrialPrevRem_Out)


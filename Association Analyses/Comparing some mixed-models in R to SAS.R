
#library() 
require(dplyr)
require(lme4)
require(lmerTest)
require(ggplot2)
search()

setwd("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej")
TrialElectLev_dat = read.delim("RT_N2_SlowWave_trial&ElecLev_R.txt")
MeanCent_dat = read.delim("RT_N2_SlowWave_MeanCent_R.txt" )



#Comparing an association model to SAS. Same output!
m1 = lmer(N2Curr ~ slowWavePrev*Cell + 
            (SlowWavePrev|Subject) + (1|Electrode:Subject), data = Seq_Eff)

summary(m1)
anova(m1)
lsmeans(m1)

#The model with Prev and Curr as random effects.
m2 = lmer(SlowWavePrev ~ Prev*Curr + 
            (Prev*Curr|Subject) + (1|Electrode:Subject), data = Seq_Eff)
summary(m2)
anova(m2)
lsmeansLT(m2)

#The model with Prev and Curr as random effects.
m3 = lmer(SlowWavePrev ~ Prev*Curr + 
            (1|Subject) + (1|Electrode:Subject), data = Seq_Eff)
summary(m3)
anova(m3)
lsmeansLT(m3)

#The model with Prev and Curr as random effects.
m4 = lmer(SlowWavePrev ~ Prev*Curr + 
            (Prev + Curr|Subject) + (1|Electrode:Subject), data = Seq_Eff)
summary(m4)
anova(m4)
lsmeans(m4)





#All Random Effects. Do this to test what random effects to include. Remove the least significant effects until
#model converges. But remove interactions before main efects.
m1 = lmer(N2Curr ~ 1 +  
            (SlowWavePrev*Cell|Subject) + (1|Electrode:Subject), data = Seq_Eff)

summary(m1)
#Removing the interaction.
m1 = lmer(N2Curr ~ 1 +  
            (SlowWavePrev + Cell|Subject) + (1|Electrode:Subject), data = Seq_Eff)

summary(m1)



#Disaggregating after removing Electrode.
Seq_Eff_MeanCent = read.delim("RT_N2_SlowWave_MeanCent.txt")

Seq_Eff_MeanCent$Trial <- Seq_Eff_MeanCent$Trial/10

m1 = lmer(N2Curr ~ SWPrevMean + SWPrevCent +
            (1 + SWPrevCent|Subject) + (1|Subject), data = Seq_Eff_MeanCent)

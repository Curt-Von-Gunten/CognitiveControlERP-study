require(dplyr)
require(lme4)
require(lmerTest)
require(ggplot2)

setwd("C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R")
path = "C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/"

SlowWave.correct = read.delim("AllSubs_TBTaverages_SlowWave_Cond.txt")

#First, here's the plot showing N2 amplitude across trial with separate regression lines 
#fitted for each condition. (Data points are averaged over electrode and subject, as well 
#as zoomed in for ease of viewing. Because of this, the slopes won't be exactly what comes 
#out of the model, it's just meant to be a visual aid.


# summarise across subjects and electrodes for plotting
dat.condense = 
  select(SlowWave.correct, Subject, Trial, MeanCurr, Condition) %>% 
  group_by(Subject, Condition) %>% 
  summarize(funs(mean)) %>% 
  as.data.frame()


  
  dat1 <- select(SlowWave.correct, Subject, Trial, MeanCurr, Condition)
  dat2 <- group_by(dat1, Subject, Condition)
  (Means <- summarize(dat2, mean(MeanCurr)))
  
  
  dat.condense = 

  as.data.frame()

  
  
  distinct(SlowWave.correct, Trial, MeanCurr)

library(psych)

setwd("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/N2")
path = "C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/N2/"
N2dat = read.delim("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/N2/AllSubs_TBTaverages_N2_Correct_withPrevious.txt", header=T)
N2dat_10subs = read.delim("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/N2/AllSubs_TBTaverages_N2_Correct_withPrevious_10subs.txt", header=T)

sublist1 <- c("002", "004", "008", "016", "017", "019", "030", "059", "070", "074")
sublist2 <- c(2, 4, 8, 16, 17, 19, 30, 59, 70, 74) 

#N2datshort = N2dat[N2dat$Subject %in% sublist2] 

N2dat_short = N2dat[N2dat$Subject != 2 & N2dat$Subject != 4 & N2dat$Subject != 8 &
                   N2dat$Subject != 16 & N2dat$Subject != 17 & N2dat$Subject != 19 &
                   N2dat$Subject != 30 & N2dat$Subject != 59 & N2dat$Subject != 70 &
                   N2dat$Subject != 74,] 
unique(N2dat_short$Subject)
unique(N2dat_10subs$Subject)

N2dat_All <- rbind(N2dat_10subs, N2dat_short)

unique(N2dat$Subject)
unique(N2dat_short$Subject)
unique(N2dat_10subs$Subject)
unique(N2dat_All$Subject)
describe(unique(N2dat$Subject))
describe(unique(N2dat_short$Subject))
describe(unique(N2dat_10subs$Subject))
describe(unique(N2dat_All$Subject))

write.table(N2dat_All, paste(path,"AllSubs_TBTaverages_N2_Correct_withPrevious_EventFixed.txt", sep=""), sep = "\t", row.names = F)
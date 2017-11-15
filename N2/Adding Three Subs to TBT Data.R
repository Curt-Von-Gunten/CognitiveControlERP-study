
setwd("C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/N2")
path = "C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/N2/"
N2dat = read.delim("C:/Users/psycworks/Desktop/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/N2/AllSubs_TBT_N2.txt", header=T)

N2datshort = N2dat[N2dat$Subject != 19 & N2dat$Subject != 74 & N2dat$Subject != 137,] 

sublist <- c( "019", "074",  "137")

for (k in sublist) {
  
  tempSub = read.delim(paste(path, k, "_TBT_N2.txt", sep=""))
  
  QuantDat = rbind(N2datshort, tempSub)
  
}


write.table(QuantDat, paste(path,"AllSubs_TBT_N2_3Subs.txt", sep=""), sep = "\t", row.names = F)
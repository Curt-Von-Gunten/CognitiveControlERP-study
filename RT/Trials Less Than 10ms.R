
setwd("C:/Users/Curt/Box Sync/Bruce Projects/Sequential Processing/PointByPoint Processing/Created by R_ArtRej/RT")


RTdat = read.delim("FlankerRT_forR.txt")


RT_Outs <- RTdat[RTdat$RT_Raw < 11,]
print(RT_Outs)

write.table(RT_Outs, "RT_Trials Less than 10ms.txt", sep = "\t", row.names = F)


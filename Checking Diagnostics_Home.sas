
*SlowWave ArtRej with Prev;
Title 'SlowWave with Prev Info';
PROC IMPORT OUT= WORK.SlowWave_PBP_Trimmed_Cond_Prev
            DATAFILE= "C:\Users\Curt\Box Sync\Bruce Project
s\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\SlowWave\SlowWave_TBT_Cond_Wprev_3subs.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
PROC UNIVARIATE DATA = SlowWave_pbp_trimmed_Cond_Prev;
VAR MeanCurr;
Histogram MeanCurr;
RUN;

*N2 ArtRej with Prev;
Title 'N2 with Prev Info';
PROC IMPORT OUT= WORK.N2_PBP_Trimmed_Cond_Prev
            DATAFILE= "C:\Users\Curt\Box Sync\Bruce Project
s\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\N2\AllSubs_TBTaverages_N2_Correct_withPrevious.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
PROC UNIVARIATE DATA = N2_pbp_trimmed_Cond_Prev;
VAR MeanCurr;
Histogram MeanCurr;
RUN;

PROC SORT DATA = SlowWave_pbp_trimmed_Cond_Prev;
BY Subject Trial;
RUN;
PROC SORT DATA = N2_pbp_trimmed_Cond_Prev;
BY Subject Trial;
RUN;
Data N2_SlowWave_dat;
Merge SlowWave_pbp_trimmed_Cond_Prev N2_PBP_Trimmed_Cond_Prev;
By Subject Trial;
Run;

*RT;
PROC IMPORT OUT= WORK.RT_PBP_Trimmed_Cond_Prev
            DATAFILE= "C:\Users\Curt\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT\FlankerRT_forR.txt"
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
PROC UNIVARIATE DATA = RT_pbp_trimmed_Cond_Prev;
VAR MeanCurr;
Histogram MeanCurr;
RUN;


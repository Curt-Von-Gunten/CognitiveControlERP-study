
*N2 Without Art Rej;
PROC IMPORT OUT= WORK.N2_PBP_Trimmed 
            DATAFILE= "C:\Users\psycworks\Desktop\Box Sync\Bruce Project
s\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\N2\A
llSubs_TBT_N2.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
PROC UNIVARIATE DATA = N2_pbp_trimmed;
VAR MeanCurr;
RUN;

*N2 ArtRej;
Title 'N2';
PROC IMPORT OUT= WORK.N2_PBP_Trimmed_Cond 
            DATAFILE= "C:\Users\psycworks\Desktop\Box Sync\Bruce Project
s\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\N2\A
llSubs_TBT_N2_Cond.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
PROC UNIVARIATE DATA = N2_pbp_trimmed_Cond;
VAR MeanCurr;
RUN;

*SlowWave ArtRej without Prev;
Title 'SlowWave';
PROC IMPORT OUT= WORK.SlowWave_PBP_Trimmed_Cond 
            DATAFILE= "C:\Users\psycworks\Desktop\Box Sync\Bruce Project
s\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\SlowWave\A
llSubs_TBT_SlowWave_Cond.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
PROC UNIVARIATE DATA = SlowWave_pbp_trimmed_Cond;
VAR MeanCurr;
RUN;

*SlowWave ArtRej with Prev;
Title 'SlowWave with Prev Info';
PROC IMPORT OUT= WORK.SlowWave_PBP_Trimmed_Cond_Prev
            DATAFILE= "C:\Users\psycworks\Desktop\Box Sync\Bruce Project
s\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\SlowWave\SlowWave_TBT_Cond_Wprev_3subs.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
PROC UNIVARIATE DATA = SlowWave_pbp_trimmed_Cond_Prev;
VAR MeanCurr;
RUN;

*N2 ArtRej with Prev;
Title 'N2 with Prev Info';
PROC IMPORT OUT= WORK.N2_PBP_Trimmed_Cond_Prev
            DATAFILE= "C:\Users\psycworks\Desktop\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\N2\N2_TBT_Cond_Wprev_3subs.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
PROC UNIVARIATE DATA = N2_pbp_trimmed_Cond_Prev;
VAR MeanCurr;

PROC SORT DATA=N2_pbp_trimmed_Cond_Prev;
  BY Subject; 
RUN;
RUN; 
PROC SORT DATA=SlowWave_pbp_trimmed_Cond_Prev;
  BY Subject; 
RUN; 
Data N2_SlowWave_dat;
Merge SlowWave_PBP_Trimmed_Cond SlowWave_PBP_Trimmed_Cond_Prev;
By Subject;
Run;

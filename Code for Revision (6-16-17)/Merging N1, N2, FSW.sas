PROC IMPORT OUT= WORK.FSW 
            DATAFILE= "C:\Users\cdvrmd\Box Sync\Bruce Projects\Sequentia
l Processing\PointByPoint Processing\Created by R_ArtRej\SlowWave\FSW_Al
lSubs_TBT_Cond_Prev_Rep.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
PROC IMPORT OUT= WORK.N2 
            DATAFILE= "C:\Users\cdvrmd\Box Sync\Bruce Projects\Sequentia
l Processing\PointByPoint Processing\Created by R_ArtRej\N2\N2_Al
lSubs_TBT_Cond_Prev_Rep.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
PROC IMPORT OUT= WORK.N1
            DATAFILE= "C:\Users\cdvrmd\Box Sync\Bruce Projects\Sequentia
l Processing\PointByPoint Processing\Created by R_ArtRej\N1\N1_Al
lSubs_TBT_Cond_Prev_Rep.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;


DATA N1;
SET N1;
rename MeanCurr = N1Curr; 
RUN;
DATA N2;
SET N2;
rename MeanCurr = N2Curr; 
RUN;
DATA FSW;
SET FSW;
rename MeanCurr = SlowWaveCurr; 
RUN;


DATA N1_N2_FSW;
MERGE N1 N2 FSW;
RUN;
Proc Contents DATA = N1_N2_FSW;
RUN;

Proc Export DATA = N1_N2_FSW REPLACE
Outfile = "C:\Users\cdvrmd\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\Revision Data Sets\N1_N2_FSW.txt"
DBMS = TAB;
RUN;

DATA N1_N2_FSW_Del;
SET N1_N2_FSW;
IF SlowWaveCurr = . THEN DELETE;
IF N1Curr = . THEN DELETE;
RUN;

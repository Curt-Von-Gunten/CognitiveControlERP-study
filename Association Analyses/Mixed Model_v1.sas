**************************************************************************************************************
**************************************************************************************************************
*Eletrtrode Level (collapsed over trial);
*Electrode and Trial level;
PROC IMPORT OUT= WORK.Seq_Eff_ElectLev
            DATAFILE= "C:\Users\cdvrmd\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_ElecLev.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
*Laptop;
PROC IMPORT OUT= WORK.Seq_Eff_ElectLev
            DATAFILE= "C:\Users\Curt\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_ElecLev.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

DATA Seq_Eff_ElectLev;
SET Seq_Eff_ElectLev;
IF Cell = "Previous compatible - Current incompatible" THEN Prev = "Comp";
IF Cell = "Previous compatible - Current compatible" THEN Prev = "Comp";
IF Cell = "Previous incompatible - Current incompatible" THEN Prev = "InComp";
IF Cell = "Previous incompatible - Current compatible" THEN Prev = "InComp";
IF Cell = "Previous compatible - Current incompatible" THEN Curr = "InComp";
IF Cell = "Previous compatible - Current compatible" THEN Curr = "Comp";
IF Cell = "Previous incompatible - Current incompatible" THEN Curr = "InComp";
IF Cell = "Previous incompatible - Current compatible" THEN Curr = "Comp";
RUN;
*Descriptives;
Proc Means data=Seq_Eff_ElectLev;
var RT N2Curr SlowWaveCurr SlowWavePrev
;
Title 'General Means (Collapsed over Trial)';
Run;
Proc Means data=Seq_Eff_ElectLev;
Class Cell;
var RT N2Curr SlowWaveCurr SlowWavePrev;
Title 'Means by Condition';
Run;
PROC UNIVARIATE data=Seq_Eff_ElectLev;
var RT N2Curr SlowWaveCurr SlowWavePrev;
Histogram RT N2Curr SlowWaveCurr SlowWavePrev;
RUN;

*SlowWavePrev Predictd N2Curr with random intercepts of Subject and Electrode;
proc mixed data=Seq_Eff_ElectLev covtest ratio;
class Subject Electrode Cell;
model  N2Curr = SlowWavePrev|Cell/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
*lsmeans Cell/pdiff tdiff;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Cell 1 0 0 0;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Cell 0 1 0 0;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 1 0;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 0 1;
title "SWPrev -> N2Curr (Electrode Level: Random Intercept of Sub and Elect)";
run;
*Using Prev and Curr varibles;
proc mixed data=Seq_Eff_ElectLev covtest;
class Subject Electrode Curr Prev;
model  N2Curr = SlowWavePrev|Prev|Curr/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
*lsmeans Cell/pdiff tdiff;
title "Flipping DV and IV";
run;

*SlowWaveCurr Predictd N2Curr with random intercepts of Subject and Electrode;
proc mixed data=Seq_Eff_ElectLev covtest ratio;
class Subject Electrode Cell;
model  N2Curr = SlowWaveCurr|Cell/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
estimate 'Slope'         SlowWaveCurr 1  SlowWaveCurr*Cell 1 0 0 0;
estimate 'Slope'         SlowWaveCurr 1  SlowWaveCurr*Cell 0 1 0 0;
estimate 'Slope'         SlowWaveCurr 1  SlowWaveCurr*Cell 0 0 1 0;
estimate 'Slope'         SlowWaveCurr 1  SlowWaveCurr*Cell 0 0 0 1;
title "SWCurr -> N2Curr (Electrode Level: Random Intercept of Sub and Elect)";
run;

*Duplicating with manual estimates;
proc mixed data=Seq_Eff_ElectLev covtest ratio;
class Subject Electrode Cell;
model  N2Curr = SlowWavePrev|Cell/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
   estimate 'Mean of Ref' intercept 1  Cell 0 0 0 1  SlowWavePrev 0;
   estimate 'Prev compat-Curr compat'    Cell 1 0 0 -1  SlowWavePrev 0;
   estimate 'Prev compat-Curr incompat'    Cell 0 1 0 -1  SlowWavePrev 0;
   estimate 'Prev incompat-Curr compat'    Cell 0 0 1 -1  SlowWavePrev 0;
   estimate 'Slope of Ref'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 0 1;
   estimate 'SlopeDiff of Prev compat-Curr compat'  SlowWavePrev*Cell 1 0 0 -1;
   estimate 'SlopeDiff of Prev compat-Curr incompat'  SlowWavePrev*Cell 0 1 0 -1;
   estimate 'SlopeDiff of Prev incompat-Curr compat'  SlowWavePrev*Cell 0 0 1 -1;
   title "SWPrev -> N2Curr (Electrode Level: Random Intercept of Sub and Elect)";
   RUN;
*Changing reference condition;
proc mixed data=Seq_Eff_ElectLev covtest ratio;
class Subject Electrode Cell;
model  N2Curr = SlowWavePrev|Cell/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
   estimate 'Mean of Ref' intercept 1  Cell 1 0 0 0  SlowWavePrev 0;
   estimate 'Prev compat-Curr incompat'    Cell -1 1 0 0  SlowWavePrev 0;
   estimate 'Prev incompat-Curr compat'    Cell -1 0 1 0  SlowWavePrev 0;
   estimate 'Prev incompat-Curr incompat'    Cell -1 0 0 1  SlowWavePrev 0;
   estimate 'Slope of Ref'         SlowWavePrev 1  SlowWavePrev*Cell 1 0 0 0;
   estimate 'SlopeDiff of Prev compat-Curr incompat'  SlowWavePrev*Cell -1 1 0 0;
   estimate 'SlopeDiff of Prev incompat-Curr compat'  SlowWavePrev*Cell -1 0 1 0;
   estimate 'SlopeDiff of Prev incompat-Curr incompat'  SlowWavePrev*Cell -1 0 0 1;
   title "SWPrev -> N2Curr (Electrode Level: Random Intercept of Sub and Elect)";
   RUN;
  


**************************************************************************************************************
**************************************************************************************************************
*Electrode and Trial level for Trial Difference Analyses;
PROC IMPORT OUT= WORK.Seq_Eff
            DATAFILE= "C:\Users\cdvrmd\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_Trial&ElecLev.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
*Laptop;
PROC IMPORT OUT= WORK.Seq_Eff
            DATAFILE= "C:\Users\Curt\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_Trial&ElecLev.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

DATA Seq_Eff;
SET Seq_Eff;
IF Cell = "Previous compatible - Current incompatible" THEN Prev = "Comp";
IF Cell = "Previous compatible - Current compatible" THEN Prev = "Comp";
IF Cell = "Previous incompatible - Current incompatible" THEN Prev = "InComp";
IF Cell = "Previous incompatible - Current compatible" THEN Prev = "InComp";
IF Cell = "Previous compatible - Current incompatible" THEN Curr = "InComp";
IF Cell = "Previous compatible - Current compatible" THEN Curr = "Comp";
IF Cell = "Previous incompatible - Current incompatible" THEN Curr = "InComp";
IF Cell = "Previous incompatible - Current compatible" THEN Curr = "Comp";
RUN;

options nodate nonumber nocenter;
title "ATS SAS FAQ";
title2 "Output to PDF";
ods pdf file="C:\Users\cdvrmd\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Code\Code for Art Rej Data\Association Analyses\reg1.pdf" 
contents = yes pdftoc = 2;
*Descriptives;
Proc Means data=Seq_Eff;
var RT N2Curr SlowWaveCurr SlowWavePrev;
Title 'General Means (Trial and Electrode';
Run;
quit;
ods pdf close;

Proc Means data=Seq_Eff;
Class Cell;
var RT N2Curr SlowWaveCurr SlowWavePrev;
Title 'Means by Condition';
Run;
PROC UNIVARIATE data=Seq_Eff NOPRINT;
var RT N2Curr SlowWaveCurr SlowWavePrev;
Histogram RT N2Curr SlowWaveCurr SlowWavePrev;
RUN;

*SlowWavePrev Predictd N2Curr with random intercepts of Subject and Electrode;
proc mixed data=Seq_Eff covtest;
class Subject Electrode Cell;
model  N2Curr = SlowWavePrev/SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
estimate 'Slope Average'         SlowWavePrev 1;
title "Trial Level Data: Random Intercept of Sub and Elect";
run;
*SlowWavePrev Predictd N2Curr with random intercepts of Subject and Electrode;
proc mixed data=Seq_Eff covtest;
class Subject Electrode Cell;
model  N2Curr = SlowWavePrev|Cell/SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
estimate 'Slope Average'         SlowWavePrev 1;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Cell 1 0 0 0;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Cell 0 1 0 0;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 1 0;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 0 1;
title "Trial Level Data: Random Intercept of Sub and Elect";
run;
*SlowWavePrev Predictd N2Curr with random intercepts of Subject and Electrode;
proc mixed data=Seq_Eff covtest;
class Subject Electrode Curr Prev Cell;
model  N2Curr = SlowWavePrev|Prev|Curr/SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
estimate 'Average Slope Est'         SlowWavePrev 1;
Run;

estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Curr 1 0;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Curr 0 1;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Prev 1 0;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Prev 0 1;
Run;

estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Curr*Prev 0 1 0 0;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Curr*Prev 0 0 1 0;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Curr*Prev 0 0 0 1;
title "Trial Level Data: Random Intercept of Sub and Elect";
run;

******************* Trial Analyses Over Time ******************;
DATA Seq_Eff;
SET Seq_Eff;
SW_N2_diff = N2Curr - SlowWavePrev;
SWCur_N2_diff = N2Curr - SlowWaveCurr;
Trial = Trial/10;
IF Cell = "Previous compatible - Current incompatible" THEN Prev = "Comp";
IF Cell = "Previous compatible - Current compatible" THEN Prev = "Comp";
IF Cell = "Previous incompatible - Current incompatible" THEN Prev = "InComp";
IF Cell = "Previous incompatible - Current compatible" THEN Prev = "InComp";
IF Cell = "Previous compatible - Current incompatible" THEN Curr = "InComp";
IF Cell = "Previous compatible - Current compatible" THEN Curr = "Comp";
IF Cell = "Previous incompatible - Current incompatible" THEN Curr = "InComp";
IF Cell = "Previous incompatible - Current compatible" THEN Curr = "Comp";
RUN;
*SlowWavePrev and N2Curr difference scores across Trial;
proc mixed data=Seq_Eff covtest ratio;
class Subject Electrode Cell;
model  SW_N2_diff = Trial/SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
title "Trial -> N2Curr - SlowWavePrev (Trial Level: Random Intercept of Sub and Elect)";
run;
*SlowWavePrev and N2Curr difference scores across Trial for each cell(condition);
proc mixed data=Seq_Eff covtest ratio;
class Subject Electrode Cell;
model  SW_N2_diff = Trial|Cell/SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
*lsmeans Cell/tdiff pdiff;
estimate 'Slope'         Trial 1  Trial*Cell 1 0 0 0;
estimate 'Slope'         Trial 1  Trial*Cell 0 1 0 0;
estimate 'Slope'         Trial 1  Trial*Cell 0 0 1 0;
estimate 'Slope'         Trial 1  Trial*Cell 0 0 0 1;
title "Cell*Trial -> N2Curr - SlowWavePrev (Trial Level: Random Intercept of Sub and Elect)";
run;
*Using Prev and Curr varibles;
proc mixed data=Seq_Eff  covtest;
class Subject Electrode Curr Prev;
model  SWCur_N2_diff = Trial|Curr|Prev/SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
*lsmeans Cell/pdiff tdiff;
title "Flipping DV and IV";
run;
*SlowWaveCurr and N2Curr difference scores across Trial;
proc mixed data=Seq_Eff covtest;
class Subject Electrode Cell;
model  SWCur_N2_diff = Trial/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
title "Cell*Trial -> N2Curr - SlowWavePrev (Trial Level: Random Intercept of Sub and Elect)";
run;

*SlowWaveCurr and N2Curr difference scores across Trial for each cell(condition);
proc mixed data=Seq_Eff covtest ratio;
class Subject Electrode Cell;
model  SWCur_N2_diff = Trial|Cell/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
*lsmeans Cell/tdiff pdiff;
estimate 'Slope'         Trial 1  Trial*Cell 1 0 0 0;
estimate 'Slope'         Trial 1  Trial*Cell 0 1 0 0;
estimate 'Slope'         Trial 1  Trial*Cell 0 0 1 0;
estimate 'Slope'         Trial 1  Trial*Cell 0 0 0 1;
title "Cell*Trial -> N2Curr - SlowWavePrev (Trial Level: Random Intercept of Sub and Elect)";
run;



**************************************************************************************************************
**************************************************************************************************************
*Mean Centered data;
PROC IMPORT OUT= WORK.Seq_Eff_ElectLev
            DATAFILE= "C:\Users\cdvrmd\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_ElecLev.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
*Laptop;
PROC IMPORT OUT= WORK.Seq_Eff_MeanCent
            DATAFILE= "C:\Users\Curt\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_MeanCent.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

DATA Seq_Eff_MeanCent;
SET Seq_Eff_MeanCent;
Trial = Trial/10;
RUN;
*Disagragation;
proc mixed data=Seq_Eff_MeanCent covtest ratio;
class Subject;
model  N2Curr = SWPrevMean SWPrevCent/DDFM=SATTERTHWAITE SOLUTION;
random intercept SWPrevCent/ sub=Subject; 
title "SWPrev -> N2Curr (Electrode Level: Random Intercept of Sub and Elect)";
run;
*Adding Cell;
proc mixed data=Seq_Eff_MeanCent covtest ratio;
class Subject Cell;
model  N2Curr = Cell|SWPrevMean Cell|SWPrevCent/DDFM=SATTERTHWAITE SOLUTION;
random intercept Trial/ sub=Subject; 
title "SWPrev -> N2Curr (Electrode Level: Random Intercept of Sub and Elect)";
run;


*************************************************
*Mean Centered data;
*Trial Level no condition variable;
PROC IMPORT OUT= WORK.Seq_Eff_TrialLevNoCond
            DATAFILE= "C:\Users\cdvrmd\Box Sync\Bruce Project
s\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_MeanCentNoCond.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
*Laptop;
PROC IMPORT OUT= WORK.Seq_Eff_TrialLevNoCond
            DATAFILE= "C:\Users\Curt\Box Sync\Bruce Project
s\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_MeanCentNoCond.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

DATA Seq_Eff_TrialLevNoCond;
SET Seq_Eff_TrialLevNoCond;
Trial = Trial/10;
RUN;
*Disagragation;
******Removing cell from the dataset has no influence besides "ratio" output for random effects;
******Trial in and out of the data did have an influence earlier;
proc mixed data=Seq_Eff_TrialLevNoCond covtest ratio;
class Subject;
model  N2Curr = SWPrevMean SWPrevCent/DDFM=SATTERTHWAITE SOLUTION;
random intercept SWPrevCent/ sub=Subject; 
title "SWPrev -> N2Curr (Electrode Level: Random Intercept of Sub and Elect)";
run;



**************************************************************************************************************
**************************************************************************************************************
*Just Subject and Means;
PROC IMPORT OUT= WORK.Seq_Eff_SubLev
            DATAFILE= "C:\Users\cdvrmd\Box Sync\Bruce Project
s\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_SubNoCond.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

*Laptop;
PROC IMPORT OUT= WORK.Seq_Eff_SubLev
            DATAFILE= "C:\Users\Curt\Box Sync\Bruce Project
s\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_SubNoCond.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
*Descriptives;
Proc Means data=Seq_Eff_SubLev;
var RT N2Curr SlowWaveCurr SlowWavePrev;
Title 'General Means';
Run;

proc reg data=Seq_Eff_SubLev;
model  N2Curr = SlowWavePrev;
title 'SubLevel Associations';
run;

proc reg data=Seq_Eff_SubLev;
model  RT = SlowWavePrev;
*lsmeans cue/ tdiff pdiff;
run;




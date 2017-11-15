**************************************************************************************************************
**************************************************************************************************************
*Just Subject without condition;
PROC IMPORT OUT= WORK.Seq_Eff_SubLevNoCond
            DATAFILE= "C:\Users\cdvrmd\Box Sync\Bruce Project
s\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_SubNoCond.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
*Laptop;
PROC IMPORT OUT= WORK.Seq_Eff_SubLevNoCond
            DATAFILE= "C:\Users\Curt\Box Sync\Bruce Project
s\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_SubNoCond.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

*Descriptives;
Proc Means data=Seq_Eff_SubLevNoCond;
var RT;
Title 'General Means';
Run;
proc reg data=Seq_Eff_SubLevNoCond;
model  RT = SlowWavePrev;
*lsmeans cue/ tdiff pdiff;
run;
proc glm data=Seq_Eff_SubLevNoCond;
class Subject;
model  RT = SlowWavePrev/SOLUTION;
*random intercept / sub=Subject; 
title "SWPrev -> RT";
run;
proc glm data=Seq_Eff_SubLevNoCond;
class Subject;
model  RT = SlowWavePrev SlowWaveCurr/SOLUTION;
*random intercept / sub=Subject; 
title "SWPrev -> RT";
run;


**************************************************************************************************************
**************************************************************************************************************
*Just Subject with condition;
PROC IMPORT OUT= WORK.Seq_Eff_SubLev
            DATAFILE= "C:\Users\cdvrmd\Box Sync\Bruce Project
s\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_SubLev.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
*Laptop;
PROC IMPORT OUT= WORK.Seq_Eff_SubLev
            DATAFILE= "C:\Users\Curt\Box Sync\Bruce Project
s\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_SubNoLev.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

DATA Seq_Eff_SubLev;
SET Seq_Eff_SubLev;
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
Proc Means data=Seq_Eff_SubLev;
class prev curr;
var RT;
Title 'General Means';
Run;
proc glm data=Seq_Eff_TrialElectLev;
Title2 "RT";
class Prev Curr;
model  RT = Prev|Curr;
lsmeans Prev*Curr/tdiff pdiff;
run;


*Prev;
*SlowWavePrev Predictd RT with random intercept of Subject;
proc mixed data=Seq_Eff_SubLev covtest ratio;
class Subject Cell;
model  RT = SlowWavePrev|Cell/SOLUTION;
*random intercept / sub=Subject; 
estimate 'Slope1'         SlowWavePrev 1  SlowWavePrev*Cell 1 0 0 0;
estimate 'Slope2'         SlowWavePrev 1  SlowWavePrev*Cell 0 1 0 0;
estimate 'Slope3'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 1 0;
estimate 'Slope4'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 0 1;
title "SWPrev -> RT";
run;
*Prev;
*SlowWavePrev Predictd RT with random intercept of Subject;
proc mixed data=Seq_Eff_SubLev covtest;
class Subject Curr Prev;
model  RT = SlowWavePrev|Curr|Prev/SOLUTION;
*random intercept / sub=Subject; 
title "SWPrev -> RT";
run;

*Curr;
*SlowWaveCurr Predictd RT with random intercept of Subject ;
proc mixed data=Seq_Eff_SubLev covtest;
class Subject Cell;
model  RT = SlowWaveCurr|Cell/SOLUTION;
*random intercept / sub=Subject; 
estimate 'Slope'         SlowWaveCurr 1  SlowWaveCurr*Cell 1 0 0 0;
estimate 'Slope'         SlowWaveCurr 1  SlowWaveCurr*Cell 0 1 0 0;
estimate 'Slope'         SlowWaveCurr 1  SlowWaveCurr*Cell 0 0 1 0;
estimate 'Slope'         SlowWaveCurr 1  SlowWaveCurr*Cell 0 0 0 1;
title "SWCurr|Cell -> RT";
run;

*Curr and Prev;
proc glm data=Seq_Eff_SubLev;
class Subject Cell;
model SlowWaveCurr = SlowWavePrev|Cell/SOLUTION;
estimate 'Slope1'         SlowWavePrev 1  SlowWavePrev*Cell 1 0 0 0;
estimate 'Slope2'         SlowWavePrev 1  SlowWavePrev*Cell 0 1 0 0;
estimate 'Slope3'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 1 0;
estimate 'Slope4'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 0 1;
run;
proc mixed data=Seq_Eff_SubLev covtest;
class Subject Cell;
model  RT = SlowWaveCurr|SlowWavePrev|Cell/SOLUTION;
run;


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
var RT;
Title 'General Means';
Run;
Proc Means data=Seq_Eff_ElectLev;
Class Cell;
var RT;
Title 'Means by Condition';
Run;
PROC UNIVARIATE data=Seq_Eff_ElectLev;
var RT;
Histogram RT;
RUN;

*SlowWavePrev Predictd N2Curr with random intercepts of Subject and Electrode;
proc mixed data=Seq_Eff_ElectLev covtest;
class Subject Electrode Cell;
model  RT = SlowWavePrev|Cell/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
*lsmeans Cell/pdiff tdiff;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Cell 1 0 0 0;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Cell 0 1 0 0;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 1 0;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 0 1;
title "SWPrev -> N2Curr (Electrode Level: Random Intercept of Sub and Elect)";
run;
*Flipping DV and IV;
proc mixed data=Seq_Eff_ElectLev covtest;
class Subject Electrode Cell;
model  SlowWavePrev = RT|Cell/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
*lsmeans Cell/pdiff tdiff;
estimate 'Slope'         RT 1  RT*Cell 1 0 0 0;
estimate 'Slope'         RT 1  RT*Cell 0 1 0 0;
estimate 'Slope'         RT 1  RT*Cell 0 0 1 0;
estimate 'Slope'         RT 1  RT*Cell 0 0 0 1;
title "Flipping DV and IV";
run;
*Using Prev and Curr varibles;
proc mixed data=Seq_Eff_ElectLev covtest;
class Subject Electrode Curr Prev;
model  SlowWavePrev = RT|Prev|Curr/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
*lsmeans Cell/pdiff tdiff;
title "Flipping DV and IV";
run;

*SlowWaveCurr Predictd N2Curr with random intercepts of Subject and Electrode;
proc mixed data=Seq_Eff_ElectLev covtest ratio;
class Subject Electrode Cell;
model  SlowWaveCurr = RT|Cell/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
estimate 'Slope'         RT 1  RT*Cell 1 0 0 0;
estimate 'Slope'         RT 1  RT*Cell 0 1 0 0;
estimate 'Slope'         RT 1  RT*Cell 0 0 1 0;
estimate 'Slope'         RT 1  RT*Cell 0 0 0 1;
title "SWCurr -> N2Curr (Electrode Level: Random Intercept of Sub and Elect)";
run;



**************************************************************************************************************
**************************************************************************************************************
*Trial level;
PROC IMPORT OUT= WORK.Seq_Eff_TrialOnly
            DATAFILE= "C:\Users\cdvrmd\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_TrialLev.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
*Laptop;
PROC IMPORT OUT= WORK.Seq_Eff
            DATAFILE= "C:\Users\Curt\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_TrialLev.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

*Descriptives;
Proc Means data=Seq_Eff_TrialOnly;
var RT;
Title 'General Means';
Run;
Proc Means data=Seq_Eff_TrialOnly;
Class Cell;
var RT;
Title 'Means by Condition';
Run;
PROC UNIVARIATE data=Seq_Eff_TrialOnly;
var RT;
Histogram RT;
RUN;

*Prev;
*SlowWavePrev Predictd RT with random intercept of Subject;
*Without Trial intercept;
proc mixed data=Seq_Eff_TrialOnly covtest ratio;
class Subject Cell Trial;
model  RT = SlowWavePrev/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
title "SWPrev -> RT";
run;
proc mixed data=Seq_Eff_TrialOnly covtest ratio;
class Subject Cell Trial;
model  RT = SlowWavePrev/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Trial); 
title "SWPrev -> RT";
run;
*SlowWavePrev Predictd RT with random intercept of Subject ;
proc mixed data=Seq_Eff_TrialOnly covtest ratio;
class Subject Cell Trial;
model  RT = SlowWavePrev|Cell/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
random intercept / sub=Subject(Trial); 
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Cell 1 0 0 0;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Cell 0 1 0 0;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 1 0;
estimate 'Slope'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 0 1;
title "SWPrev|Cell -> RT";
run;

*Curr;
*SlowWavePrev Predictd RT with random intercept of Subject;
proc mixed data=Seq_Eff_TrialOnly covtest ratio;
class Subject Cell Trial;
model  RT = SlowWaveCurr/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
title "SW -> RT";
run;
*SlowWavePrev Predictd RT with random intercept of Subject ;
proc mixed data=Seq_Eff_TrialOnly covtest ratio;
class Subject Cell Trial;
model  RT = SlowWaveCurr|Cell/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
estimate 'Slope'         SlowWaveCurr 1  SlowWaveCurr*Cell 1 0 0 0;
estimate 'Slope'         SlowWaveCurr 1  SlowWaveCurr*Cell 0 1 0 0;
estimate 'Slope'         SlowWaveCurr 1  SlowWaveCurr*Cell 0 0 1 0;
estimate 'Slope'         SlowWaveCurr 1  SlowWaveCurr*Cell 0 0 0 1;
title "SWCurr|Cell -> RT";
run;

*******************Trial Analyses******************;
DATA Seq_Eff_TrialOnly;
SET Seq_Eff_TrialOnly;
SW_RT_diff = RT - SlowWavePrev;
SWCur_RT_diff = RT - SlowWaveCurr;
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
proc mixed data=Seq_Eff_TrialOnly covtest ratio;
class Subject Cell;
model  SW_RT_diff = Trial/DDFM=SATTERTHWAITE SOLUTION;
*random intercept / sub=Subject; 
title "Trial -> N2Curr - SlowWavePrev (Trial Level: Random Intercept of Sub and Elect)";
run;
*SlowWavePrev and N2Curr difference scores across Trial for each cell(condition);
proc mixed data=Seq_Eff_TrialOnly covtest ratio;
class Subject Cell;
model  SW_RT_diff = Trial|Cell/DDFM=SATTERTHWAITE SOLUTION;
*random intercept / sub=Subject; 
*lsmeans Cell/tdiff pdiff;
estimate 'Slope'         Trial 1  Trial*Cell 1 0 0 0;
estimate 'Slope'         Trial 1  Trial*Cell 0 1 0 0;
estimate 'Slope'         Trial 1  Trial*Cell 0 0 1 0;
estimate 'Slope'         Trial 1  Trial*Cell 0 0 0 1;
title "Cell*Trial -> N2Curr - SlowWavePrev (Trial Level: Random Intercept of Sub and Elect)";
run;
*SlowWaveCurr and N2Curr difference scores across Trial;
proc mixed data=Seq_Eff_TrialOnly covtest ratio;
class Subject Cell;
model  SWCur_RT_diff = Trial/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
title "Cell*Trial -> N2Curr - SlowWavePrev (Trial Level: Random Intercept of Sub and Elect)";
run;
*SlowWaveCurr and N2Curr difference scores across Trial for each cell(condition);
proc mixed data=Seq_Eff_TrialOnly covtest ratio;
class Subject Cell;
model  SWCur_RT_diff = Trial|Cell/DDFM=SATTERTHWAITE SOLUTION;
random intercept / sub=Subject; 
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
*Trial Level with condition variable;
PROC IMPORT OUT= WORK.Seq_Eff_MeanCent
            DATAFILE= "C:\Users\cdvrmd\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_MeanCent.txt"  
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
IF Cell = "Previous compatible - Current incompatible" THEN Prev = "Comp";
IF Cell = "Previous compatible - Current compatible" THEN Prev = "Comp";
IF Cell = "Previous incompatible - Current incompatible" THEN Prev = "InComp";
IF Cell = "Previous incompatible - Current compatible" THEN Prev = "InComp";
IF Cell = "Previous compatible - Current incompatible" THEN Curr = "InComp";
IF Cell = "Previous compatible - Current compatible" THEN Curr = "Comp";
IF Cell = "Previous incompatible - Current incompatible" THEN Curr = "InComp";
IF Cell = "Previous incompatible - Current compatible" THEN Curr = "Comp";
RUN;
*Disagragation;
proc mixed data=Seq_Eff_MeanCent covtest ratio;
class Subject;
model  RT = SWPrevMean SWPrevCent/SOLUTION;
random intercept SWPrevCent/ sub=Subject; 
run;
*Adding Cell;
proc mixed data=Seq_Eff_MeanCent covtest ratio;
class Subject Cell;
model  RT = SWPrevMean Cell|SWPrevCent/SOLUTION;
random intercept SWPrevCent/ sub=Subject; 
estimate 'Slope'         SWPrevCent 1  SWPrevCent*Cell 1 0 0 0;
estimate 'Slope'         SWPrevCent 1  SWPrevCent*Cell 0 1 0 0;
estimate 'Slope'         SWPrevCent 1  SWPrevCent*Cell 0 0 1 0;
estimate 'Slope'         SWPrevCent 1  SWPrevCent*Cell 0 0 0 1;
run;
*Adding Curr Prev;
proc mixed data=Seq_Eff_MeanCent covtest ratio;
class Subject Curr Prev;
model  RT = SWPrevMean Curr|Prev|SWPrevCent/SOLUTION;
random intercept SWPrevCent/ sub=Subject; 
run;


*******************************************************************
*Mean Centered data;
*Trial Level no condition variable;
PROC IMPORT OUT= WORK.Seq_Eff_SubLev
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
model  N2Curr = SWPrevMean SWPrevCent/SOLUTION;
random intercept SWPrevCent/ sub=Subject; 
title "SWPrev -> N2Curr (Electrode Level: Random Intercept of Sub and Elect)";
run;





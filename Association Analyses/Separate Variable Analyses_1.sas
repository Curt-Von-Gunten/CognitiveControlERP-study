**************************************************************************************************************
**************************************************************************************************************
*Electrode and Trial level for Trial Difference Analyses;
PROC IMPORT OUT= WORK.Seq_Eff_TrialElectLev
            DATAFILE= "C:\Users\cdvrmd\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_Trial&ElecLev.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
*Laptop;
PROC IMPORT OUT= WORK.Seq_Eff_TrialElectLev
            DATAFILE= "C:\Users\Curt\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_Trial&ElecLev.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

DATA Seq_Eff_TrialElectLev;
SET Seq_Eff_TrialElectLev;
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

*Exporting as txt;
proc export 
  data=Seq_Eff_TrialElectLev
  dbms=tab 
  outfile="C:\Users\cdvrmd\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_Trial&ElecLev_PrevCurr.txt"  
  replace;
run;

*Descriptives;
Title1 'Descriptives';
Proc Means data=Seq_Eff_TrialElectLev;
Title2 'General Means';
var RT N2Curr SlowWaveCurr SlowWavePrev;
Run;
quit;
Proc Means data=Seq_Eff_TrialElectLev;
Title2 'General Means by Condition';
Class Cell;
var RT N2Curr SlowWaveCurr SlowWavePrev;
Run;


Title1 "Association Analyses Ignoring Trial";
Title2 "SlowWavePrev";
*N2 Models;
proc mixed data=Seq_Eff_TrialElectLev covtest;
title3 "TrialLevel. Intercepts only.";
class Subject Electrode Prev Curr;
model  N2Curr = Prev|Curr/;
random intercept / sub=Subject;
random intercept / sub=Subject(Electrode);
lsmeans Prev/tdiff pdiff;
lsmeans Curr/tdiff pdiff;
lsmeans Prev*Curr/tdiff pdiff;
run;

proc mixed data=Seq_Eff_ElectLev covtest;
title3 "ElectLevel. Intercepts only.";
class Subject Electrode Prev Curr;
model  N2Curr = Prev|Curr/;
random intercept / sub=Subject;
random intercept / sub=Subject(Electrode);
lsmeans Prev/tdiff pdiff;
lsmeans Curr/tdiff pdiff;
lsmeans Prev*Curr/tdiff pdiff;
run;

proc mixed data=Seq_Eff_TrialElectLev covtest;
title3 "TrialLevel. All random effect";
class Subject Electrode Prev Curr;
model  N2Curr = Prev|Curr/;
random intercept Prev Curr Prev*Curr/ sub=Subject;
random intercept / sub=Subject(Electrode);
lsmeans Prev/tdiff pdiff;
lsmeans Curr/tdiff pdiff;
lsmeans Prev*Curr/tdiff pdiff;
run;

proc mixed data=Seq_Eff_ElectLev covtest;
title3 "ElectLevel. All random effect";
class Subject Electrode Prev Curr;
model  N2Curr = Prev|Curr/;
random intercept Prev Curr Prev*Curr/ sub=Subject;
random intercept / sub=Subject(Electrode);
lsmeans Prev/tdiff pdiff;
lsmeans Curr/tdiff pdiff;
lsmeans Prev*Curr/tdiff pdiff;
run;




proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition (4 levels) -> N2Curr - SlowWavePrev (Random Intercept of Sub and Sub(Elect))";
class Subject Electrode Cell;
model  N2_SW_diff_st = Trial|Cell; 
random intercept / sub=Subject;
random intercept / sub=Subject(Electrode);
estimate 'Trial Avg Slope'         Trial 1;
estimate 'Previous compatible - Current compatible'          Trial 1  Trial*Cell 1 0 0 0;
estimate 'Previous compatible - Current incompatible'          Trial 1  Trial*Cell 0 1 0 0;
estimate 'Previous incompatible - Current compatible'          Trial 1  Trial*Cell 0 0 1 0;
estimate 'Previous incompatible - Current incompatible'          Trial 1  Trial*Cell 0 0 0 1;
run;

proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition (4 levels) -> N2Curr - SlowWavePrev (Random Intercept of Sub and Sub(Elect))";
class Subject Electrode Cell;
model  N2_SW_diff_st = Trial|Cell; 
random intercept cell/ sub=Subject;
random intercept / sub=Subject(Electrode);
estimate 'Trial Avg Slope'         Trial 1;
estimate 'Previous compatible - Current compatible'          Trial 1  Trial*Cell 1 0 0 0;
estimate 'Previous compatible - Current incompatible'          Trial 1  Trial*Cell 0 1 0 0;
estimate 'Previous incompatible - Current compatible'          Trial 1  Trial*Cell 0 0 1 0;
estimate 'Previous incompatible - Current incompatible'          Trial 1  Trial*Cell 0 0 0 1;
run;



*SlowWave Models;
proc mixed data=Seq_Eff_TrialElectLev covtest;
title3 "TrialLevel. Intercepts only.";
class Subject Electrode Prev Curr;
model  SlowWavePrev = Prev|Curr/;
random intercept / sub=Subject;
random intercept / sub=Subject(Electrode);
lsmeans Prev/tdiff pdiff;
lsmeans Curr/tdiff pdiff;
lsmeans Prev*Curr/tdiff pdiff;
run;

proc mixed data=Seq_Eff_ElectLev covtest;
title3 "ElectLevel. Intercepts only.";
class Subject Electrode Prev Curr;
model  SlowWavePrev = Prev|Curr/;
random intercept / sub=Subject;
random intercept / sub=Subject(Electrode);
lsmeans Prev/tdiff pdiff;
lsmeans Curr/tdiff pdiff;
lsmeans Prev*Curr/tdiff pdiff;
run;

proc mixed data=Seq_Eff_TrialElectLev covtest;
title3 "TrialLevel. All random effect";
class Subject Electrode Prev Curr;
model  SlowWavePrev = Prev|Curr/;
random intercept Prev Curr Prev*Curr/ sub=Subject;
random intercept / sub=Subject(Electrode);
lsmeans Prev/tdiff pdiff;
lsmeans Curr/tdiff pdiff;
lsmeans Prev*Curr/tdiff pdiff;
run;

proc mixed data=Seq_Eff_ElectLev covtest;
title3 "ElectLevel. All random effect";
class Subject Electrode Prev Curr;
model  SlowWavePrev = Prev|Curr/;
random intercept Prev Curr Prev*Curr/ sub=Subject;
random intercept / sub=Subject(Electrode);
lsmeans Prev/tdiff pdiff;
lsmeans Curr/tdiff pdiff;
lsmeans Prev*Curr/tdiff pdiff;
run;



*SlowWavePrev Predictd N2Curr with random intercepts of Subject and Electrode;
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "SWPrev X Cond(4 level) -> N2Curr (Random Intercept of Sub and Sub(Elect))";
class Subject Electrode Prev Curr;
model  RT = Prev|Curr;
random intercept prev curr prev*curr / sub=Subject; 
random intercept / sub=Subject(Electrode);
lsmeans Prev/tdiff pdiff;
lsmeans Curr/tdiff pdiff;
lsmeans Prev*Curr/tdiff pdiff;
run;

estimate 'SlowWavePrev Avg Slope'         SlowWavePrev 1;
estimate 'Previous compatible - Current compatible'         SlowWavePrev 1  SlowWavePrev*Cell 1 0 0 0;
estimate 'Previous compatible - Current incompatible'         SlowWavePrev 1  SlowWavePrev*Cell 0 1 0 0;
estimate 'Previous incompatible - Current compatible'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 1 0;
estimate 'Previous incompatible - Current incompatible'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 0 1;
run;

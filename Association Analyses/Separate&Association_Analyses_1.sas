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

**************************************************************************************************************
**************************************************************************************************************
*Mean Centered data;
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

**************************************************************************************************************
**************************************************************************************************************
*Just Subject with condition for RT ANOVA check;
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
/*Standardizing variables;
data Seq_Eff_TrialElectLev;
set Seq_Eff_TrialElectLev;
RT_st = RT;
N2Curr_st = N2curr;
SlowWavePrev_st = SlowWavePrev;
run;
proc standard data=Seq_Eff_TrialElectLev mean=0 std=1 out=Seq_Eff_TrialElectLev;
var RT_st N2Curr_st SlowWavePrev_st;
run;
Proc Means data=Seq_Eff_TrialElectLev;
var RT_st N2Curr_st SlowWavePrev_st;
Run;
*/

*Computing variables and formatting;
*Trial Level Data;
DATA Seq_Eff_TrialElectLev;
SET Seq_Eff_TrialElectLev;
Trial = Trial/10;
N2_SW_diff = N2Curr - SlowWavePrev;
N2_SWCur_diff = N2Curr - SlowWaveCurr;
RT_N2_diff = RT - N2Curr;
RT_SW_diff = RT - SlowWavePrev;
*N2_SW_diff_st = N2Curr_st - SlowWavePrev_st;
*RT_N2_diff_st = RT_st - N2Curr_st;
*RT_SW_diff_st = RT_st - SlowWavePrev_st;
IF Cell = "Previous compatible - Current incompatible" THEN Prev = "Comp";
IF Cell = "Previous compatible - Current compatible" THEN Prev = "Comp";
IF Cell = "Previous incompatible - Current incompatible" THEN Prev = "InComp";
IF Cell = "Previous incompatible - Current compatible" THEN Prev = "InComp";
IF Cell = "Previous compatible - Current incompatible" THEN Curr = "InComp";
IF Cell = "Previous compatible - Current compatible" THEN Curr = "Comp";
IF Cell = "Previous incompatible - Current incompatible" THEN Curr = "InComp";
IF Cell = "Previous incompatible - Current compatible" THEN Curr = "Comp";
RUN;
*Mean Centered Data;
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

*Exporting for R;
*Desktop;
proc export 
  data=Seq_Eff_TrialElectLev
  dbms=tab 
  outfile="C:\Users\cdvrmd\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_Trial&ElecLev_R.txt"  
  replace;
run;
proc export 
  data=Seq_Eff_MeanCent
  dbms=tab 
  outfile="C:\Users\cdvrmd\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_MeanCent_R.txt"  
  replace;
run;
*Laptop;
proc export 
  data=Seq_Eff_TrialElectLev
  dbms=tab 
  outfile="C:\Users\Curt\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_Trial&ElecLev_R.txt"  
  replace;
run;
proc export 
  data=Seq_Eff_MeanCent
  dbms=tab 
  outfile="C:\Users\Curt\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Created by R_ArtRej\RT_N2_SlowWave_MeanCent_R.txt"  
  replace;
run;


***************************************************************************************
options nodate nonumber;
ods pdf file="C:\Users\cdvrmd\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Code\Code for Art Rej Data\Association Analyses\AllAnalyses_1.pdf";

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
*PROC UNIVARIATE data=Seq_Eff_TrialElectLev NOPRINT;
*Title2 'Histograms';
*var RT N2Curr SlowWaveCurr SlowWavePrev;
*Histogram RT N2Curr SlowWaveCurr SlowWavePrev;
*RUN;



**************************************************************************************************************
************************Separate Variable Analyses************************;
Title1 "Separate Variable Analyses";
*RT;
proc mixed data=Seq_Eff_TrialElectLev covtest;
Title2 "RT";
class Subject Electrode Prev Curr;
model  RT = Prev|Curr/;
random intercept / sub=Subject;
random intercept / sub=Subject(Electrode);
lsmeans Prev*Curr/tdiff pdiff;
run;
Proc Means data=Seq_Eff_TrialElectLev;
Title2 'RT Means';
Class Prev Curr;
var RT;
Run;
*Double checking with ANOVA since one simple effect is ridiculously small;
proc glm data=Seq_eff_sublev;
Title2 "RT ANOVA: comparing to the random subject intercept model";
class Prev Curr;
model  RT = Prev|Curr;
lsmeans Prev*Curr/tdiff pdiff;
run;

*N2;
proc mixed data=Seq_Eff_TrialElectLev covtest;
Title2 "N2";
class Subject Electrode Prev Curr;
model  N2Curr = Prev|Curr/;
random intercept / sub=Subject;
random intercept / sub=Subject(Electrode);
lsmeans Prev*Curr/tdiff pdiff;
run;
Proc Means data=Seq_Eff_TrialElectLev;
Title2 'N2 Means';
Class Prev Curr;
var N2Curr;
Run;
*Double checking with ANOVA since one simple effect is ridiculously small;
proc glm data=Seq_eff_sublev;
Title2 "N2 ANOVA: comparing to the random subject intercept model";
class Prev Curr;
model  N2Curr = Prev|Curr;
lsmeans Prev*Curr/tdiff pdiff;
run;

*SlowWave;
proc mixed data=Seq_Eff_TrialElectLev covtest;
Title2 "SlowWaveCurr";
class Subject Electrode Prev Curr;
model SlowWaveCurr = Prev|Curr/;
random intercept / sub=Subject;
random intercept / sub=Subject(Electrode);
lsmeans Prev*Curr/tdiff pdiff;
run;
Proc Means data=Seq_Eff_TrialElectLev;
Title2 'SlowWaveCurr Means';
Class Prev Curr;
var SlowWaveCurr;
Run;
*Double checking with ANOVA since one simple effect is ridiculously small;
proc glm data=Seq_eff_sublev;
Title2 "SlowWave ANOVA: comparing to the random subject intercept model";
class Prev Curr;
model  SlowWaveCurr = Prev|Curr;
lsmeans Prev*Curr/tdiff pdiff;
run;


**************************************************************************************************************
************************Disaggregation************************;
Title1 "Disaggregate Analyses";
Title2 "SlowWavePrev";
proc mixed data=Seq_Eff_MeanCent covtest noinfo noitprint;
Title3 "SWbetween(mean) and SWwithin(Cent) -> N2Curr (Condition variable is still in the dataset even though it's not in the model)";
class Subject;
model  N2Curr = SWPrevMean SWPrevCent/Solution;
random intercept SWPrevCent/ sub=Subject; 
run;
*Cell;
proc mixed data=Seq_Eff_MeanCent covtest noinfo noitprint;
Title3 "SWbetween(mean) and SWwithin(Cent) WITH Condition(4 levels) -> N2Curr";
class Subject Cell;
model  N2Curr = Cell|SWPrevMean Cell|SWPrevCent;
random intercept SWPrevCent/ sub=Subject; 
estimate 'SWPrevMean: Previous compatible - Current compatible'         SWPrevMean 1  SWPrevMean*Cell 1 0 0 0;
estimate 'SWPrevMean: Previous compatible - Current incompatible'         SWPrevMean 1  SWPrevMean*Cell 0 1 0 0;
estimate 'SWPrevMean: Previous incompatible - Current compatible'         SWPrevMean 1  SWPrevMean*Cell 0 0 1 0;
estimate 'SWPrevMean: Previous incompatible - Current incompatible'         SWPrevMean 1  SWPrevMean*Cell 0 0 0 1;
estimate 'SWPrevCent: Previous compatible - Current compatible'         SWPrevCent 1  SWPrevCent*Cell 1 0 0 0;
estimate 'SWPrevCent: Previous compatible - Current incompatible'         SWPrevCent 1  SWPrevCent*Cell 0 1 0 0;
estimate 'SWPrevCent: Previous incompatible - Current compatible'         SWPrevCent 1  SWPrevCent*Cell 0 0 1 0;
estimate 'SWPrevCent: Previous incompatible - Current incompatible'         SWPrevCent 1  SWPrevCent*Cell 0 0 0 1;
run;
*Prev X Curr;
proc mixed data=Seq_Eff_MeanCent covtest noinfo noitprint;
Title3 "SWbetween(mean) and SWwithin(Cent) WITH Condition(2X2) -> N2Curr";
class Subject Prev Curr;
model  N2Curr = Prev|Curr|SWPrevMean Prev|Curr|SWPrevCent;
random intercept SWPrevCent/ sub=Subject; 
run;

*Response Time;
Title2 "Response Time";
proc mixed data=Seq_Eff_MeanCent covtest noinfo noitprint;
Title3 "SWbetween(mean) and SWwithin(Cent) -> RT (Condition variable is still in the dataset even though it's not in the model)";
class Subject;
model  RT = SWPrevMean SWPrevCent/Solution;
random intercept SWPrevCent/ sub=Subject; 
run;
*Cell;
proc mixed data=Seq_Eff_MeanCent covtest noinfo noitprint;
Title3 "SWbetween(mean) and SWwithin(Cent) WITH Condition(4 levels) -> RT";
class Subject Cell;
model  RT = Cell|SWPrevMean Cell|SWPrevCent;
random intercept SWPrevCent/ sub=Subject; 
estimate 'SWPrevMean: Previous compatible - Current compatible'         SWPrevMean 1  SWPrevMean*Cell 1 0 0 0;
estimate 'SWPrevMean: Previous compatible - Current incompatible'         SWPrevMean 1  SWPrevMean*Cell 0 1 0 0;
estimate 'SWPrevMean: Previous incompatible - Current compatible'         SWPrevMean 1  SWPrevMean*Cell 0 0 1 0;
estimate 'SWPrevMean: Previous incompatible - Current incompatible'         SWPrevMean 1  SWPrevMean*Cell 0 0 0 1;
estimate 'SWPrevCent: Previous compatible - Current compatible'         SWPrevCent 1  SWPrevCent*Cell 1 0 0 0;
estimate 'SWPrevCent: Previous compatible - Current incompatible'         SWPrevCent 1  SWPrevCent*Cell 0 1 0 0;
estimate 'SWPrevCent: Previous incompatible - Current compatible'         SWPrevCent 1  SWPrevCent*Cell 0 0 1 0;
estimate 'SWPrevCent: Previous incompatible - Current incompatible'         SWPrevCent 1  SWPrevCent*Cell 0 0 0 1;
run;
*Prev X Curr;
proc mixed data=Seq_Eff_MeanCent covtest noinfo noitprint;
Title3 "SWbetween(mean) and SWwithin(Cent) WITH Condition(2X2) -> RT";
class Subject Prev Curr;
model  RT = Prev|Curr|SWPrevMean Prev|Curr|SWPrevCent;
random intercept SWPrevCent/ sub=Subject; 
estimate 'SWPrevMean: Previous compatible - Current compatible'         SWPrevMean 1  SWPrevMean*Prev*Curr 1 -1 0 0;
run;



**************************************************************************************************************
************************Separate Analyses Across Time************************;
Title1 "Separate Analyses Across Time";
Title2 "RT";
*RT;
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition(4 levels) -> RT (Random Intercept of Sub)";
class Subject Cell;
model  RT = Trial|Cell; 
random intercept / sub=Subject;
estimate 'Trial Avg Slope'         Trial 1;
estimate 'Previous compatible - Current compatible'          Trial 1  Trial*Cell 1 0 0 0;
estimate 'Previous compatible - Current incompatible'          Trial 1  Trial*Cell 0 1 0 0;
estimate 'Previous incompatible - Current compatible'          Trial 1  Trial*Cell 0 0 1 0;
estimate 'Previous incompatible - Current incompatible'          Trial 1  Trial*Cell 0 0 0 1;
run;
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition(2X2) -> RT (Random Intercept of Sub))";
class Subject Curr Prev;
model  RT = Trial|Curr|Prev; 
random intercept / sub=Subject;
estimate 'Trial Avg Slope'         Trial 1;
run;

Title2 "N2";
*N2;
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition(4 levels) -> N2 (Random Intercept of Sub and Elect)";
class Subject Electrode Cell;
model  N2Curr = Trial|Cell;
random intercept / sub=Subject;
random intercept / sub=Subject(Electrode);
estimate 'Trial Avg Slope'         Trial 1;
estimate 'Previous compatible - Current compatible'          Trial 1  Trial*Cell 1 0 0 0;
estimate 'Previous compatible - Current incompatible'          Trial 1  Trial*Cell 0 1 0 0;
estimate 'Previous incompatible - Current compatible'          Trial 1  Trial*Cell 0 0 1 0;
estimate 'Previous incompatible - Current incompatible'          Trial 1  Trial*Cell 0 0 0 1;
run;
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition(2X2) -> N2 (Random Intercept of Sub and Elect)";
class Subject Electrode Prev Curr;
model N2Curr = Trial|Prev|Curr;
random intercept / sub=Subject;
random intercept / sub=Subject(Electrode);
estimate 'Trial Avg Slope'   Trial 1;
run;

Title2 "SW";
*SlowWave;
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition(4 levels) -> SW (Random Intercept of Sub and Elect)";
class Subject Electrode Cell;
model  SlowWaveCurr = Trial|Cell;
random intercept / sub=Subject;
random intercept / sub=Subject(Electrode);
estimate 'Trial Avg Slope'         Trial 1;
estimate 'Previous compatible - Current compatible'          Trial 1  Trial*Cell 1 0 0 0;
estimate 'Previous compatible - Current incompatible'          Trial 1  Trial*Cell 0 1 0 0;
estimate 'Previous incompatible - Current compatible'          Trial 1  Trial*Cell 0 0 1 0;
estimate 'Previous incompatible - Current incompatible'          Trial 1  Trial*Cell 0 0 0 1;
run;
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition(2X2) -> SW (Random Intercept of Sub and Elect)";
class Subject Electrode Prev Curr;
model SlowWaveCurr = Trial|Prev|Curr;
random intercept / sub=Subject;
random intercept / sub=Subject(Electrode);
estimate 'Trial Avg Slope'   Trial 1;
run;



**************************************************************************************************************
************************Difference Scores Across Time************************;
Title1 "Difference Scores Across Time";
Title2 "N2Curr - SlowWavePrev";
*SlowWavePrev and N2Curr difference scores across Trial for each cell(condition);
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition(4 levels) -> N2Curr - SlowWavePrev (Random Intercept of Sub and Sub(Elect))";
class Subject Electrode Cell;
model  N2_SW_diff = Trial|Cell; 
random intercept / sub=Subject;
random intercept / sub=Subject(Electrode);
estimate 'Trial Avg Slope'         Trial 1;
estimate 'Previous compatible - Current compatible'          Trial 1  Trial*Cell 1 0 0 0;
estimate 'Previous compatible - Current incompatible'          Trial 1  Trial*Cell 0 1 0 0;
estimate 'Previous incompatible - Current compatible'          Trial 1  Trial*Cell 0 0 1 0;
estimate 'Previous incompatible - Current incompatible'          Trial 1  Trial*Cell 0 0 0 1;
run;
*SlowWavePrev and N2Curr difference scores across Trial for each cell(condition);
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition(2X2) -> N2Curr - SlowWavePrev (Random Intercept of Sub and Sub(Elect))";
class Subject Electrode Curr Prev;
model  N2_SW_diff = Trial|Curr|Prev; 
random intercept / sub=Subject;
random intercept / sub=Subject(Electrode);
estimate 'Trial Avg Slope'         Trial 1;
run;
/*CurentSW;
*Using Prev and Curr varibles;
proc mixed data=Seq_Eff_TrialElectLev  covtest noinfo noitprint;
title3 "Trial X Condition (2X2 levels) -> N2Curr - SlowWavePrev (Random Intercept of Sub and Sub(Elect))";
class Subject Electrode Curr Prev;
model  N2_SWCur_diff_st = Trial|Curr|Prev;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
estimate 'Trial Avg Slope'         Trial 1;
run;
*/

Title2 "RT - SlowWavePrev";
*SlowWavePrev and N2Curr difference scores across Trial for each cell(condition);
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition(4 levels) -> RT - SlowWavePrev (Random Intercept of Sub)";
class Subject Electrode Cell;
model  RT_SW_diff = Trial|Cell;
estimate 'Trial Avg Slope'         Trial 1;
estimate 'Previous compatible - Current compatible'          Trial 1  Trial*Cell 1 0 0 0;
estimate 'Previous compatible - Current incompatible'          Trial 1  Trial*Cell 0 1 0 0;
estimate 'Previous incompatible - Current compatible'          Trial 1  Trial*Cell 0 0 1 0;
estimate 'Previous incompatible - Current incompatible'          Trial 1  Trial*Cell 0 0 0 1;
run;
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition(2X2) -> RT - SlowWavePrev (Random Intercept of Sub)";
class Subject Electrode Prev Curr;
model  RT_SW_diff = Trial|Prev|Curr;
random intercept / sub=Subject; 
estimate 'Trial Avg Slope'   Trial 1;
run;

Title2 "RT - N2Curr";
*SlowWavePrev and N2Curr difference scores across Trial for each cell(condition);
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition(4 levels) -> RT - N2Curr (Random Intercept of Sub)";
class Subject Electrode Cell;
model  RT_N2_diff = Trial|Cell;
random intercept / sub=Subject; 
estimate 'Trial Avg Slope'         Trial 1;
estimate 'Previous compatible - Current compatible'          Trial 1  Trial*Cell 1 0 0 0;
estimate 'Previous compatible - Current incompatible'          Trial 1  Trial*Cell 0 1 0 0;
estimate 'Previous incompatible - Current compatible'          Trial 1  Trial*Cell 0 0 1 0;
estimate 'Previous incompatible - Current incompatible'          Trial 1  Trial*Cell 0 0 0 1;
run;
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition(2X2) -> RT - N2Curr (Random Intercept of Sub)";
class Subject Electrode Prev Curr;
model  RT_N2_diff = Trial|Prev|Curr;
random intercept / sub=Subject; 
estimate 'Trial Avg Slope'   Trial 1;
run;

ods pdf close;





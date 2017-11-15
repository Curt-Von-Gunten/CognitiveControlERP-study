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

DATA Seq_Eff_TrialElectLev;
SET Seq_Eff_TrialElectLev;
Trial = Trial/10;
N2_SW_diff = N2Curr - SlowWavePrev;
N2_SWCur_diff = N2Curr - SlowWaveCurr;
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


options nodate nonumber;
ods pdf file="C:\Users\cdvrmd\Box Sync\Bruce Projects\Sequential Processing\PointByPoint Processing\Code\Code for Art Rej Data\Association Analyses\Association_Analyses_2.pdf";

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

Title1 "Association Analyses Ignoring Trial";
Title2 "SlowWavePrev";
*SlowWavePrev Predictd N2Curr with random intercepts of Subject and Electrode;
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "SWPrev X Cond(4 level) -> N2Curr (Random Intercept of Sub and Sub(Elect))";
class Subject Electrode Cell;
model  N2Curr = SlowWavePrev|Cell;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
estimate 'SlowWavePrev Avg Slope'         SlowWavePrev 1;
estimate 'Previous compatible - Current compatible'         SlowWavePrev 1  SlowWavePrev*Cell 1 0 0 0;
estimate 'Previous compatible - Current incompatible'         SlowWavePrev 1  SlowWavePrev*Cell 0 1 0 0;
estimate 'Previous incompatible - Current compatible'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 1 0;
estimate 'Previous incompatible - Current incompatible'         SlowWavePrev 1  SlowWavePrev*Cell 0 0 0 1;
run;
*SlowWavePrev Predictd N2Curr with random intercepts of Subject and Electrode;
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "SWPrev X Prev X Curr -> N2Curr (Random Intercept of Sub and Sub(Elect))";
class Subject Electrode Curr Prev Cell;
model  N2Curr = SlowWavePrev|Prev|Curr;
random intercept SlowWavePrev*Prev*Curr/ sub=Subject; 
random intercept / sub=Subject(Electrode);
estimate 'SlowWavePrev Avg Slope'          SlowWavePrev 1;
Run;

****************** RT ****************;
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
Title2 "Response Time";
title3 "RT X Cond(4 level) -> SWPrev (Random Intercept of Sub and Sub(Elect))";
class Subject Electrode Cell;
model  SlowWavePrev = RT|Cell;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
estimate 'RT Avg Slope'         RT 1;
estimate 'Previous compatible - Current compatible'          RT 1  RT*Cell 1 0 0 0;
estimate 'Previous compatible - Current incompatible'         RT 1  RT*Cell 0 1 0 0;
estimate 'Previous incompatible - Current compatible'         RT 1  RT*Cell 0 0 1 0;
estimate 'Previous incompatible - Current incompatible'         RT 1  RT*Cell 0 0 0 1;
run;
*Using Prev and Curr varibles;
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "RT X Prev X Curr -> SWPrev (Random Intercept of Sub and Sub(Elect))";
class Subject Electrode Curr Prev;
model  SlowWavePrev = RT|Prev|Curr;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
estimate 'RT Avg Slope' RT 1;
run;

*Response Time;
Title2 "Response Time";
proc mixed data=Seq_Eff_MeanCent covtest noinfo noitprint;
Title3 "SWbetween(mean) and SWwithin(Cent) -> RT (Condition variable is still in the dataset even though it's not in the model)";
class Subject;
model  RT = SWPrevMean SWPrevCent/Solution;
random intercept SWPrevCent/ sub=Subject; 
run;
*Adding Cell;
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
*Adding Cell;
proc mixed data=Seq_Eff_MeanCent covtest noinfo noitprint;
Title3 "SWbetween(mean) and SWwithin(Cent) WITH Condition(2X2) -> RT";
class Subject Prev Curr;
model  RT = Prev|Curr|SWPrevMean Prev|Curr|SWPrevCent;
random intercept SWPrevCent/ sub=Subject; 
run;



************************Difference Scores Across Time************************;
Title1 "Difference Scores Across Time";
Title2 "N2Curr - SlowWavePrev";
*SlowWavePrev and N2Curr difference scores across Trial for each cell(condition);
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition (4 levels) -> N2Curr - SlowWavePrev (Random Intercept of Sub and Sub(Elect))";
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

*SlowWavePrev and N2Curr difference scores across Trial for each cell(condition);
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition(2X2) -> N2Curr - SlowWavePrev (Random Intercept of Sub and Sub(Elect))";
class Subject Electrode Curr Prev;
model  N2_SW_diff = Trial|Curr|Prev; 
random intercept Curr Prev Curr*Prev/ sub=Subject;
random intercept / sub=Subject(Electrode);
estimate 'Trial Avg Slope'         Trial 1;
run;

proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint ASYCORR;
title3 "Trial X Condition(2X2) -> N2Curr - SlowWavePrev (Random Intercept of Sub and Sub(Elect))";
class Subject Electrode Curr Prev;
model  N2_SW_diff = Trial|Curr|Prev; 
random intercept Curr Prev Curr*Prev Curr*Trial Prev*Trial Curr*Prev*Trial/ sub=Subject;
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
title3 "Trial X Condition (4 levels) -> RT - SlowWavePrev (Random Intercept of Sub and Sub(Elect))";
class Subject Electrode Cell;
model  RT_SW_diff_st = Trial|Cell;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
estimate 'Trial Avg Slope'         Trial 1;
estimate 'Previous compatible - Current compatible'          Trial 1  Trial*Cell 1 0 0 0;
estimate 'Previous compatible - Current incompatible'          Trial 1  Trial*Cell 0 1 0 0;
estimate 'Previous incompatible - Current compatible'          Trial 1  Trial*Cell 0 0 1 0;
estimate 'Previous incompatible - Current incompatible'          Trial 1  Trial*Cell 0 0 0 1;
run;
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition(2X2) -> RT - SlowWavePrev (Random Intercept of Sub and Sub(Elect))";
class Subject Electrode Prev Curr;
model  RT_SW_diff_st = Trial|Prev|Curr;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
estimate 'Trial Avg Slope'   Trial 1;
run;

Title2 "RT - N2Curr";
*SlowWavePrev and N2Curr difference scores across Trial for each cell(condition);
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition (4 levels) -> RT - N2Curr (Random Intercept of Sub and Sub(Elect))";
class Subject Electrode Cell;
model  RT_N2_diff_st = Trial|Cell;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
estimate 'Trial Avg Slope'         Trial 1;
estimate 'Previous compatible - Current compatible'          Trial 1  Trial*Cell 1 0 0 0;
estimate 'Previous compatible - Current incompatible'          Trial 1  Trial*Cell 0 1 0 0;
estimate 'Previous incompatible - Current compatible'          Trial 1  Trial*Cell 0 0 1 0;
estimate 'Previous incompatible - Current incompatible'          Trial 1  Trial*Cell 0 0 0 1;
run;
proc mixed data=Seq_Eff_TrialElectLev covtest noinfo noitprint;
title3 "Trial X Condition(2X2) -> RT - N2Curr (Random Intercept of Sub and Sub(Elect))";
class Subject Electrode Prev Curr;
model  RT_N2_diff_st = Trial|Prev|Curr;
random intercept / sub=Subject; 
random intercept / sub=Subject(Electrode);
estimate 'Trial Avg Slope'   Trial 1;
run;
*/
ods pdf close;





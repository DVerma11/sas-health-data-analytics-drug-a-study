/* SAS PROJECT*/
Libname L1 "C:\Users\dverm\OneDrive\MSHI COURSES\Current courses\SAS\SAS files";
Filename Study1 "C:\Users\dverm\OneDrive\MSHI COURSES\Current courses\SAS\project\Datafiles\Study1.csv";
Filename Study2 "C:\Users\dverm\OneDrive\MSHI COURSES\Current courses\SAS\project\Datafiles\Study2.csv";

/*STEP 1:  LOAD AND PREPARE DATA*/
/*Load Intial_Study_Project1*/
Data L1.Study1;
Infile Study1 DSD DLM="," missover;
input PatientID Age State$ LOS Total_Charge; 
run; 
Proc print data= L1.Study1; 
Title "Study1";
run; 

/* LOAD Second_Study_Project1*/
Data L1.Study2;
Infile Study2 DSD DLM="," missover;
input PatientID Group$ Test_Score; 
run; 
Proc print data= L1.Study2; 
Title "Study2";
run; 

/* Sort both data by PatientID*/
Proc sort data= L1.Study1 out = L1.Study1_sort; 
by PatientID; 
run; 
Proc print data= L1.Study1_sort; 
Title "Study1_sort";
run; 

Proc sort data= L1.Study2 out = L1.Study2_sort; 
by PatientID; 
run; 
Proc print data= L1.Study2_sort; 
Title "Study2_sort";
run; 

/*  Merge both data by PatientID- Non_Equi Join*/
data L1.Final_NonEqui;
merge L1.Study1_sort L1.Study2_sort; 
by PatientID; 
run; 
proc print data= L1.Final_NonEqui; 
Title "Final_NonEqui";
run; 

/*  Remove null values*/
data L1.Final_Clean;
    set L1.Final_NonEqui;
    if cmiss(of _all_) then delete;
run;
proc print data= L1.Final_Clean; 
Title "Final_Clean";
run; 

/*  Remove n/a from Group variable*/
data L1.Final_Clean2;
    set L1.Final_Clean;
    /* Keep only valid treatment groups */
    if upcase(Group) in ("LOW","HIGH","PLACEBO");
run;
proc print data= L1.Final_Clean2; 
Title "Final_Clean2";
run;

/*Descriptive statistics on Final_Clean2 to decide about how many from each group-title "Final_Clean2 Freq. by Group"*/
proc freq data=L1.Final_Clean2;
    tables Group;
run;



/*  STEP 2: Sampling: Method SRS (Random sampling), Sample size 1000 (Don’t use seed)*/
proc sort data=L1.Final_Clean2;
    by Group;
run;
proc surveyselect data=L1.Final_Clean2
    method=srs
    sampsize=(333 333 333)  /* number from each group */
    out=L1.Final_Sample_SRS_Stratified;
    strata Group;
    id _ALL_;
run;

Proc Print data= L1.Final_Sample_SRS_Stratified; 
title "Final_Sample_SRS_Stratified"; 
run; 
/*  DESCRIPTIVE STATISTICS */
proc freq data=L1.Final_Sample_SRS_Stratified;
    tables Group;
run;
/*  Step 3A: Descriptive Statistics */
PROC MEANS DATA=L1.Final_Sample_SRS_Stratified N MEAN STD MIN MAX MEDIAN;
    CLASS Group;
    VAR Test_Score;
RUN;
/*  Step 4B: Check Normality*/
/*  NO*/
ods graphics on;
proc univariate data=L1.Final_Sample_SRS_Stratified;
    class Group;
    var Test_Score;
    histogram Test_Score / normal;
    qqplot Test_Score / normal(mu=est sigma=est);
run;
ods graphics off;
/*  Remove expreme outlier from Group = "High"*/
data L1.Final_Sample_Cleaned;
    set L1.Final_Sample_SRS_Stratified;
    if Group = "High" and Test_Score = 1736.582 then delete;
	title "Final_Sample_Cleaned"; 
run;
/*  Re- run Univariate after removing the extreme outlier from Group = "High"*/
proc univariate data=L1.Final_Sample_Cleaned;
    class Group;
    var Test_Score;
    histogram Test_Score / normal;
    qqplot Test_Score / normal(mu=est sigma=est);
run;


*/DOUBLE CONFIRM- run normality check on all data  L1.Final_Clean2*/
data= L1.Final_Clean2; 
PROC MEANS DATA=L1.Final_Clean2;
    CLASS Group;
    VAR Test_Score;
	title "Final_Clean2"; 
RUN;

proc univariate data=L1.Final_Clean2 plots;
  var Test_Score;
  class Group;
  histogram Test_Score / normal;
run;


/*  results from L1.Final_Clean2(all dat without null values) and Final_Sample_SRS_Stratified(sample of 999) and Final_Sample_Cleaned(after removing outlier) show highly non-normal data */


/*  Step 4C: Decide method to compare 3 groups- ANOVA NOT NEEDED SINCE DATA is not normal*/
/* Non Parametric Test- Kruskal-Wallis */

PROC NPAR1WAY DATA=L1.Final_Sample_SRS_Stratified WILCOXON;
    CLASS Group;
    VAR Test_Score;
RUN;

/* PROJECT ENDS HERE*/
/* PROJECT ENDS HERE*/

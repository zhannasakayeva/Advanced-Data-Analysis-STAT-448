/* 
   The data is based on 

	Concrete Compressive Strength Data Set, copyright I-Cheng Yeh, https://archive.ics.uci.edu/ml/datasets/Concrete+Compressive+Strength, 
		originally from I-Cheng Yeh, "Modeling of strength of high performance concrete using artificial neural networks," Cement and Concrete Research, 
		Vol. 28, No. 12, pp. 1797-1808 (1998).

	published on

  	Dua, D. and Karra Taniskidou, E. (2017). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml]. Irvine, CA: University of California, 
		School of Information and Computer Science.

   The data in concreteratios.csv divides the concrete components by the water content to specify component content as a ratio to water content. 
   The variables are

	Cement/Water ratio
 	Blast Furnace Slag/Water ratio
    Fly Ash/Water ratio
    Superplasticizer/Water ratio
	Coarse Aggregate/Water ratio
	Fine Aggregate/Water ratio
	Age (days)
	Concrete compressive strength (MPa, megapascals)
*/
data concreterats;
	infile "/home/u62133581/FinalProject/concreteratios.csv" dlm=",";
	input cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age compressivestrength;
	agegroup= 6;
	if age<7 then agegroup=1;
	if 7<=age<28 then agegroup=2;
	if 28<=age<56 then agegroup=3;
	if 56<=age<90 then agegroup=4;
	if 90<=age<180 then agegroup=5;
run;

*part 1;
proc univariate data=concreterats normaltest;
	var age compressivestrength;
	histogram compressivestrength;
    probplot compressivestrength;
	ods select Moments BasicMeasures Histogram ProbPlot GoodnessOfFit TestsForNormality;
run;
proc freq data=concreterats;
	table agegroup;
run; 
proc tabulate data=concreterats;
  class agegroup;
  var compressivestrength;
  table agegroup,
        compressivestrength*(mean std n);
run;
proc glm data=concreterats;
  class agegroup;
  model compressivestrength = agegroup;
  means agegroup /hovtest tukey cldiff welch;
  *ods select OverallANOVA FitStatistics ModelANOVA;
run;
proc sgscatter data=concreterats;
  matrix cementwater slagwater flyashwater superplasticizerwater coarsewater finewater compressivestrength;
run;

*part 2;
proc cluster data=concreterats method = average ccc pseudo outtree=averages;
	var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age;
	copy agegroup compressivestrength;
	ods select  CccPsfAndPsTSqPlot;
run;
proc tree data = averages ncl=6 out = clusters noprint;
   copy cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age;
   copy agegroup compressivestrength;
   * id R;
run;
proc freq data=clusters;
  tables cluster*agegroup/ nopercent norow nocol;
run;
proc sort data=clusters;
 by cluster;
run;
proc means data=clusters;
 var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age compressivestrength;
 by cluster;
run;
proc anova data=clusters;
  class cluster;
  model agegroup=cluster;
  means cluster/ hovtest cldiff tukey;
  ods select OverallANOVA CLDiffs HOVFTest;
run;
proc npar1way data=clusters wilcoxon DSCF;
	class cluster;
  	var agegroup;
run;

*part 3;
data new;
  set concreterats;
if (age => 90);
run;
proc corr data=new;
  var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age compressivestrength;
  ods select PearsonCorr;
run;

proc reg data=new plots=diagnostics ;
	model compressivestrength = cementwater slagwater flyashwater superplasticizerwater 
	coarsewater finewater / selection=stepwise sle=.05 sls=.05;
	output out=diagnostics2 cookd= cd;
run;
proc reg data=diagnostics2 plots=diagnostics;
	model compressivestrength = cementwater slagwater flyashwater superplasticizerwater 
	coarsewater finewater / selection=stepwise sle=.05 sls=.05;
	where cd < 0.08;
run;

*part 4;
data new2;
  set concreterats;
  if (age => 90) AND (age <= 100) AND (compressivestrength => 50) ;
run;
proc corr data=new2;
  var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age compressivestrength;
  ods select PearsonCorr;
run;
proc reg data=new2 plots=diagnostics;
	model compressivestrength = cementwater slagwater flyashwater superplasticizerwater 
	coarsewater finewater  / selection=stepwise sle=.05 sls=.05;
	output out=diagnostics3 cookd= cd1;
run;
proc reg data=diagnostics3 plots=diagnostics;
	model compressivestrength = cementwater slagwater flyashwater superplasticizerwater 
	coarsewater finewater  / selection=stepwise sle=.05 sls=.05;
	where cd1 < 0.08;
run;

*part 5;
proc stepdisc data=concreterats sle=.05 sls=.05;
   	class agegroup;
   	var cementwater slagwater flyashwater superplasticizerwater 
	coarsewater finewater compressivestrength ;
	ods select Summary;
run;
proc discrim data=concreterats pool=test crossvalidate manova;
  	class agegroup;
   	var cementwater slagwater flyashwater superplasticizerwater 
	coarsewater finewater compressivestrength;
   	priors proportional;
   	ods select ChiSq MultStat ClassifiedCrossVal ErrorCrossVal;
run;
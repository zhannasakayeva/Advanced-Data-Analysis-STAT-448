/* The following options are described in HomeworkOptionsAnnotated.sas in compass.
   Please refer to that file to determine which settings you wish to use or modify
   for your report.
*/
*ods html close;
*options nodate nonumber leftmargin=1in rightmargin=1in;
*title;
*ods escapechar="~";
*ods graphics on / width=4in height=3in;
*ods rtf file='FileNameWithFullPath.rtf'
        nogtitle startpage=no;
*ods noproctitle;
/* The raw data is based on

   http://archive.ics.uci.edu/ml/datasets/Statlog+(Heart)
    
   from the UCI Machine Learning Repository. 

   Dua, D. and Graff, C. (2019). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml]. 
   Irvine, CA: University of California, School of Information and Computer Science. 
*/
ods rtf file='/home/u62133581/Homework1/HW1Data.rtf' nogtitle startpage=no;
data heart;
	infile '/home/u62133581/Homework1/heart.dat';
	input age sex type restingbp serumchol over120 restingecg 
		maxheartrate exang oldpeak slope majvessels thal presence;
	keep restingbp serumchol maxheartrate presence;
run;

data heart;
	set heart;
	if presence=2 then heartdisease="presence";
		else heartdisease="absence";
	drop presence;
run;
/* Exercise 1a) */
proc univariate data=heart;
	var restingbp;
	ods select Moments BasicMeasures;
run;
/* Exercise 1b) */
proc sort data=heart;
	by heartdisease;
run;
proc univariate data=heart;
	var restingbp;
	by heartdisease;
	ods select Moments BasicMeasures;
run;
/* Exercise 2a) */
proc univariate data=heart normaltest;
	var restingbp;
	histogram restingbp /normal;
  	probplot restingbp;
	ods select Histogram ProbPlot TestsForNormality;
run;
	
/* Exercise 2b) */
proc univariate data=heart normaltest;
	var restingbp;
	histogram restingbp /normal;
  	probplot restingbp;
  	by heartdisease;
	ods select Histogram ProbPlot TestsForNormality;
run;
/* Exercise 3a) */
proc univariate data=heart mu0=120;
  var restingbp;
  class heartdisease;
  ods select TestsForLocation;
run;
proc univariate data=heart mu0=129 ;
  var restingbp;
  class heartdisease;
  ods select TestsForLocation;
run;
/* Exercise 3b) */
proc npar1way data=heart wilcoxon;
  class heartdisease;
  var restingbp;
  ods exclude KruskalWallisTest;
run;
/* Exercise 4a) */
proc sgscatter data=heart;
  title "Scatterplot Matrix for Heart Data";
  matrix restingbp serumchol maxheartrate ;
run;

title;
proc corr data=heart  spearman;
	run;
/* Exercise 4b) */
proc sgscatter data=heart;
  title "Scatterplot Matrix for Heart Data";
  matrix restingbp serumchol maxheartrate /group = heartdisease;
run;

title;
proc corr data=heart  spearman;
	by heartdisease;
	run;
ods rtf close;
	
/* data for exercises 1 and 2 
   The raw data file read in below is part of the data downloads from 
   Der and Everitt, A Handbook of Statistical Analyses using SAS 3rd Edition, Chapman and Hall.
   to run code, modify file path to point to you text book data files
*/
data diy;
infile '/home/u62133581/datasets/diy.dat' expandtabs;
  input y1-y6 / n1-n6;
  if _n_ in (1,2) then work='skilled';
  if _n_ in (3,4) then work='unskilled';
  if _n_ in (5,6) then work='office';
  array yall {6} y1-y6;
  array nall {6} n1-n6;
  do i=1 to 6;
    agegrp='younger';
	if i in(3,6) then agegrp='older';
    yes=yall{i};
	no=nall{i};
	output;
  end;
  drop i y1--n6;
/* after the following modification, the data set will contain:
  	work (skilled, unskilled, or office)
  	agegrp (groups 1 and 2 from the text are the younger group, 
  		and group 3 is the older group)
  	response (yes or no answer to question about whether the individual 
  		hired someone to do home improvements they would have previously 
  		done themseleves
  	n (count variable)
*/
data diy;
	set diy;
	response = 'yes'; n = yes; output;
    response = 'no'; n = no; output;
	drop no yes;
run;

/* data for Exercises 3 and 4 */
data newiris;
	set sashelp.iris;
	swgroup = "Shorter";
	if sepalwidth>30 then swgroup="Longer";
run;
/* Exercise 1a) */

proc freq data=diy;
  tables agegrp*response/nopercent norow nocol expected;
  weight n;
run;
/* Exercise 1b) */
* obtain results based on chi-square statistics and Fisher's exact test;
proc freq data=diy;
  tables agegrp*response/ nopercent norow nocol expected chisq;
  weight n;
run;
/* Exercise 1c) */
proc freq data=diy;
  tables agegrp*response/nopercent  nocol riskdiff;
  weight n;
run;
/* Exercise 2a) */
proc freq data=diy;
  tables work*response/nopercent norow nocol expected;
  weight n;
run;
/* Exercise 2b) */

* obtain results based on chi-square statistics and Fisher's exact test;
proc freq data=diy;
  tables work*response/ nopercent norow nocol expected chisq ;
  weight n;
run;
/* Exercise 3a) */
proc freq data=newiris;
  tables species*swgroup/nopercent norow nocol expected;
run;
/* Exercise 3b) */
proc freq data=newiris;
  tables species*swgroup/nopercent norow nocol expected chisq;
run;
/* Exercise 4a) */
proc anova data=newiris;
  class species;
  model sepalwidth = species;
run;
/* Exercise 4b) */
proc anova data=newiris;
  class species;
  model sepalwidth = species;
  means species /hovtest tukey cldiff;
run;
/* 
Data is based on the SAS Help fish data set and includes 
all observations with positive weights.
*/
data fishdata;
	set sashelp.fish;
	where weight > 0;
run;
* Exercise 1a);
ods text = "Exercise 1a):";
proc cluster data=fishdata method=average ccc pseudo plots=all outtree = averagec;
	var Length1 Length2 Length3 Height Width;
	copy Weight Species;
	ods select  Dendrogram CccPsfAndPsTSqPlot;
run;
proc tree data = averagec ncl=7 out = clusters noprint;
   copy Length1 Length2 Length3 Height Width;
   copy Weight Species;
run;
ods text="From dendrogram plot we can see that we may have 7 distinct clusters. We can see that ccc plot might not be a valid test here; it 
has a lot of negative values, that indicates the existence of outliers. The Pseudo F plot has a peak at 4. 
The pseudo t-squared has low points at 4 and 9. But, overall it is reasonable to have 7 clusters, since we also have 7 types of species. ";
* Exercise 1b);
ods text = "Exercise 1b):";
proc sort data=clusters;
 by cluster;
run;
proc anova data=clusters;
  class cluster;
  model Weight=cluster;
  means cluster/ hovtest cldiff tukey;
  ods select OverallANOVA CLDiffs HOVFTest;
run;
*proc npar1way data=clusters wilcoxon DSCF plots=none;
	*class cluster;
  	*var Weight;
  	*ods select WilcoxonScores DSCF;
  	*ods exclude WilcoxonScores KruskalWallisTest;
*run;
ods text="The parametric ANOVA is significant and there is an indication of at least one pair of groups that has unequal variances based on Levene’s test. And 
model is significant. We get significant differences in weights except cluster pairs 7 and 2, 2 and 6. ";
* Exercise 1c);
ods text = "Exercise 1c):";
proc freq data=clusters;
  tables Species*cluster/ nopercent norow nocol;
run;
ods text="Cluster 1 contains only Pike species, Cluster 2 only Bream. Cluster 3 has mostly Perch species, 
and includes some Roach(15), Parkki(7), Bream and Whitefish(3). Cluster 4 contains Smelt(14), Perch(10), 
Parkki(4) and Roach(3). Cluster 5 contains most of Bream, some of Perch(14), Pike(6), Whitefish(3) and one Roach. 
Cluster 6 contains Perch and Pike species. Cluster 7 has only 2 observations from Pike. And 
it matches with the results from part b).  ";
* Exercise 2a);
ods text = "Exercise 2a):";
proc stepdisc data=fishdata sle=.05 sls=.05;
   	class Species;
   	var Length1 Length2 Length3 Height Width;
	ods select Summary;
run;
ods text ="We can see that all the variables are significant based on stepwise selection summary.";
* Exercise 2b);
ods text = "Exercise 2b):";
proc discrim data=fishdata pool=test crossvalidate manova;
  	class Species;
   	var Length1 Length2 Length3 Height Width;
   	priors proportional;
   	ods select ChiSq MultStat ClassifiedCrossVal ErrorCrossVal;
run;
ods text="Test of Homogeneity of Within Covariance Matrices indicates a significant difference in covariance matrices across groups, 
and SAS proceeds with QDA for the model. The MANOVA tests are significant, so it should be 
possible to obtain some level of discrimination based on these 5 predictors.";
* Exercise 2c);
ods text = "Exercise 2c):";
ods text="The frequency table indicates that 100% were correctly classified for Species Bream, Parkki, 
Perch, Pike and Roach. About 79% of Species Smelt were correctly classified. And we do not have any 
correctly classified for Species Whitefish. Consequently we have 0% of misclassified observations for 
Species Bream, Parkki, Perch, Pike and Roach. Nearly 21% of Species Smelt are estimated to be misclassified by the model. 
We also can see that 100% of Species Whitefish were misclassified. So this group can be easily confused. This yields an overall error estimate of about 5.73%. 
";
* Exercise 3a);
ods text = "Exercise 3a):";
proc stepdisc data=fishdata sle=.05 sls=.05;
   	class Species;
   	var Weight--Width;
	ods select Summary;
run;
ods text ="Again we can see that all the variables are significant based on stepwise selection summary.";
* Exercise 3b);
ods text = "Exercise 3b):";
proc discrim data=fishdata pool=test crossvalidate manova;
  	class Species;
   	var Weight--Width;
   	priors proportional;
   	ods select ChiSq MultStat ClassifiedCrossVal ErrorCrossVal;
run;
ods text="Test of Homogeneity of Within Covariance Matrices indicates a significant difference in covariance matrices across groups, 
and SAS proceeds with QDA for the model. The MANOVA tests are significant, so it should be 
possible to obtain some level of discrimination based on these 6 predictors.";
* Exercise 3c);
ods text = "Exercise 3c):";
ods text="The frequency table indicates that 100% were correctly classified for Species Bream, Parkki, 
Perch, Pike and Roach. About 79% of Species Smelt were correctly classified. And we do not have any 
correctly classified for Species Whitefish. Consequently we have 0% of misclassified observations for 
Species Bream, Parkki, Perch, Pike and Roach. Nearly 21% of Species Smelt are estimated to be misclassified by the model. 
We also can see that 100% of Species Whitefish were misclassified. So this group can be easily confused. We also got 
the singular within-class covariance matrix for Whitefish class, this might indicate that the values are 
identical to other group fishes(f.e. Roach). This yields an overall error estimate of about 5.73%, so two models represented the same results. ";
/* Solution code for Homework 1 in Stat 448 
   Darren Glosemeyer and Yi Zhang, University of Illinois, Fall 2022 */
ods html close; 
options nodate nonumber leftmargin=1in rightmargin=1in;
title;
ods escapechar="~";
ods graphics / reset=all height=3in width=4in;
ods rtf file='C:\Stat 448\HW1SolutionFall2022.rtf' 
	nogtitle startpage=no;
ods noproctitle;
/* The raw data is based on

   http://archive.ics.uci.edu/ml/datasets/Statlog+(Heart)
    
   from the UCI Machine Learning Repository. 

   Dua, D. and Graff, C. (2019). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml]. 
   Irvine, CA: University of California, School of Information and Computer Science. 
*/
data heart;
	infile 'C:\Stat 448\heart.dat';
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
/* sort the data */
proc sort data=heart;
	by heartdisease;
run;
ods text="Exercise 1";
ods text="a) For resting blood pressure, the mean is 131.3, the median is 130, and the standard deviation is 17.9. The skewness of .723 indicates a tail to the right in the distribution.~n~n
Since there is a noticeable skew, the median and IQR should be used as the measure of location and spread. Roughly half of the resting blood pressures are expected to be greater than 130 and roughly half less than 130. The difference between the 75th percentile and 25th percentile is expected to be about 20.";
/* Exercise 1a */
proc univariate data=heart;
	var restingbp;
	ods select Moments BasicMeasures;
run;
ods text="";
ods text="b) Resting blood pressure for those without heart disease has a 
 mean of 128.9, median of 130, and standard deviation of 16.5. The skewness of .414 indicates a small tail to the right in the distribution.
 The skew is large enough that it would likely be noticed, so again median and IQR should be used. For individuals without heart disease, we expect roughly half 
 to have a resting blood pressure above 130 and roughly half below 130. The middle 50% of blood pressures is expected to span a range of about 20.~n~n
Resting blood pressure for those with heart disease has a mean of 134.4, median of 130, and standard deviation of 19.1. The skewness of .889 indicates a tail to the right in the distribution.
 The skew indicates that median and IQR should again be used. Half of those with heart disease are expected to have resting blood pressures above 130 and half below. The spread for those with heart disease is a bit wider with an IQR of 25.";
ods startpage=now;
 /* Exercise 1b */
proc univariate data=heart;
	var restingbp;
	by heartdisease;
	ods select Moments BasicMeasures;
run;
ods text="Exercise 2";
ods text="a) Normality tests, a histogram and a probability plot for the resting blood pressure levels for the entire sample follow. 
 The p-values for the normality tests are much less than .05, so we reject the null hypothesis that the data came from 
 a normal distribution. The histogram and probability plot do not look as bad, but there is some deviation from a bell shape and a straight line, so we see some visual indications 
 of deviation from normality, too. We conclude there is enough evidence of deviation from normality and assumptions of normality for this data will not be fine.";
/* Exercise 2a */
proc univariate data=heart normaltest;
	var restingbp;
	histogram/normal;
	probplot;
	ods select Histogram ProbPlot TestsForNormality;
run;
ods text="b) Considering the two subpopulations separately, we see that for those with or without heart disease, all four tests would reject 
 normality at a .05 level. The plots for those without heart disease show a little deviation from a bell 
 shape and a straight line. A case could be made for the blood pressures of those without heart disease to not be too far from normal based on the plots,
 but the tests clearly reject normality. 
 The plots for those with heart disease show more pronounced deviations from normality. Both the plots and tests reject normality for blood pressures of individuals with heart disease.
 Based on these results, we reject normality for both subpopulations.";
/* Exercise 2b */
proc univariate data=heart normaltest;
	var restingbp;
	histogram/normal;
	probplot;
	by heartdisease;
	ods select Histogram ProbPlot TestsForNormality;
run;
ods text="";
ods text="Exercise 3";
ods text="a) Given that the population is right skewed, we should look at one-sided Sign tests when comparing to hypothesized null medians of 120 and 129. The p-values provided are for two-sided tests 
 and the one-sided p-values will need to be computed from those results.";
/* Exercise 3a */
proc univariate data=heart mu0=120;
	var restingbp;
	where heartdisease="presence";
	ods select TestsForLocation;
run;
ods text="For the alternative that the true median is greater than 120, the statistic is positive. This means the difference is in the same direction as the greater alternative, and the p-value is half the two-sided p-value shown. 
 This means the p-value is much less than 0.0001, and we conclude there is strong evidence that the median resting blood pressure for those with heart disease is greater than 120.";
proc univariate data=heart mu0=129;
	var restingbp;
	where heartdisease="presence";
	ods select TestsForLocation;
run;
ods text="When comparing to a hypothesized median of 129, the two-sided p-value is 0.1203. The test statistic is again in the same direction as the alternative, so the one-sided p-value is about 0.06. 
 At a 0.05 level, the evidence is not strong enough to reject the null assumption that the true median is 129. The data do not support a statistically significant difference between the true median and 129. 
 Therefore, the median resting blood pressure is not statistically significantly greater than 129.";
ods text="~n";
ods text="b) Given the normality conclusions, the rank sum test will need to be used to perform a hypothesis test of whether those with heart disease have significantly higher resting blood 
 pressure levels than those without. The alternative for the one-sided test is that those with heart disease have significantly higher resting blood 
 pressure levels than those without. The p-value for that test is 0.0158, so we concluded that those with heart disease tend to have higher resting blood 
 pressure levels than those without.";
/* Exercise 3b */
proc npar1way data=heart wilcoxon;
	var restingbp;
	class heartdisease;
	ods exclude KruskalWallisTest;
run;
ods text="";
ods text="Exercise 4";
ods text="a) From the scatter plot, there are no extreme values and no apparent nonlinear relations, so we use Pearson correlation.";
/* Exercise 4a */
proc sgscatter data=heart;
	matrix restingbp serumchol maxheartrate;
run;
ods startpage=now;
ods text="Looking at the correlation matrix for the entire sample, we see there is a small but statistically significant positive correlation between resting blood pressure and serum cholesterol. The other correlations are insignificant.~n~n
Based on these results we conclude there is a weak but statistically significant tendency in the broader population for serum cholesterols to be higher when resting blood pressures are higher.";
proc corr data=heart pearson;
	var restingbp serumchol maxheartrate;
	ods select PearsonCorr;
run;
ods text="b) From the scatter plots for each subpopulation, there are again no extreme values or apparent nonlinear relations, so we use Pearson correlation.";
/* Exercise 4b */
proc sgscatter data=heart;
	matrix restingbp serumchol maxheartrate;
	by heartdisease;
run;
ods text="Analyzing by patient group, we see that none of the correlations are statistically significantly different from 0 for those without heart disease, so there is no significant 
 relationship between the three measures for those without heart disease.~n~n
For those with heart disease, the correlation between resting blood pressure and serum cholesterol is statistically significant and slightly greater than 
 it was in the full sample. For patients with heart disease, there is a weak but significant tendency for those with higher serum cholesterol to have higher resting blood pressure.~n~n
The difference between the two groups is the significance of this one correlation. Those without heart disease showed no relationship between serum cholesterol and resting blood pressure, 
 while those with heart disease showed a weak positive relationship. Likewise, the broader population showed a weak positive relationship between these two measures.";
proc corr data=heart pearson;
	var restingbp serumchol maxheartrate;
	by heartdisease;
	ods select PearsonCorr;
run;
ods rtf close;

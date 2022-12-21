/* The raw data file read in below is part of the data downloads from 
   Der and Everitt, A Handbook of Statistical Analyses using SAS 3rd Edition, Chapman and Hall.

   The data in uscrime.dat is described in Chapter 7 of that text.
*/
data uscrimeHW5;
    infile '/home/u62133581/datasets/USCRIME.DAT' expandtabs;
    input R Age S Ed Ex0 Ex1 LF M N NW U1 U2 W X;
	drop S Ex1;
run;
ods text="Exercise 1a):";
/* Exercise 1a*/
proc princomp data=uscrimeHW5;
	var Age Ed Ex0 LF M N NW U1 U2 W X;
   *id R;
run;
ods text ="We performed a PCA on all the possible predictors. We can see that we could keep first four 
components to retain 80% of the total variation from the original variables. We also could keep first 
three components(have eigenvalues greater than 1) based on the average eigenvalue(=1), and scree 
plot says says that we could keep first four components, since the plot becomes very flat starting 
at 5 for me. ";
ods text="Exercise 1b):";
/* Exercise 1b*/
ods text = "For component 1, on the positive side, W(wealth) and Ed(education level) have a little more impact than 
Ex0(police expenditure), LF(labor force), M(# of males). 
But none of them have important relationship to principal component 1. On the negative side, 
X(income inequality) has more impact than Age and NW(# of non-whites). But none of them are highly important.";
ods text="For component 2, on the positive side, U2 and N(state population size) have a little more 
impact than U1 and Ex0. On the negative side, LF and M are more important. ";
ods text="For component 3, on the positive side, U1 has more impact than M and U2. On the negative side, 
N and X0 have a similar impact. ";
ods text = "For component 4, we have only positive coefficients. M, LF, Ex0 and NW have similar impact 
on principal component 4. If one of them goes up, principal component 4 gets higher. ";
ods text="Exercise 1c):";
/* Exercise 1c*/
proc princomp data=uscrimeHW5 plots= score(ellipse ncomp=4);
   var Age Ed Ex0 LF M N NW U1 U2 W X;
   ods select ScorePlot;
run;
ods text ="The first plot shows that states 35, 20 and 29 have higher crime rates in general. And state 37 
has lowest. From the second plot we can see that states 45, 31 and 24 have higher values in component 3. 
While in the third plot, we see that states 24 and 31 have also high values in component 3, but near 
average in component 2. State 29 has the lowest value in component 3 and has higher value component 2. 
In the fourth plot, we see that state 37, 4 and 26 have higher values in component 4. But state 37 has 
the lowest values for component 1 and states 4 and 26 have higher values for component 1. In the fifth plot 
states 37 and 26 have higher values in component 4 and states 20, 29, 35 higher in component 2. 
State 4 has higher rate in general. Sixth plot shows that states 4, 37, 26 have higher crime rates 
for component 4 and states 24, 31 have higher rates for component 3.";
ods text="Exercise 2a):";
/* Exercise 2a*/
proc princomp data=uscrimeHW5 cov;
	var Age Ed Ex0 LF M N NW U1 U2 W X;
   *id R;
run;
ods text ="We now performed a covariance-based PCA on all the possible predictors. We can see that 
we could keep first two components to retain 80% of the total variation from the original 
variables. We also could keep first two components(have eigenvalues greater than 2453.590362) 
based on the average eigenvalue(=2453.590362), and scree plot says says that we could keep first 
two components, since the plot becomes very flat starting at 3 for me.";
ods text="Exercise 2b):";
/* Exercise 2b*/
ods text = "For component 1, on the positive side, W(wealth) has the highest impact and NW(# of non-whites) has the 
lowest impact. ";
ods text="For component 2, on the positive side, W and NW have the highest impact. On the negative side, 
M and X have the similar coefficient, however none of them are highly important to principal component 2. ";
ods text="Exercise 2c):";
/* Exercise 2c*/
proc princomp data=uscrimeHW5 cov plots= score(ellipse ncomp=2);
   var Age Ed Ex0 LF M N NW U1 U2 W X;
   *id R;
   ods select ScorePlot;
run;
ods text ="The score plot shows that state 22 has the lowest crime rate for component 1. While 
it is slighly above average for component 2. ";
ods text = "In the correlation results, we had chosen 4 principal components, while in the covariance case, we 
had only 2 components to retain 80%. This is due to the fact that some of the variables will have 
more impact than others.";
ods text="Exercise 3a):";
/* Exercise 3a*/
proc cluster data=uscrimeHW5 method=average ccc pseudo plots=all outtree = averagec;
	var LF U1 U2 W X;
	copy R;
	ods select  Dendrogram CccPsfAndPsTSqPlot;
run;
ods text ="From dendrogram plot we can see that we may have 2 distinct clusters. From the plot CCC, it is  
suggested we have higher value if there are 2 clusters. The same holds for Pseudo F plot, peak at 2. 
The pseudo t-squared has low points at 2, 3 and 7. So, overall we can say that 2 clusters might be 
a good choice.";
ods text="Exercise 3b):";
/* Exercise 3b*/
proc tree data = averagec ncl=2 out = clusters noprint;
   copy LF U1 U2 W X;
   copy R;
   * id R;
run;
proc sort data=clusters;
 by cluster;
run;

proc means data=clusters;
 var LF U1 U2 W X;
 by cluster;
run;
proc sgplot data=clusters;
  vbox R / category=cluster;
run;
ods text = "Cluster 1 includes states that tend to have higher LF(labor force) than Cluster 2. U1 is 
almost identical in both clusters. U2 in cluster 2 is slightly higher than in cluster 1. W(wealth) 
is higher for cluster 1 than for cluster 2. Cluster 2 consists of states that have higher X(income 
inequality) than Cluster 1. We have 28 observations in cluster 1 and 19 in cluster 2. States in Cluster 1 
tend to have higher crime rates than in Cluster 2. ";
ods text="Exercise 4a):";
/* Exercise 4a*/
proc cluster data=uscrimeHW5 method=average standard ccc pseudo plots=all outtree = averages;
	var LF U1 U2 W X;
	copy R;
	ods select  Dendrogram CccPsfAndPsTSqPlot;
run;
ods text ="From dendrogram plot we can see that we may have 4 or 5 distinct clusters. From the plot CCC it is 
suggested we have higher value if there are 3 and 5 clusters. The same holds for Pseudo F plot, peak at 3 or 5. 
The pseudo t-squared has low points at 3, 5 and 6. So, overall we can say that 5 clusters might be 
a good choice.";
ods text="Exercise 4b):";
/* Exercise 4b*/
proc tree data = averages ncl=5 out = clusterss noprint;
   copy LF U1 U2 W X;
   copy R;
   * id R;
run;
proc sort data=clusterss;
 by cluster;
run;

proc means data=clusterss;
 var LF U1 U2 W X;
 by cluster;
run;
proc sgplot data=clusterss;
  vbox R / category=cluster;
run;
ods text ="Cluster 1 includes states that tend to have higher values of LF. Cluster 5 has higher 
U1 values. However note that it has only one observation, so we might merge this cluster with another one. 
Cluster 5 also has higher U2 value as well. Cluster 2 includes states which have higher values of W. 
Cluster 4 consists of states that have high value of X. Cluster 1 has 20 observations, Cluster 2 has 
14, Cluster 3 and 4 have both 6, and Cluster 5 only one observation. States in Cluster 2 have higher 
crime rates in general comparing to the states in other clusters. ";
ods text = "Regarding the comparison, we can see that using standardized variables has led us 
to have more clusters, with one cluster having only one observation. ";

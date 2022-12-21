/* Data for HW3 */
data heart; set sashelp.heart;
	where status='Alive';
	if (weight=. or cholesterol=. or diastolic=. or chol_status=' ' or systolic=.) then delete;
	keep weight diastolic systolic cholesterol bp_status weight_status;
run; 
ods text = "Exercise 1a):";
/* Exercise 1a */
proc tabulate data=heart;
  class  bp_status weight_status;
  var cholesterol;
  table bp_status*weight_status,
        cholesterol*(mean std n);
run;
ods text = "The mean value of cholesterol for high blood pressure status appears to be higher 
than normal and optimal blood pressure status. We also can see that overweight weight status have 
higher mean values of cholesterol in all bp_status. While underweight weight status have lower mean 
values of cholesterol in general. The standard deviation values ranges between 32-56.";
/* Exercise 1b */
ods text="Exercise 1b):";
proc glm data=heart;
	class bp_status weight_status;
	model cholesterol = bp_status|weight_status;
run;
ods text="We can see from the first part that the data is unbalanced. Hence we will be using proc glm 
procedure. Based on the result of Type I SS, we can see that we might want to keep bp_status and 
weight_status, since we have p-value 0.7702 for the interaction term (bp_status*weight_status) 
(not significant). It is also can be observed from Type III table.";
/* Exercise 1c */
ods text="Exercise 1c):";
proc glm data=heart ;
	class bp_status weight_status;
	model cholesterol = bp_status weight_status;
	lsmeans bp_status weight_status/pdiff=all cl;
	ods select OverallANOVA FitStatistics ModelANOVA LSMeans LSMeanDiffCL ;
run;
ods text="So we chose the model with bp_status and weight_status. The F statistics of just over 38 
has a p-value of <.0001 and therefore it is determined that the bp_status and weight_status main 
effects together describe significantly more variation than expected due to chance. The R-Square 
value indicates that the percentage of variation described is not terribly large at just over 4.6%
(0.046524). Given that only a mean is in the model already, the model sum of squares would increase by 93881.9 
if bp_status is added. Given that a mean and origin are already included in the model, adding 
weight_status to the model increases the model sum of squares by 41128.6.The F statistics for both 
of the sources are statistically significant. The associated confidence interval for the 
difference of means for effect of bp_status indicates that the difference is statistically 
significant as 0 is not in the interval. While for effect of weight_status it is not the case, 
only for the last interval it is significant.
People with high blood pressure status were expected to have 223.6 cholesterol, with normal bp 
214.9 and with optimal 205.5. People with normal weight were expected to have 214.7 cholesterol 
level, with overweight 224.2 and underweight 205.04.";
/* Exercise 2a */
ods text="Exercise 2a):";
/*proc reg data=diagnostics;
	model cholesterol=weight;
run;*/
proc reg data=heart noprint;
	model cholesterol=weight;
	output out=diagnostics cookd= cd;
run;
proc reg data=diagnostics;
	model cholesterol=weight;
	where cd < 0.015;
	ods select ANOVA FitStatistics ParameterEstimates DiagnosticsPanel;
run;
ods text="We can see that there are no observations with Cook's distance larger than 0.015. Hence 
we are not removing any points from the dataset.";
/* Exercise 2b */
ods text="Exercise 2b):";
ods text="The results for fitting a simple linear regression model of cholesterol as a function of 
weight follow (part a). The model is statistically significant but it only describes 0.63% of the variation
in cholesterol. The intercept 𝛽0 is estimated to be about 203.57 and the slope 𝛽1 is estimated to 
be just 0.12, and both are statistically significant as indicated by the p-values less than 0.05. 
The slope indicates an expected increase of about only 0.12 cholesterol level for each increase of 
weight.
We can now interpret some of the diagnostic plots. Residuals look normal, however we see that there 
are right end and left end points lie above the diagonal line in quantile plot. It also can be seen from 
histogram that it is slightly positively skewed. The first two residuals plot look fine, so no need 
to worry about constant variance. However the plot(predicted value vs cholesterol) in the middle does not look good, so it does not 
seem to fit the data well, as it is not linear.
I would not say that this model will be good: 
although diagnostics is good, but we have very small percentage of variation explained. So weight could not be a good 
predictor for cholesterol.";
/* Exercise 3a */
ods text="Exercise 3a):";
/*proc reg data=heart;
	model cholesterol = diastolic weight;
run;*/
proc reg data=heart noprint;
	model cholesterol=diastolic weight;
	output out=diagnostics1 cookd= cd;
run;
proc reg data=diagnostics1;
	model cholesterol=diastolic weight;
	where cd < 0.015;
	ods select ANOVA FitStatistics ParameterEstimates DiagnosticsPanel;
run;
ods text="The results for fitting a simple linear regression model of cholesterol as a function of 
diastolic and weight follow. The model is statistically significant and it describes 3% of the 
variation in cholesterol. It is slightly lower than the variation in Exercise 1(categorical variables). But it is better comparing to 
the previous model in Exercise 2. Intercept and diastolic are statistically significant, however weight is not 
statistically significant (by looking at p-values). 
We can now interpret some of the diagnostic plots. Residuals look normal, however we see that there are right 
end and left end points lie above the diagonal line in quantile plot. It also can be seen from 
histogram that it is slightly positively skewed. There are no observations with Cook's distance larger than 0.015.
Residual plots look fine. ";
/* Exercise 3b */
ods text="Exercise 3b):";
proc sgscatter data=heart;
	matrix cholesterol diastolic systolic weight;
run;
/*proc reg data=heart;
	model cholesterol = diastolic systolic weight;
run;*/
proc reg data=heart noprint;
	model cholesterol=diastolic systolic weight;
	output out=diagnostics2 cookd= cd;
run;
proc reg data=diagnostics2;
	model cholesterol=diastolic systolic weight;
	where cd < 0.015;
	ods select ANOVA FitStatistics ParameterEstimates DiagnosticsPanel;
run;
ods text="Before fitting the model, we plotted pairwise scatter plot to see if there are any correlations between 
variables. It looks like there is a very strong positive linear trend for diastolic and systolic predictors.
The results for fitting a simple linear regression model of cholesterol as a function of diastolic, systolic and 
weight follow. The model is statistically significant and it describes 3.77% of the variation in cholesterol. 
It is slightly better comparing to the previous model. Intercept, diastolic and systolic are statistically 
significant, however weight is not statistically significant (by looking at p-values). We can now interpret 
some of the diagnostic plots. Residuals look normal, however we see that there are right 
end and left end points lie above the diagonal line in quantile plot. It also can be seen from 
histogram that it is slightly positively skewed. There are no observations with Cook's distance larger than 0.015. 
Residual plots look fine. The intercept 𝛽0 is estimated to be about 156.3, the coefficient for diastolic 
is estimated to be just 0.25, the coefficient for systolic is estimated to be 0.3 and for weight it is about 0.038. 
As we can see they are all positive. As the diastolic level increases by 1, about 0.25 cholesterol is expected. 
And as systolic level increases by 1, an increase of about 0.3 cholesterol is expected, as the weight increases by 1, 
an increase of about 0.038 cholesterol is expected.";
/* Exercise 4a */
ods text="Exercise 4a):";
proc reg data=heart;
	model cholesterol = diastolic systolic weight/ vif;
run;
proc reg data=heart;
	model cholesterol = diastolic systolic weight / selection=stepwise sle=.05 sls=.05;
run;
proc reg data=heart;
	model cholesterol = diastolic systolic weight / selection=forward sle=.05;
run;
proc reg data=heart;
	model cholesterol = diastolic systolic weight / selection=backward sls=.05;
run;
proc reg data=heart;
	model cholesterol = diastolic systolic weight / selection=adjrsq;
run;
ods text="We will first look at VIFs. We got VIF for diastolic 2.56, for systolic 2.45 and for weight 1.12. The values
were not that high to remove the variables. So, hence we did stepwise selection and got the final model with diastolic and systolic predictors. Based on the result, 
we can see that intercept, diastolic and systolic were significant (small p-values). Next we did forward selection, 
the results were the same as in stepwise selection. Finally we performed backward selection, it showed us the predictor 
that was removed, which is weight. In the preceding table, we can see the retained variables, diastolic and systolic. 
We could also select the model based on adjusted R-squared. However there is only 0.0002 difference between the R-squared 
values of the first and the second model. So we can choose more simpler model that was also chosen based on the first mentioned 
methods.";
/* Exercise 4b */
ods text="Exercise 4b):";
proc reg data=heart;
	model cholesterol = diastolic systolic ;
run;
ods text = "We now selected the final model with diastolic and systolic for modeling cholesterol. 
The diagnotics looks fine and very similar to the previous diagnostics results. There are also no observations 
with Cook's distance larger than 0.015. The model is highly statistically significant (F-value = 60.38) but it 
only describes 3.72% of the variation in cholesterol. The intercept 𝛽0 is estimated to be about 159.3 and the 
the coefficient for diastolic is estimated to be just 0.28, the coefficient for systolic is estimated to be 0.3. 
As we can see they are all positive. As the diastolic level increases by 1, about 0.28 cholesterol is expected. 
And as systolic level increases by 1, an increase of about 0.3 cholesterol is expected. I would not say that this 
model will be appropriate to use: although diagnostics is good, but we have very small percentage of variation explained. 
So there is very little of a relationship between the independent variables (diastolic, systolic) and 
dependent variable (cholesterol).";

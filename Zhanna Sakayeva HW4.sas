/* The source csv file was obtained from the UCI Machine Learning Repository
Dua, D. and Graff, C. (2019). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml].
Irvine, CA: University of California, School of Information and Computer Science.

The data, variables and original source are described on the following URL
http://archive.ics.uci.edu/ml/datasets/ILPD+%28Indian+Liver+Patient+Dataset%29
*/
proc import 
		datafile="/home/u62133581/datasets/Indian Liver Patient Dataset (ILPD).csv" 
		out=liver dbms=csv replace;
	getnames=no;
run;

/* after importing, rename the variables to match the data description */
data liver;
	set liver;
	Age=VAR1;
	Gender=VAR2;
	TB=VAR3;
	DB=VAR4;
	Alkphos=VAR5;
	Alamine=VAR6;
	Aspartate=VAR7;
	TP=VAR8;
	ALB=VAR9;
	AGRatio=VAR10;

	if VAR11=1 then
		LiverPatient='Yes';
	Else
		LiverPatient='No';
	drop VAR1--VAR11;
run;

* now only keep the adult observations;

data liver;
	set liver;
	where age>17;
run;
/* The source .data file was obtained from the UCI Machine Learning Repository
Dua, D. and Graff, C. (2019). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml].
Irvine, CA: University of California, School of Information and Computer Science.

The data, variables and original source are described on the following URL
http://archive.ics.uci.edu/ml/datasets/Liver+Disorders
*/
data bupa;
	infile "/home/u62133581/datasets/bupa.data" dlm="," missover;
	input mcv alkphos sgpt sgot gammagt drinks selector;
	four_oz=drinks*2;
	keep mcv alkphos sgot gammagt four_oz;
run;
/* Exercise 1a)*/
ods text="Exercise 1a):";
ods text="The output for logistic regression model predicting whether a female is a liver patient for females in the data set follows.";
DATA  fliver;    
	SET  liver;  
	where Gender = "Female";
RUN; 
proc logistic data=fliver desc plots=effect;
	*class Gender/param=ref ref=last;
	model LiverPatient=Age TB DB Alkphos Alamine Aspartate TP ALB AGRatio;
	output out=diagnostics cbar=cid;
run;
ods text = "We first fit the model by using all of the predictors and will see if there are any influential points. By looking at the diagnostics 
results, we can see that there are no influential points, so now we will perform model selection.";
proc logistic data=fliver desc plots=effect;
	*class Gender/param=ref ref=last;
	model LiverPatient=Age TB DB Alkphos Alamine Aspartate TP ALB AGRatio/selection=backward lackfit;
	output out=diagnostics cbar=cid;
run;
ods text="We have now our final model with only Aspartate predictor.";
/* Exercise 1b)*/
ods text="Exercise 1b):";
ods text="Looking at the table Model Fit statistics, the Log Likelihood column values under Intercept and Covariates can be compared to 
the Intercept Only column values. We have small values for both AIC and SC(163.433 and 169.214), so we may conclude that model with predictors will 
be better. The global tests indicate there is at least one significant parameter estimate. Hosmer-Lemeshow’s
test gives us p-value of 0.5454, which is larger than 0.05, hence we may conclude that we accept null hypothesis, and our model fits okay. There are 
no influential points based on cbar and diagnostics look fine.";
/* Exercise 1c)*/
ods text="Exercise 1c):";
ods text = "The odds ratio for Aspartate is 1.017, and it is significant. We performed backward selection and can see now that the confidence interval 
does not include 1. The odds of an adult female being a liver patient with liver disease increase by a factor of 1.017 with a one unit increase 
in Aspartate. ";
/* Exercise 2a)*/
ods text="Exercise 2a):";
ods text="The output for logistic regression model predicting whether a male is a liver patient for males in the data set follows.";
DATA  mliver;    
	SET  liver;  
	where Gender = "Male"; 
RUN; 
proc logistic data=mliver desc plots=effect;
	*class Gender/param=ref ref=first;
	model LiverPatient=Age TB DB Alkphos Alamine Aspartate TP ALB AGRatio;
	output out=diagnostics1 cbar=cid;
	
run;
ods text = "We first fit the model by using all of the predictors and will see if there are any influential points. By looking at the diagnostics 
results, we can see that there are no influential points, so now we will perform model selection.";
proc logistic data=mliver desc plots=effect;
	*class Gender/param=ref ref=first;
	model LiverPatient=Age TB DB Alkphos Alamine Aspartate TP ALB AGRatio/selection=backward lackfit;
	output out=diagnostics1 cbar=cid;
run;
ods text="We have now our final model with Age, DB, Alamine, TP and ALB predictors.";
/* Exercise 2b)*/
ods text="Exercise 2b):";
ods text="Looking at the table Model Fit statistics, the Log Likelihood column values under Intercept and Covariates can be compared to 
the Intercept Only column values. We have small values for both AIC and SC(401.843 and 426.099), so we may conclude that model with predictors will 
be better. The global tests indicate there is at least one significant parameter estimate. Hosmer-Lemeshow’s
test gives us p-value of 0.6109, which is larger than 0.05, hence we may conclude that we accept null hypothesis, and our model fits okay.
There are no influential points based on cbar and diagnostics look fine. ";
/* Exercise 2c)*/
ods text="Exercise 2c):";
ods text = "The odds ratio for Age is 1.019, for DB is 1.566, for Alamine is 1.019, for TP is 1.521 and for ALB is 0.483 and they are significant.
We performed backward selection and can see now that the confidence intervals do not include 1. The odds of an adult male being a liver patient 
with liver disease increase by a factor of 1.019 with a one unit increase in Aspartate when others are constant.The odds of an adult male being a liver patient 
with liver disease increase by a factor of 1.566 with a one unit increase in DB when others are constant.The odds of an adult male being a liver patient 
with liver disease increase by a factor of 1.019 with a one unit increase in Alamine when others are constant.The odds of an adult male being a liver patient 
with liver disease increase by a factor of 1.521 with a one unit increase in TP when others are constant.The odds of an adult male being a liver patient 
with liver disease increase by a factor of 0.484 with a one unit increase in ALB when others are constant.
By looking at the results we can see that we need more predictors to model predicting whether a male is a liver patient rather than predicting 
a female.";
/* Exercise 3a)*/
ods text="Exercise 3a):";
ods text = "We first consider a gamma log-linear model for four ounce drinks consumed per day as a function of four different predictors.";
proc genmod data=bupa;
	model four_oz=mcv alkphos sgot gammagt/ dist=gamma link=log type1 type3;
	* output out=gammares pred=presp_n stdreschi=presids stdresdev=dresids;
	ods select ModelInfo ModelFit ParameterEstimates Type1 ModelANOVA;
run;
ods text="First thing we can notice is that p-values for the predictors alkphos and sgot are larger than 0.05, so they are not statistically significant. 
However, to get to a final main effects model from here, we would want to remove terms one at a time based on type 3 and type 1 analyses. So both analyses 
say that we need to remove alkphos variable. Now we fit the model without alkphos.";
proc genmod data=bupa plots=(stdreschi stdresdev);
	model four_oz=mcv sgot gammagt/ dist=gamma link=log type1 type3;
	output out=gammares pred=presp_n stdreschi=presids stdresdev=dresids;
	ods select ModelInfo ModelFit ParameterEstimates Type1 ModelANOVA DiagnosticPlot;
run;
proc sgscatter data=gammares;
	compare y= (presids dresids) x=presp_n;
	where presp_n<100;
run;
ods text="We have removed alkphos variable and now see that sgot has become significant, p-value is 0.0462<0.05. ";
/* Exercise 3b)*/
ods text="Exercise 3b):";
ods text="So we have selected our best model based on Type 1 and Type 3 Analysis. Looking at the p-values for the parameter estimates, we 
can conclude that all of them are statistically significant. Residuals appear to have an upward trend, and it is also can be seen from the 
diagnostics plot. For the mcv variable, one increase in four_oz would result in an expected exp(0.0512)=1.053 multiplicative increase in number 
of four_oz. For sgot variable, one increase in four_oz would result in an expected exp(0.0130)=1.013 multiplicative increase in number 
of four_oz. For gammagt variable, one increase in four_oz would result in an expected exp(0.0040)=1.004 multiplicative increase in number 
of four_oz. ";
/* Exercise 4a)*/
ods text="Exercise 4a):";
ods text=" We now consider log-linear Poisson model for the same variable(four_oz).";
proc genmod data=bupa plots=(stdreschi stdresdev);
	model four_oz=mcv alkphos sgot gammagt/ dist=poisson  link=log type1 type3;
	output out=poisres pred=presp_n stdreschi=presids
		stdresdev= dresids;
	ods select ModelInfo ModelFit ParameterEstimates Type1 ModelANOVA DiagnosticPlot;
run;
proc sgscatter data=poisres;
	compare y= (presids dresids) x=presp_n;
	where presp_n<100;
run;
ods text ="We can see that p-values for all of the variables are less than 0.05, and we can conlude that all of them are significant. This is also 
can be confirmed by Type 1 and Type 3 analyses.";
* overdispersed Poisson ;
ods text="We can see from the previous model that our scaled deviance over degrees of freedom is far from 1(=5.0175), so there is a need to 
consider overdispersed Poisson as well.";
proc genmod data=bupa plots=(stdreschi stdresdev);
	model four_oz=mcv alkphos sgot gammagt / dist=p link=log type1 type3 scale=d;
	output out=poisres pred=presp_n stdreschi=presids stdresdev=dresids;
	ods select ModelInfo ModelFit ParameterEstimates Type1 ModelANOVA DiagnosticPlot;
run;
ods text ="First thing we can notice is that p-values for the predictors alkphos and sgot are larger than 0.05, so they are not statistically 
significant. To get to a final main effects model from here, we would want to remove terms one at a time based on type 3 and type 1 analyses.";
proc genmod data=bupa plots=(stdreschi stdresdev);
	model four_oz= mcv gammagt / dist=p link=log type1 type3 scale=d;
	output out=poisres pred=presp_n stdreschi=presids stdresdev=dresids;
	ods select ModelInfo ModelFit ParameterEstimates Type1 ModelANOVA DiagnosticPlot;
run;
proc sgscatter data=poisres;
	compare y= (presids dresids) x=presp_n;
	where presp_n<100;
run;
ods text="We removed both alkphos and sgot predictors since they were not significant, and Type 1 analysis also confirmed that we can remove 
alkphos. However removing just alkphos was not enough, so Type 3 analysis showed that sgot could be removed first actually. ";
/* Exercise 4b)*/
ods text="Exercise 4b):";
ods text = "Now we got our final models for regular log-linear Poisson and overdispersed Poisson.";
ods text="
1. Log-linear Poisson: Looking at the p-values for the parameter estimates, we 
can conclude that all of them are statistically significant.Residuals appear to have an upward trend, and it is also can be seen from the 
diagnostics plot. For the mcv variable, one increase in four_oz would result in an expected exp(0.0535)=1.055 multiplicative increase in number 
of four_oz. For alkphos variable, one increase in four_oz would result in an expected exp(0.0029)=1.003 multiplicative increase in number of four_oz.
For sgot variable, one increase in four_oz would result in an expected exp(0.0066)=1.007 multiplicative increase in number 
of four_oz. For gammagt variable, one increase in four_oz would result in an expected exp(0.0036)=1.004 multiplicative increase in number 
of four_oz. 
2. Overdispersed Poisson: Looking at the p-values for the parameter estimates, we 
can conclude that all of them are statistically significant. Residuals appear to have an upward trend, and it is also can be seen from the 
diagnostics plot. For the mcv variable, one increase in four_oz would result in an expected exp(0.0564)=1.058 multiplicative increase in number 
of four_oz. For gammagt variable, one increase in four_oz would result in an expected exp(0.0045)=1.0045 multiplicative increase in number 
of four_oz. 
As we can see the diagnostic plots were almost identical in all cases. However, looking at the estimates we can conclude that it will be reasonable 
to consider overdispersed Poisson model, since it is simple(involves only two predictors) and the estimates are little bit higher compared to the estimates in the previous (Gamma and regular Poisson models).";
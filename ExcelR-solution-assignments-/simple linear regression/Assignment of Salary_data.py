# -*- coding: utf-8 -*-
"""
Created on Sat Oct  5 19:57:07 2019

@author: pc
"""

# For reading data set
# importing necessary libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
# reading a csv file using pandas library
Salary_jinka=pd.read_csv("file:///F:/ASSIGNMENTS/simple linear regression/Salary_Data.csv")
Salary_jinka
plt.hist(Salary_jinka.YearsExperience)
plt.boxplot(Salary_jinka.YearsExperience)
plt.hist(Salary_jinka.Salary)
plt.boxplot(Salary_jinka.Salary)
plt.plot(Salary_jinka.YearsExperience,Salary_jinka.Salary,"bo");plt.xlable("YearsExperience");plt.ylabel('Salary')

Salary_jinka.corr()

# # correlation value between X and Y
Salary_jinka.Salary.corr(Salary_jinka.YearsExperience)
np.corrcoef(Salary_jinka.Salary,Salary_jinka.YearsExperience)
# For preparing linear regression model we need to import the statsmodels.formula.api
import statsmodels.formula.api as smf
model=smf.ols("Salary~YearsExperience", data=Salary_jinka).fit()
model
# For getting coefficients of the varibles used in equation 
model.params
# P-values for the variables and R-squared value for prepared model
model.summary()
# 95% confidence interval
model.conf_int(0.05)
# Predicted values of AT using the model
pred = model.predict(Salary_jinka.iloc[:,0])
pred
# Visualization of regresion line over the scatter plot of YearsExperience ans Salary
# For visualization we need to import matplotlib.pyplot
import matplotlib.pylab as plt
plt.scatter(x=Salary_jinka["YearsExperience"],y=Salary_jinka["Salary"],color="red");plt.plot(Salary_jinka)
pred.corr(Salary_jinka.Salary)# 0.97%
pred.corr(Salary_jinka.YearsExperience)
# Transforming variables for accuracy
model2 =smf.ols("Salary~np.log(YearsExperience)",data=Salary_jinka).fit()
model2
model2.params
model2.summary()
print(model2.conf_int(0.01))  #0.99%
pred2= model2.predict(pd.DataFrame(Salary_jinka["YearsExperience"]))
pred2
# pred2 = model2.predict(wcat.iloc[:,0])
plt.scatter(x=Salary_jinka["YearsExperience"],y=Salary_jinka["Salary"], color="green");plt.plot(Salary_jinka["YearsExperience"],pred2,color="blue");plt.xlable("YearsExperience");plt.ylabel("TISSUE")
# Exponential transformation
model3=smf.ols("np.log(Salary)~YearsExperience",data=Salary_jinka).fit()
model3
model3.params
model3.summary()
print(model3.conf_int(0.01))  # 0.99%
pred_log =model3.predict(pd.DataFrame(Salary_jinka["YearsExperience"]))
pred_log
pred3=np.exp(pred_log)
pred3
pred3.corr(Salary_jinka.Salary)
plt.scatter(x=Salary_jinka["YearsExperience"],y=Salary_jinka["Salary"], color="red");plt.plot(Salary_jinka.YearsExperience,np.exp(pred_log),color="green");plt.xlabel("YearsExperience");plt.ylabel("TISSUE")
resid_3 = pred3-Salary_jinka.Salary
resid_3
# so we will consider the model having highest R-Squared value which is the log transformation - model
# getting residuals of the entire data set
student_resid=model.resid_pearson
student_resid
plt.plot(model.resid_pearson,"0");plt.axhline(y=0,color="green");plt.xlabel("ObservationNumber");plt.ylabel("Standadrized Residual")
# Predicted vs actual values
plt.scatter(x=pred3,y=Salary_jinka.Salary);plt.xlabel("predicted");plt.ylabel("actual")

                #Implementing the Linear Regression model from sklearn library
from sklearn.linear_model import LinearRegression               
import numpy as np
plt.scatter(Salary_jinka.YearsExperience,Salary_jinka.Salary)
model1 = LinearRegression()
model1
model1.fit(Salary_jinka.YearsExperience.values.reshape(-1,1),Salary_jinka.Salary)
pred1= model1.predict(Salary_jinka.YearsExperience.values.reshape(-1,1))
pred1
# Adjusted R-Squared value
model1.score(Salary_jinka.YearsExperience.values.reshape(-1,1), Salary_jinka.Salary) # 0.956
rsme1=np.sqrt(np.mean(pred1-Salary_jinka.Salary)**2)  #7.27
rsme1
model1.coef_
model1.intercept_
#### Residuals Vs Fitted values
import matplotlib.pyplot as plt
plt.scatter(pred1,(pred1-Salary_jinka.Salary),c="r")
plt.hlines(y=0,xmin=0,xmax=30)
# checking normal distribution for residual
plt.hist(pred1-Salary_jinka.Salary)


# comments:-
 #here the intial stage without using any trasformations the r^2 value and adjusted r^2 values are 95% it means good correlation and better the model
 #after using the log tranformation on x variable the r^2 and adjusted r^2 values have been decreased to 85% it means not accuracy the model
 # after using the exp transformation on y variable the r^2 and adjusted r^2 are increased to 93% it also the good model what you hav epredicted but the first model accurate compare to the before using any tranformations
 # here the  model i have build with 95% accuracy of predicted data
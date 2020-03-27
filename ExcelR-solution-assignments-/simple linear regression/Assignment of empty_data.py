# -*- coding: utf-8 -*-
"""
Created on Fri Oct  4 19:16:17 2019

@author: pc
"""

# For reading data set
# importing necessary libraries
import pandas as pd 
import numpy as np
import matplotlib.pyplot as plt
# reading a csv file using pandas library
empty_data=pd.read_csv("file:///F:/ASSIGNMENTS/simple linear regression/emp_data.csv")
empty_data.columns
plt.hist(empty_data.Salary_hike)
plt.boxplot(empty_data.Salary_hike)
plt.plot(empty_data.Salary_hike,empty_data.Churn_out_rate);plt.xlable("Salary_hike");plt.ylabel("Churn_out_rate")
empty_data.corr()
empty_data.Salary_hike.corr(empty_data.Churn_out_rate)# # correlation value between X and Y
np.corrcoef(empty_data.Salary_hike,empty_data.Churn_out_rate)
# For preparing linear regression model we need to import the statsmodels.formula.api
import statsmodels.formula.api as smf
model_3=smf.ols("Salary_hike~Churn_out_rate",data=empty_data).fit()
# For getting coefficients of the varibles used in equation
model_3.params
# P-values for the variables and R-squared value for prepared model
model_3.summary()
# 95% confidence interval
model_3.conf_int(0.05)
pred_3= model_3.predict(empty_data.iloc[:,:])
# Visualization of regresion line over the scatter plot of Waist and AT
# For visualization we need to import matplotlib.pyplot
import matplotlib.pylab as plt
pred_3.corr(empty_data.Salary_hike)
pred_3.corr(empty_data.Churn_out_rate)
# Transforming variables for accuracy
mode4=smf.ols("Churn_out_rate~np.log(Salary_hike)",data=empty_data).fit()
mode4.params
mode4.summary()
# 99% confidence level
print(mode4.conf_int(0.01))
pred2 = model_3.predict(pd.DataFrame(empty_data["Churn_out_rate"]))
pred2.corr(empty_data.Salary_hike)
# pred2 = model2.predict(wcat.iloc[:,0])
pred2
plt.scatter(x=empty_data["Salary_hike"],y=empty_data["Churn_out_rate"],color="red");plt.plot(empty_data["Churn_out_data"],pred2,color="blue");plt.xlabel["Churn_out_rate"];plt.ylable["TISSUE"]
# Exponential transformation
model_4= smf.ols("np.log(Salary_hike)~Churn_out_rate",data=empty_data).fit()
model_4
model_4.params
model_4.summary()
# 99% confidence level
print(model_4.conf_int(0.01))
pred_log=model_4.predict(pd.DataFrame(empty_data["Churn_out_rate"]))
pred_log
 # as we have used log(AT) in preparing model so we need to convert it back
pred_4=np.exp(pred_log)
pred_4
pred_4.corr(empty_data.Salary_hike)
plt.scatter(x=empty_data["Salary_hike"],y=empty_data["Churn_out_rate"],color="green");plt.plot(empty_data.Salary_hike,np.exp(pred_log),color="blue");plt.xlabel["Salary_hike"];plt.ylabel["TISSUE"]
resid_3=pred_4-empty_data.Churn_out_rate
resid_3
# so we will consider the model having highest R-Squared value which is the log transformation - model3
# getting residuals of the entire data set
student_resid=model_4.resid_pearson
student_resid
empty_data["Salary_hike_Sq"]=empty_data.Salary_hike*empty_data.Salary_hike
model_quard=smf.ols("Churn_out_rate~Salary_hike+Salary_hike", data=empty_data).fit()
model_quard
model_quard.params
model_quard.summary()

#comment:-
  # here the intial the R^2 @ adjusted r^2 value is normal using the orgianl data without any transformations
  # after using log transformation the R^2 @ adjusted r^2 values has been increased 
  # after using the exponential transformation the R^2@ adjusted r^2 values are same
  # after using the quardadic tranformations the r^2 @ adjusted r^2 value has been decreased
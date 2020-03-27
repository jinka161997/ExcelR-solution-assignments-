

# Multilinear Regression
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
# loading the data
computer_j=pd.read_csv("file:///F:/ASSIGNMENTS/multi linear regression/Computer_Data.csv")
computer_j
# to get top 40 rows
computer_j.head(40)
# Correlation matrix 
computer_j.corr()
# Scatter plot between the variables along with histograms
import seaborn as sns
sns.pairplot(computer_j)
# columns names
computer_j.columns
# preparing model considering all the variables 
import statsmodels.formula.api as smf # for regression model
# Preparing model      
lm1=smf.ols("price~speed+hd+ram+screen+cd+multi+premium+ads+trend",data=computer_j).fit()# regression model
# Getting coefficients of variables               
lm1.params
# Summary
lm1.summary()
# preparing model based only on speed
lm_sp=smf.ols("price~speed",data=computer_j).fit()
lm_sp.params
lm_sp.summary()
# preparing model based only on ram
lm_ram=smf.ols("price~ram",data=computer_j).fit()
lm_ram.params
lm_ram.summary()
# preparing model based only on hd
lm_hd=smf.ols("price~hd",data=computer_j).fit()
lm_hd.params
lm_hd.summary()
# preparing model based on speed and hd
lm_sp_hd=smf.ols("price~speed+hd",data=computer_j).fit()
lm_sp_hd.params
lm_sp_hd.summary()
# Checking whether data has any influential values 
# influence index plots

import statsmodels.api as sm
sm.graphics.influence_plot(lm1)
# Studentized Residuals = Residual/standard deviation of residuals
computer_j_new=computer_j.drop(computer_j.index[[3783,4477,5960,1101,900,1440]],axis=0)
# Preparing model
lm_new=smf.ols("price~speed+hd+ram+screen+cd+multi+premium+ads+trend", data=computer_j_new).fit()
lm_new.params
lm_new.summary()
# Confidence values 99%
print(lm_new.conf_int(0.01)) # 99% confidence level
# Predicted values of profile
profile_pred=lm_new.predict(computer_j_new.[["speed","hd","ram","screen","cd","premium","trend"]])
computer_j_new
# calculating VIF's values of independent variables
rsq_hd=smf.ols("hd~speed+ram+screen+ads",data=computer_j_new).fit().rsquared
vif_hd=1/(1-rsq_hd) #3.1040286892611295

rsq_speed= smf.ols("speed~hd+ram+screen+ads",data=computer_j_new).fit().rsquared
vif_speed=1/(1-rsq_speed) #1.199513123900586

rsq_ram=smf.ols("ram~speed+hd+screen+ads",data=computer_j_new).fit().rsquared
vif_ram=1/(1-rsq_ram)   #2.6624394515645275

rsq_screen=smf.ols("screen~speed+ram+hd+ads",data=computer_j_new).fit().rsquared
vif_screen=1/(1-rsq_screen)  #1.0752170519057367
 # Storing vif values in a data frame
 d1={"Variables":["hd","ram","screen","speed"],"VIF":[vif_hd,vif_ram,vif_screen,vif_speed]}
Vif_frame = pd.DataFrame(d1)
#As hd is having higher VIF value, we are not going to include this prediction model
# Added varible plot 
sm.graphics.plot_partregress_grid(lm_new)
# added varible plot for hd is not showing any significance 
# final model
final_lm=smf.ols("price~ram+screen+speed",data=computer_j_new).fit()
final_lm
final_lm.paramas
final_lm.summary()
# As we can see that r-squared value has increased from 0.810 to 0.812.
price_pred=final_lm.predict(computer_j_new)
import statsmodels.api as sm
# added variable plot for the final model
sm.graphics.plot_partregress_grid(final_lm)
######  Linearity #########
# Observed values VS Fitted values
plt.scatter(computer_j_new.price,price_pred,c="r");plt.xlabel("observed_values");plt.ylabel("fitted_values")
# Residuals VS Fitted Values 
plt.scatter(price_pred,final_lm.resid_pearson,c="r"),plt.axhline(y=0,color='blue');plt.xlabel("fitted_values");plt.ylabel("residuals")
########    Normality plot for residuals ######
# histogram
plt.hist(final_lm.resid_pearson) # Checking the standardized residuals are normally distributed
# QQ plot for residuals 
import pylab          
import scipy.stats as st
# Checking Residuals are normally distributed
st.probplot(final_lm.resid_pearson, dist="norm", plot=pylab)

############ Homoscedasticity #######
# Residuals VS Fitted Values 
plt.scatter(price_pred,final_lm.resid_pearson,c="r"),plt.axhline(y=0,color='blue');plt.xlabel("fitted_values");plt.ylabel("residuals")
### Splitting the data into train and test data 

from sklearn.model_selection import train_test_split
computer_j_train,computer_j_test  = train_test_split(computer_j_new,test_size = 0.2)
# preparing the model on train data 
model_train = smf.ols("price~speed+ram+screen",data=computer_j_train).fit()
# train_data prediction
train_pred = model_train.predict(computer_j_train)
# train residual values 
train_resid  = train_pred - computer_j_train.price
# RMSE value for train data 
train_rmse = np.sqrt(np.mean(train_resid*train_resid))
# prediction on test data set 
test_pred = model_train.predict(computer_j_test)
# test residual values 
test_resid  = test_pred - computer_j_test.price
# RMSE value for test data 
test_rmse = np.sqrt(np.mean(test_resid*test_resid))
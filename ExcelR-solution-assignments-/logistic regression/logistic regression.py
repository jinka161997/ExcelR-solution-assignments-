

import pandas as pd
import numpy as np
import seaborn as sb
import matplotlib.pyplot as plt

from sklearn.linear_model import LogisticRegression 
from sklearn.cross_validation import train_test_split    # train and test 
from sklearn import metrics 
from sklearn import preprocessing
from sklearn.metrics import classification_report

# loading claimants data 
affairs_j = pd.read_csv("file:///F:/ASSIGNMENTS/Logistic regression/affairs.csv")
affairs_j.head()
# Droping first column 
affairs_j.drop(["sl.no"],inplace=True,axis=1)
dummies_affairs = pd.get_dummies(affairs_j,["gender","children"])

# usage lambda and apply function
# apply function => we use to apply custom function operation on 
# each column
# lambda just an another syntax to apply a function on each value 
# without using for loop 
affairs_j.isnull().sum()
import seaborn as sns
sns.boxplot(x="gender",y="age",data=affairs_j)
affairs_j.describe()
affairs_j.apply(lambda x:x.mean()) 
affairs_j.mean()
#Imputating the missing values with most repeated values in that column  

# lambda x:x.fillna(x.value_counts().index[0]) 
# the above line gives you the most repeated value in each column  

affairs_j.affairs.value_counts()
affairs_j.affairs.value_counts().index[0] # gets you the most occuring value

affairs_j.age.value_counts()
affairs_j.age.value_counts().index[0] # gets you the most occuring value
affairs_j.isnull().sum()
# filling the missing value with most occuring value    
affairs_j.iloc[:,0:4] = affairs_j.iloc[:,0:4].apply(lambda x:x.fillna(x.value_counts().index[0]))
affairs_j.isnull().sum()
affairs_j.iloc[:,0:4].columns
# Checking if we have na values or not 
affairs_j.isnull().sum() # No null values

#Model building 

import statsmodels.formula.api as sm
logit_model = sm.logit("affairs ~ gender_female + gender_male + age + yearsmarried  + children_no + children_yes + religiousness + education + occupation + rating", data = dummies_affairs).fit()

from scipy import stats
import scipy.stats as st
st.chisqprob = lambda chisq, df: stats.chi2.sf(chisq, df)
#summary
logit_model.summary()
y_pred = logit_model.predict(dummies_affairs)

dummies_affairs["pred_prob"] = y_pred
# Creating new column for storing predicted class of affairs
# filling all the cells with zeroes
dummies_affairs["Att_val"] = np.zeros(601)
dummies_affairs["Att_val"] = 0
# taking threshold value as 0.5 and above the prob value will be treated 
# as correct value 
dummies_affairs.loc[y_pred>=0.5,"Att_val"] = 1
dummies_affairs.Att_val

from sklearn.metrics import classification_report
classification_report(dummies_affairs.Att_val,dummies_affairs.affairs)
# confusion matrix 
confusion_matrix = pd.crosstab(dummies_affairs['affairs'],dummies_affairs.Att_val)

confusion_matrix
accuracy = (435+125)/(601) 
accuracy  # 0.93

# ROC curve 
from sklearn import metrics
# fpr => false positive rate
# tpr => true positive rate
fpr, tpr, threshold = metrics.roc_curve(dummies_affairs.affairs, y_pred)
# the above function is applicable for binary classification class 

plt.plot(fpr,tpr);plt.xlabel("False Positive");plt.ylabel("True Positive")
 
roc_auc = metrics.auc(fpr, tpr) # area under ROC curve 
### Dividing data into train and test data sets
dummies_affairs.drop("Att_val",axis=1,inplace=True)
from sklearn.model_selection import train_test_split

train,test = train_test_split(dummies_affairs,test_size=0.3)
# checking na values 
train.isnull().sum();test.isnull().sum()

# Building a model on train data set 

train_model = sm.logit('affairs ~ gender_female + gender_male + age + yearsmarried  + children_no + children_yes + religiousness + education + occupation + rating',data = train).fit()

#summary
train_model.summary()
train_pred = train_model.predict(train.iloc[:,1:])

# Creating new column for storing predicted class of Attorney

# filling all the cells with zeroes
train["train_pred"] = np.zeros(420)

# taking threshold value as 0.5 and above the prob value will be treated 
# as correct value 
train.loc[train_pred>0.5,"train_pred"] = 1

# confusion matrix 
confusion_matrix = pd.crosstab(train['affairs'],train.train_pred)

confusion_matrix
accuracy_train = ( 305+91)/(420) 
accuracy_train  # 0.94

# Prediction on Test data set

test_pred = train_model.predict(test)

# Creating new column for storing predicted class of Attorney

# filling all the cells with zeroes
test["test_pred"] = np.zeros(181)

# taking threshold value as 0.5 and above the prob value will be treated 
# as correct value 
test.loc[test_pred>0.5,"test_pred"] = 1

# confusion matrix 
confusion_matrix = pd.crosstab(test['affairs'],test.test_pred)

confusion_matrix
accuracy_test = (129+32)/(181)
accuracy_test  #0.88

#comment:- the accuracy of the train data 94% and accuracy of test data is 88%. while implementing the train data i have got 94% and which i got train data i have been appyied the test data too. 



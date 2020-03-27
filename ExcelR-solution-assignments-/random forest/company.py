import pandas as pd
import numpy as np
# Reading the Diabetes Data #################

company= pd.read_csv("file:///F:/ASSIGNMENTS/random forests/company(randomforest).csv")
company.head()

## Creating dummy variables for the given categorical data in the input
## Adding the dummy to the dataset
          
dummy2 = pd.get_dummies(company['Urban'])
company = pd.concat([company,dummy2],axis=1)

dummy3 = pd.get_dummies(company['US'])
company = pd.concat([company,dummy3],axis=1)

## Dropping the categorical columns after creating their dummy variables
company = company.drop(['Urban','US'],axis=1)

colnames = list(company.columns)
predictors = colnames[0:12]
target = colnames[12]

X = company[predictors]
Y = company[target]

####### GridSearch 

from sklearn.ensemble import RandomForestClassifier
rf = RandomForestClassifier(n_jobs=2,oob_score=True,n_estimators=400,criterion="entropy")

# n_estimators -> Number of trees ( you can increase for better accuracy)
# n_jobs -> Parallelization of the computing and signifies the number of jobs 
# running parallel for both fit and predict
# oob_score = True means model has done out of box sampling to make predictions

np.shape(company)  # 400, 11

#### Attributes that comes along with RandomForest function
rf.fit(X , Y) # Fitting RandomForestClassifier model from sklearn.ensemble 
rf.estimators_ # 
rf.classes_ # class labels (output)
rf.n_classes_ # Number of levels in class labels 
rf.n_features_  # Number of input features in model 8 here.

rf.n_outputs_ # Number of outputs when fit performed

rf.oob_score_  # 0.72916
rf.predict(X)

##############################

company['rf_pred'] = rf.predict(X)

from sklearn.metrics import confusion_matrix
confusion_matrix(company['ShelveLoc'],company['rf_pred']) # Confusion matrix

pd.crosstab(company['ShelveLoc'],company['rf_pred'])



print("Accuracy",(96+85+219)/(96+85+219)*100)

# Accuracy is100%
company["rf_pred"]

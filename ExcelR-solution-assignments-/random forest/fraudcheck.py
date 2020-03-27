import pandas as pd      ## For dataframe and functions on it
import numpy as np       ## For statistics and calculations
import matplotlib.pyplot as plt  ## For plotting

## Load the dataset
FChk = pd.read_csv("file:///F:/ASSIGNMENTS/random forests/Fraud_check(1).csv")
FChk.head()    ## Gives the first five rows as the output

## Creating dummy variables for the given categorical data in the input
## Adding the dummy to the dataset
dummy1 = pd.get_dummies(FChk['Marital.Status'])    
FChk = pd.concat([FChk,dummy1],axis=1)             

dummy2 = pd.get_dummies(FChk['Urban'])
FChk = pd.concat([FChk,dummy2],axis=1)

dummy3 = pd.get_dummies(FChk['Undergrad'])
FChk = pd.concat([FChk,dummy3],axis=1)

## Dropping the categorical columns after creating their dummy variables
FraudCheck = FChk.drop(['Marital.Status','Urban','Undergrad'],axis=1)

## Creating a function to divide the data into risky and good using if else
def f(row):
    if row['Taxable.Income'] <=30000:
        val=("Risky")
        return val
    else:
        val=("Good")
        return val

## Creating a new column and storing the Risky and Good values in it
FraudCheck['FC'] = FraudCheck.apply(f, axis=1)

FraudCheck.FC.value_counts      ## 600 values of Risky and Good
colnames = list (FraudCheck.columns)    ## Gives the list of all the column names in the given dataframe

## Separating the given dataset for Predictors and Targets for Training and Test data
predictors = colnames[:10]    ## Considering the first 10 input columns in predictors
target = colnames[10]         ## The output column

X = FraudCheck[predictors]
Y = FraudCheck[target]

####### GridSearch 

from sklearn.ensemble import RandomForestClassifier
rf = RandomForestClassifier(n_jobs=2,oob_score=True,n_estimators=600,criterion="entropy")

# n_estimators -> Number of trees ( you can increase for better accuracy)
# n_jobs -> Parallelization of the computing and signifies the number of jobs 
# running parallel for both fit and predict
# oob_score = True means model has done out of box sampling to make predictions

np.shape(FraudCheck)  # 600, 11

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

FraudCheck['rf_pred'] = rf.predict(X)

from sklearn.metrics import confusion_matrix
confusion_matrix(FraudCheck['FC'],FraudCheck['rf_pred']) # Confusion matrix

pd.crosstab(FraudCheck['FC'],FraudCheck['rf_pred'])



print("Accuracy",(476+124)/(476+124)*100)

# Accuracy is100%
FraudCheck["rf_pred"]

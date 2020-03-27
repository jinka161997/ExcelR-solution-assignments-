import numpy as np
import pandas as pd

from keras.models import Sequential
from keras.layers import Dense, Activation,Layer,Lambda

from sklearn.model_selection import train_test_split

# Reading data 
startup = pd.read_csv("file:///F:/ASSIGNMENTS/neural networks/startup_data.csv")
startup.head()

dummy = pd.get_dummies(startup['State'])    
startup = pd.concat([startup,dummy],axis=1)             

## Dropping the categorical columns after creating their dummy variables
startup = startup.drop(['State'],axis=1)

def prep_model(hidden_dim):
    model = Sequential()
    for i in range(1,len(hidden_dim)-1):
        if (i==1):
            model.add(Dense(hidden_dim[i],input_dim=hidden_dim[0],kernel_initializer="normal",activation="relu"))
        else:
            model.add(Dense(hidden_dim[i],activation="relu"))
    model.add(Dense(hidden_dim[-1]))
    model.compile(loss="mean_squared_error",optimizer="adam",metrics = ["accuracy"])
    return (model)

column_names = list(startup.columns)
predictors = column_names[0:6]
target = column_names[6]

first_model = prep_model([6,50,1])
first_model.fit(np.array(startup[predictors]),np.array(startup[target]),epochs=50)
pred_train = first_model.predict(np.array(startup[predictors]))
pred_train = pd.Series([i[0] for i in pred_train])
rmse_value = np.sqrt(np.mean((pred_train-startup[target])**2))
import matplotlib.pyplot as plt
plt.plot(pred_train,startup[target],"bo")
np.corrcoef(pred_train,startup[target]) # we got high correlation 89%


import numpy as np
import pandas as pd

import matplotlib.pyplot as plt
### load the dataset
zoo_df = pd.read_csv("file:///F:/ASSIGNMENTS/KNN/Zoo.csv")
zoo_df.head()

# Split dataset in training and test dataset
# Ignoring first and last columns as these columns contain non numeric values animal names and class tyeps respectively
#
from sklearn.model_selection import train_test_split
train,test = train_test_split(zoo_df,test_size = 0.2) # 0.2 => 20 percent of entire data 
train.columns
train.animal.value_counts()
test.animal.value_counts()

# KNN using sklearn 
# Importing Knn algorithm from sklearn.neighbors
from sklearn.neighbors import KNeighborsClassifier as KNC

# for 3 nearest neighbours 
neigh = KNC(n_neighbors= 3)

# Fitting with training data 
neigh.fit(train.iloc[:,1:18],train.iloc[:,1])

# train accuracy 
train_acc = np.mean(neigh.predict(train.iloc[:,1:18])==train.iloc[:,1]) # 98 %

# test accuracy
test_acc1 = np.mean(neigh.predict(test.iloc[:,1:18])==test.iloc[:,1]) # 95%

# for 5 nearest neighbours
neigh = KNC(n_neighbors=5)

# fitting with training data
neigh.fit(train.iloc[:,1:18],train.iloc[:,1])

# train accuracy 
train_acc_ = np.mean(neigh.predict(train.iloc[:,1:18])==train.iloc[:,1])

# test accuracy
test_acc_ = np.mean(neigh.predict(test.iloc[:,1:18])==test.iloc[:,1])

# creating empty list variable 
acc = []

# running KNN algorithm for 3 to 50 nearest neighbours(odd numbers) and 
# storing the accuracy values 
 
for i in range(3,50,2):
    neigh = KNC(n_neighbors=i)
    neigh.fit(train.iloc[:,1:18],train.iloc[:,1])
    train_acc = np.mean(neigh.predict(train.iloc[:,1:18])==train.iloc[:,1])
    test_acc = np.mean(neigh.predict(test.iloc[:,1:18])==test.iloc[:,1])
    acc.append([train_acc,test_acc])

import matplotlib.pyplot as plt # library to do visualizations 

# train accuracy plot 
plt.plot(np.arange(3,50,2),[i[0] for i in acc],"bo-")

# test accuracy plot
plt.plot(np.arange(3,50,2),[i[1] for i in acc],"ro-")

plt.legend(["train","test"])

# here the train and test data with 5 nearest neibhours have fitted with train data accuracy is 98% and test data accuracy is 95 %

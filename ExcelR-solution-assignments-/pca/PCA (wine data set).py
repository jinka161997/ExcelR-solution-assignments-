# data manipulation
import pandas as pd 
  
 # basic arthamatic operations
import numpy as np    

# loading the data set from csv files
win = pd.read_csv("file:///F:/ASSIGNMENTS/PCA/wine.csv")
win.describe()   # all the variables eda(exploratory data analysis)
win.head()       # it will show first 5 variables data

win.mean()
win.median()

# import neccesary libraries for data manipulation 
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
from sklearn.preprocessing import scale 

# Considering only numerical data 
win.data = win.ix[::]
win.data.head(5)
WIN= win.data.values
# Normalizing the numerical data 
win_normal = scale(WIN)

pca = PCA(n_components = 14)
pca_values = pca.fit_transform(win_normal)

# The amount of variance that each PCA explains is 
var = pca.explained_variance_ratio_
var
pca.components_[0]

# Cumulative variance 
var1 = np.cumsum(np.round(var,decimals = 4)*100)
var1

# Variance plot for PCA components obtained 
plt.plot(var1,color="red")

# plot between PCA1 and PCA2 
x = pca_values[:,0]
y = pca_values[:,1]
z = pca_values[:,2:3]
plt.scatter(x,y,color=["red"])

from mpl_toolkits.mplot3d import Axes3D
Axes3D.scatter(np.array(x),np.array(y),np.array(z),c=["green","blue","red"])

################### Clustering  ##########################
new_df = pd.DataFrame(pca_values[:,0:14])

from sklearn.cluster import KMeans

kmeans = KMeans(n_clusters = 3)
kmeans.fit(new_df)
kmeans.labels_

################### hirarchial  ##########################
# alternative normalization function 

def norm_func(i):
    x = (i-i.mean())/(i.std())
    return (x)

# Normalized data frame (considering the numerical part of data)
df_norm = norm_func(win.iloc[::])

from scipy.cluster.hierarchy import linkage 

import scipy.cluster.hierarchy as sch # for creating dendrogram 

type(df_norm)

#p = np.array(df_norm) # converting into numpy array format 
help(linkage)
z = linkage(df_norm, method="complete",metric="euclidean")

plt.figure(figsize=(15, 5));plt.title('Hierarchical Clustering Dendrogram');plt.xlabel('Index');plt.ylabel('Distance')
sch.dendrogram(
    z,
    leaf_rotation=0.,  # rotates the x axis labels
    leaf_font_size=8.,  # font size for the x axis labels
)
plt.show()

# Now applying AgglomerativeClustering choosing 3 as clusters from the dendrogram
from	sklearn.cluster	import	AgglomerativeClustering 
h_complete	=	AgglomerativeClustering(n_clusters=3,	linkage='complete',affinity = "euclidean").fit(df_norm) 


cluster_labels=pd.Series(h_complete.labels_)

win['clust']=cluster_labels # creating a  new column and assigning it to new column 
win = win.iloc[:,[0,1,2,3,4,5,6,7,8,9,10,11,12,13]]
win.head()

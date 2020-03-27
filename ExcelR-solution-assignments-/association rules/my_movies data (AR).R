my_movies<-read.csv(file.choose())
View(my_movies)
str(my_movies)

# converting everything into character format
my_movies[]<-lapply(my_movies,as.character)
View(my_movies)

# Creating a custom fucntion to collapse all the items in a transaction into 
# a single sentence 
paste_fun <- function(i){
  return (paste(as.character(i),collapse=" "))
}

# Applying the custom function
my_movies["new_col"]<-apply(my_movies,1,paste_fun)
View(my_movies)

# tm package is used to do text manipulation and forming DTM and TDM matrices
install.packages("tm")
library(tm)

# Selecting the new column which
x <- Corpus(VectorSource(my_movies$new_col))

# contains all items of a transaction in a single sentence
x <- tm_map(x,stripWhitespace)

# Creating a TDM matrix
dtm0 <- t(TermDocumentMatrix(x))
# Converting TDM matrix to data frame
dtm0_df <- data.frame(as.matrix(dtm0))
View(dtm0_df)

# Association Rules 

library(arules)
library(arulesViz)
# Item Frequecy plot
windows()

# count of each item from all the transactions 
barplot(sapply(dtm0_df,sum),col=1:10)

# Applying apriori algorithm to get relevant rules
rules <- apriori(as.matrix(dtm0_df),parameter = list(support=0.002,confidence=0.5,minlen=2))
inspect(rules)
plot(rules)

# Sorting rules by confidence 
rules_conf <- sort(rules,by="confidence")
inspect(rules_conf)
# Sorint rules by lift ratio
rules_lift <- sort(rules,by="lift")
inspect(rules_lift)

# Visualizing rules in scatter plot
plot(rules,method = "graph")
plot(rules,method = "scatterplot")
plot(rules,method = "grouped")
plot(rules,method = "mosaic")

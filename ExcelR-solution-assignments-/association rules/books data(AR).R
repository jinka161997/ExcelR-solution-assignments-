
# installization of package for building association rules
install.packages("arules")    
library(arules)

# installization of package for visuvalising the association model
install.packages("arulesViz",dependencies = TRUE)
library(arulesViz)

book<-read.csv(file.choose())     # loading the books data set
View(book)

# installization of development tools
install.packages("devtools") 
library(devtools)
?devtools

# installization of github packages in visuvalization purpose
install_github("mhahsler/arulesViz")

book_trans<-as(as.matrix(book),"transactions")   # it shows trasactions in matix format
book_trans
inspect(book_trans[1:100])   # here we are inspecting the 100 books transactions

# if we insprect book_trans
#we should get transactions of items i.e
# as awe have 2000rows    so we should get 2000 transactions
# each row represents one transactions
# after converting the binary format of data frame from matrix
# perform apriori algorithm


#  building the model using apriori algorithm 
rules<-apriori(as.matrix(book),parameter = list(support=0.002,confidence=0.5))
inspect(rules[1:100])   # getting the model first 100 transactions 
plot(rules)    #ploting the data 

# Sorting rules by confidence 
rules_conf <- sort(rules,by="confidence")
inspect(rules_conf)

# Sorint rules by lift ratio
rules_lift <- sort(rules,by="lift")
inspect(rules_lift)
plot(rules,method = "graph") # ploting the data  with lift ratio

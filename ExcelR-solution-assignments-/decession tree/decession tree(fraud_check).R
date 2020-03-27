#install.packages("C50")
#install.packages("tree")

library(C50)
library(tree)

#loading the data set
fraud_check<-read.csv(file.choose())
colnames(fraud_check)
summary(fraud_check)
plot(fraud_check$Taxable.Income)

Taxable.Income<- NULL
Taxable.Income<-ifelse(fraud_check$Taxable.Income <30000,1,0 )
fraud_check[,"Taxable.Income"]<- Taxable.Income

fraud_check$Work.Experience<- as.factor(fraud_check$Work.Experience)
fraud_check$City.Population<-as.factor(fraud_check$City.Population)
fraud_check$Marital.Status<-as.factor(fraud_check$Marital.Status)
fraud_check$Urban<-as.factor(fraud_check$Urban)
fraud_check$Undergrad<-as.factor(fraud_check$Undergrad)
fraud_check$Taxable.Income<-as.factor(fraud_check$Taxable.Income)

Taxable.Income_high<-fraud_check[fraud_check$Taxable.Income=="1",]
Taxable.Income_low<-fraud_check[fraud_check$Taxable.Income=="0",]

data_train<-rbind(Taxable.Income_high[1:100,],Taxable.Income_low[1:376,])
data_test<-rbind(Taxable.Income_high[101:124,],Taxable.Income_low[377:476,])

trained_model <- C5.0(data_train[,-c(12)], data_train$Taxable.Income)
plot(trained_model)

mean(data_train$Taxable.Income == predict(trained_model, data_train))

pred_test <- predict(trained_model, newdata = data_test)

mean(pred_test == data_test$Taxable.Income)

install.packages("gmodels")
library(gmodels)

CrossTable(data_test$Taxable.Income, pred_test)
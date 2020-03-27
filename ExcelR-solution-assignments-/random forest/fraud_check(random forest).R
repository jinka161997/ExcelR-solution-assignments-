# Using Random Forest
install.packages("randomForest")
library(randomForest)
library(caret)

fraud_check<-read.csv(file.choose())
View(fraud_check)

# Splitting data into training and testing. As the species are in order 
# splitting the data based on species 
fraud_check_Single<-fraud_check[fraud_check$Marital.Status=="Single",]
fraud_check_Divorced	<-fraud_check[fraud_check$Marital.Status=="Divorced",]
fraud_check_Married<-fraud_check[fraud_check$Marital.Status=="Married",]

fraud_check_train<- rbind(fraud_check_Single[1:119,],fraud_check_Divorced[1:95,],fraud_check_Married[1:97,])
fraud_check_test<-rbind(fraud_check_Single[120:217,],fraud_check_Divorced[96:189,],fraud_check_Married[98:194,])

# Building a random forest model on training data 
fit.forest <- randomForest(Marital.Status~.,data=fraud_check_train, na.action=na.roughfix,importance=TRUE)

# Training accuracy 
mean(fraud_check_train$Marital.Status==predict(fit.forest,fraud_check_train)) # 100% accuracy 

# Prediction of train data
pred_train <- predict(fit.forest,fraud_check_train)
library(caret)

# Confusion Matrix
confusionMatrix(fraud_check_train$Marital.Status, pred_train)
# here the model accuracy is 100% which means model is accurate enough.

# Predicting test data 
pred_test <- predict(fit.forest,newdata=fraud_check_test)
mean(pred_test==fraud_check_test$Marital.Status) # Accuracy = 94.6 % 


# Confusion Matrix 
library(caret)
confusionMatrix(fraud_check_test$Marital.Status, pred_test)

# Visualization 
plot(fit.forest,lwd=2)
legend("topright", colnames(fit.forest$err.rate),col=1:4,cex=0.8,fill=1:4)
varImpPlot(fit.forest)

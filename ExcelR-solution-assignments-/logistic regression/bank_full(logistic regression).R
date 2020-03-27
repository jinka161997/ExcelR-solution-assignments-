# loading the data set
bank_full<-read.csv(file.choose())
summary(bank_full)  # basic statistics and business movement decessions
str(bank_full)
attach(bank_full)

plot(bank_full$y)  #visuvalization on yes and no senario wether client has term deposit taken or not

model<- glm(y~.,data=bank_full,family = "binomial")
summary(model)

prob<-predict(model,type = c("response"),bank_full)
prob

confusion<- table(prob>0.5,bank_full$y)
confusion

#model accuracy

accuracy<-sum(diag(confusion)/sum(confusion))
accuracy  # 90%

install.packages("ROCR")
library(ROCR)
rocrpred<-prediction(prob,bank_full$y)
rocrperf<-performance(rocrpred,"tpr","fpr")
rocrperf2<-performance(rocrpred,measure = "auc")
?performance
plot(rocrperf,colorize=T)


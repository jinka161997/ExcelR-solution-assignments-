delivery_time<-read.csv(file.choose())
delivery_time
attach(delivery_time)
pnorm(Delivery.Time)
pnorm(Sorting.Time)
plot(delivery_time)
summary(delivery_time)
plot(delivery_time$Delivery.Time,delivery_time$Sorting.Time)
cor(Delivery.Time,Sorting.Time)
regression_delivey<-lm(Delivery.Time~Sorting.Time)
regression_delivey
summary(regression_delivey)
confint(regression_delivey,level = 0.95)
predict(regression_delivey)
pred_reg <-predict(regression_delivey)
pred_reg
regression_delivey$residuals
sum(regression_delivey$residuals)
mean(regression_delivey$residuals)
sqrt(sum(regression_delivey$residuals^2))
sqrt(mean(regression_delivey$residuals^2))
confint(regression_delivey, level = 0.95)
predict(regression_delivey, interval = "predict")
install.packages(ggplot2)
library(ggplot2)
ggplot(data = delivery_time,aes(x=Delivery.Time,y=Sorting.Time))
plot(log(Delivery.Time),Sorting.Time)
cor(log(Delivery.Time),Sorting.Time)
regression_log<-lm(Sorting.Time~log(Delivery.Time))
regression_log
summary(regression_log)
predict(regression_log)
regression_log$residuals
sqrt(sum(regression_log$residuals^2))/nrow(delivery_time)
sqrt(mean(regression_log$residuals^2))/nrow(delivery_time)
confint(regression_log,level=0.95)
predict(regression_log,interval = "confidence")
plot(Delivery.Time,log(Sorting.Time))
cor(Delivery.Time,log(Sorting.Time))
regression_exp<-lm(Delivery.Time~log(Sorting.Time))
regression_exp
summary(regression_exp)
sqrt(mean(regression_exp$residuals^2))  # squire root the residuals of exp
logat_delivery <- predict(regression_exp) # predict the regression exp transformation
logat_delivery
at_delivery<-exp(logat_delivery)
at_delivery
error=delivery_time$Delivery.Time-at_delivery
error
expy3<-exp(logat_delivery)
expy3

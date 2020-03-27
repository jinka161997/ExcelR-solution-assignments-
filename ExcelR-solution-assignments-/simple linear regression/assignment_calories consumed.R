calories_consumed<- read.csv(file.choose()) # loading the data set from the file

View(calories_consumed)  # view the data set which ever you have loaded
attach(calories_consumed)   # attach the data set for better understanding model
pnorm(Weight.gained..grams.,Calories.Consumed)  # checking the probability normal distrubution by using pnorm function
plot(calories_consumed)   # plot the data set
summary(calories_consumed)  # check the summary of the data using summary function
plot(calories_consumed$Weight.gained..grams.,calories_consumed$Calories.Consumed) # plot the for two variables x and y
cor(Weight.gained..grams.,Calories.Consumed)  # check the correlation between the two variables x and y 
regression_simple<-lm(Weight.gained..grams.~Calories.Consumed)  # use the regresson model by using lm function
summary(regression_simple)  # check the summary of the regression model
confint(regression_simple,level = 0.95) # check the level of confidence taking the regression model
predict(regression_simple)  # predict the simple regression and best fit line
predict_reg <- predict(regression_simple)   #predict the simple regression and best fit line
predict_reg
regression_simple$residuals  # find the regression of the residuals(errors)
sum(regression_simple$residuals) # take the sum of the regression resuduals(sum the residuals)
mean(regression_simple$residuals)  # take the average of the residuals(errors)
sqrt(sum(regression_simple$residuals^2))/nrow(calories_consumed) # squire the values which ever yoy have made sum
sqrt(mean(regression_simple$residuals^2))  # sqire the mean of the residuals
confint(regression_simple,level = 0.95) # take confidence level of simple linear regression
predict(regression_simple,interval = "predict")  # predict the simple regression by using the predict function
install.packages("ggplot2")   # install the packages by using the install.packages or directly click on the packages 
library(ggplot2)  # library the packages which ever you have installed otherwise it won't show the conslore results 
# show the visuvalization
ggplot(data=calories_consumed,aes(x=Weight.gained..grams.,y=Calories.Consumed))+geom_point(color="blue")+goem_line(color="red",data=calories_consumed,aes(x=Weight.gained..grams.,y=predict_reg))
plot(log(Weight.gained..grams.),Calories.Consumed) #plot the data which you have used logorithem function for batter improvised the r^2 value
cor(log(Weight.gained..grams.),Calories.Consumed) # check the correlation values for you loeade the logorithem function
reg_log<-lm(Calories.Consumed ~log(Weight.gained..grams.))  # apply the log function for better improvised r^2 value and better the model
reg_log
summary(reg_log)  # get the summary of log results which you used for x variable 
predict(reg_log)  # predict the results after using the log function 
reg_log$residuals  # get the residuals(error)
sqrt(sum(reg_log$residuals^2)/nrow(calories_consumed)) # squire the values whcih ever you made sum of the values
confint(reg_log,level=0.95)  
predict(reg_log,interval="confidence")  # predict the after sing log function and get the confidance level 
plot(Weight.gained..grams.,log(Calories.Consumed))  # plot the data for log transformations
cor(Weight.gained..grams.,log(Calories.Consumed))   #correlation for log(y) transformation which means exponential tansformation
reg_exp<-lm(Weight.gained..grams.~log(Calories.Consumed)) # use the exponential transformation by sung the exp function
reg_exp
summary(reg_exp)  # get the summry of the exponential tranformation
sqrt(mean(reg_exp$residuals^2))  # squire root the residuals of exp
logat <- predict(reg_exp) # predict the regression exp transformation
logat
at <- exp(logat)
at
error=calories_consumed$Calories.Consumed-at  # find the errors
error
 #using quardadic transformation
reg_quard<-lm(log(Calories.Consumed)~Weight.gained..grams.+I(Weight.gained..grams.*Weight.gained..grams.)+I(Weight.gained..grams.*Weight.gained..grams.*Weight.gained..grams.))
reg_quard
summary(reg_quard) # find the summary of quard transformation
logpol3<-predict(reg_quard) # predict the querdadic values
logpol3
expy3<-exp(logpol3)
expy3
install.packages(ggplot) # install the ggplot package
library(ggplot)
?ggplot
install.packages("tidyverse")  # for installization of the same ggplot
library(tidyverse)

install.packages("forecast")
library(forecast)

install.packages("fpp")
library(fpp)

?fpp
install.packages("smooth")
library(smooth) # forsmoothing and MAPE

install.packages("tseries")
library(tseries)

library(readxl)
Airlines<-read.csv(file.choose())
View(Airlines)
plot(Airlines$Passengers,type="o")

# Converting data into time series object
?ts

tspassanger<-ts(Airlines$Passengers,frequency = 12, start = c(96))
View(tspassanger)

# dividing entire data into training and testing data 
train<-tspassanger[1:84]
test<-tspassanger[85:96] # Considering only 12 variables monthly wise  of data for testing because data itself is monthly
# seasonal data

# converting time series object
train<-ts(train,frequency = 12)
test<-ts(test,frequency = 12)

# Plotting time series data
plot(tspassanger) # Visualization shows that it has level, trend, seasonality => Additive seasonality

#### USING HoltWinters function ################ simple exponential smoothing
# Optimum values
# with alpha = 0.2 which is default value
# Assuming time series data has only level parameter
hw_a<-HoltWinters(train,alpha = 0.2,beta = F,gamma = F)
hw_a
hwa_pred<-data.frame(predict(hw_a,n.ahead=12))

# By looking at the plot the forecasted values are not showing any characters of train data 
plot(forecast(hw_a,h=12))
hwa_mape<-MAPE(hwa_pred$fit,test)*100  # mean absolute percentage error
#17.23

# with alpha = 0.2, beta = 0.1  # duble exponential smoothing
# Assuming time series data has level and trend parameter 
hw_ab<-HoltWinters(train,alpha = 0.2,beta = 0.15,gamma = F)
hw_ab
hwab_pred<-data.frame(predict(hw_ab,n.ahead = 12))

# by looking at the plot the forecasted values are still missing some characters exhibited by train data
plot(forecast(hw_ab,h=12))
hwab_mape<-MAPE(hwab_pred$fit,test)*100
#11.21

# with alpha = 0.2, beta = 0.15, gamma = 0.05   # wintorsmodel
# Assuming time series data has level,trend and seasonality 
hw_abg<-HoltWinters(train,alpha = 0.2,beta = 0.15,gamma = 0.05)
hw_abg
hwabg_pred<-data.frame(predict(hw_abg,n.ahead = 12))
# by looking at the plot the characters of forecasted values are closely following historical data
plot(forecast(hw_abg,h=12))
hwabg_mape<-MAPE(hwabg_pred$fit,test)*100
#7.25

# With out optimum values 
hw_na<-HoltWinters(train,beta = F,gamma = F)
hw_na
hwna_pred<-data.frame(predict(hw_na,n.ahead = 12))
hwna_pred
plot(forecast(hw_na,h=12))
hwna_mape<-MAPE(hwna_pred$fit,test)*100
#18.55

hw_nab<-HoltWinters(train,gamma=F)
hw_nab
hwnab_pred<-data.frame(predict(hw_nab,n.ahead=12))
hwnab_pred
plot(forecast(hw_nab,h=12))
hwnab_mape<-MAPE(hwnab_pred$fit,test)*100

#13.10

hw_nabg<-HoltWinters(train)
hw_nabg
hwnabg_pred<-data.frame(predict(hw_nabg,n.ahead =12))
hwnabg_pred
plot(forecast(hw_nabg,h=12))
hwnabg_mape<-MAPE(hwnabg_pred$fit,test)*100
#1.73
#here the aggriagate errors is only 1.73 so accuracy is huge model is good
############################## STOP HERE ###############################

df_mape<-data.frame(c("hwa_mape","hwab_mape","hwabg_mape","hwna_mape","hwnab_mape","hwnabg_mape"),c(hwa_mape,hwab_mape,hwabg_mape,hwna_mape,hwnab_mape,hwnabg_mape))

colnames(df_mape)<-c("MAPE","VALUES")
View(df_mape)

# Based on the MAPE value who choose holts winter exponential tecnique which assumes the time series
# Data level, trend, seasonality characters with default values of alpha, beta and gamma

new_model <- HoltWinters(tspassanger)
new_model

plot(forecast(new_model,n.ahead=12))

# Forecasted values for the next 12 months 
forecast_new <- data.frame(predict(new_model,n.ahead=12))
View(forecast_new)
#here the next 12 months  airlines passanger data has predicted.

######################## LINEAR MODEL #############################
linear_model<-lm(Airlines~.,data = train)

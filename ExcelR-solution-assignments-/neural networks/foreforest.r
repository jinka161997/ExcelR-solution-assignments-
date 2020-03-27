install.packages("neuralnet")
library(neuralnet)  # regression

install.packages("nnet")
library(nnet) # classification 

fireforests<-read.csv(file.choose())
str(fireforests)

# custom normalization function
normalize <- function(x) { 
  return((x - min(x)) / (max(x) - min(x)))
}

# apply normalization to entire data frame
fireforests_norm<- as.data.frame(lapply(fireforests, normalize))

# create training and test data
fireforest_train <- fireforests_norm[1:363, ]
fireforest_test<- fireforests_norm[364:517, ]

## Training a model on the data ----
# train the neuralnet model
library(neuralnet)

# simple ANN with only a single hidden neuron
fireforest_model <- neuralnet(formula = area ~., 
                            data = fireforest_train)


# visualize the network topology
plot(firedorest_model)
fireforest_model$net.result
## Evaluating model performance 

----
  # obtain model results
  results = c()
results_model <- compute(fireforest_model, fireforest_test)
# obtain predicted strength values
str(results_model)
predicted_strength <- results_model$net.result

# examine the correlation between predicted and actual values
cor(predicted_area, firedorest_model$area)

## Improving model performance ----
# a more complex neural network topology with 5 hidden neurons
fireforests_model2 <- neuralnet(area ~.,
                             data = concrete_train, hidden = 10)


# plot the network
plot(fireforests_model2)

# evaluate the results as we did before
model_results2 <- compute(fireforests_model2, fireforests_test[1:8])
predicted_strength2 <- model_results2$net.result
cor(predicted_area2, fireforest_test$area)


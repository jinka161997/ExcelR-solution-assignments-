

install.packages("neuralnet")
library(neuralnet)  # regression

install.packages("nnet")
library(nnet) # classification 

# Load the 50_startups data as concrete
startups<-read.csv(file.choose())

# custom normalization function
normalize <- function(x) { 
  return((x - min(x)) / (max(x) - min(x)))
}

# apply normalization to entire data frame
startups_norm <- as.data.frame(lapply(startups, normalize))

# create training and test data
startup_train <- startups_norm[1:40, ]
concrete_test <- concrete_norm[41:50, ]

## Training a model on the data ----
# train the neuralnet model
library(neuralnet)

# simple ANN with only a single hidden neuron
concrete_model <- neuralnet(formula = strength ~ cement + slag +
                              ash + water + superplastic + 
                              coarseagg + fineagg + age,
                            data = concrete_train)


# visualize the network topology
plot(concrete_model)
concrete_model$net.result
## Evaluating model performance 

----
  # obtain model results
  results = c()
results_model <- compute(concrete_model, concrete_test)
# obtain predicted strength values
str(results_model)
predicted_strength <- results_model$net.result

# examine the correlation between predicted and actual values
cor(predicted_strength, concrete_test$strength)

## Improving model performance ----
# a more complex neural network topology with 5 hidden neurons
concrete_model2 <- neuralnet(strength ~ cement + slag +
                               ash + water + superplastic + 
                               coarseagg + fineagg + age,
                             data = concrete_train, hidden = 10)


# plot the network
plot(concrete_model2)

# evaluate the results as we did before
model_results2 <- compute(concrete_model2, concrete_test[1:8])
predicted_strength2 <- model_results2$net.result
cor(predicted_strength2, concrete_test$strength)

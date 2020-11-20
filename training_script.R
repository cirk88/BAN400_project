library(tidyverse)

registerDoSEQ()

# Select all variable we are using in our models

model_train <- train %>% 
  select(Fake,w_count.txt,punct_count.txt,exclamation_count.txt,w_count.title,punct_count.title, exclamation_count.title) %>% 
  mutate(Fake = as.factor(Fake))

model_test <- test %>% 
  select(Fake,w_count.txt,punct_count.txt,exclamation_count.txt,w_count.title,punct_count.title, exclamation_count.title) %>% 
  mutate(Fake = as.factor(Fake))


library(caret)

# logistic reg

set.seed(55)

glm_mod <- train(
  form = Fake ~ .,
  data = model_train,
  trControl = trainControl(method = "cv", number = 5),
  method = "glm",
  family = "binomial"
)

summary(glm_mod)


# Variable importance plot

imp_lr <- varImp(glm_mod, scale = FALSE)

plot(imp_lr)


# XGB

# Set up tuning parameters
xgb_grid <- expand.grid(nrounds = 2,
                        max_depth = c(6,7,8,10),
                        eta = c(0.1,0.2),
                        gamma = c(0,0.1),
                        colsample_bytree = 1,
                        min_child_weight = 1,
                        subsample = 1
)
set.seed(55)

# Train model

xgb_mod <- train(
  form = Fake ~.,
  data = model_train,
  trControl = trainControl(method = "cv", number = 5),
  method = "xgbTree",
  tuneGrid = xgb_grid,
  verbose = FALSE
)

# KNN

set.seed(55)

knn_mod <- train(
  form = Fake ~.,
  data = model_train,
  method = "knn",
  trControl = trainControl(method = "cv", number = 5),
  tuneGrid = expand.grid(k = seq(1,101, by = 2))
)

# GBM

gbm_grid = expand.grid(interaction.depth = c(2, 3, 4),
                       n.trees = c(200,400,600),
                       shrinkage = c(0.1, 0,2, 0.3),
                       n.minobsinnode = 15)

set.seed(55)

gbm_mod = train(
  form = Fake ~ .,
  data = model_train,
  trControl = trainControl(method = "cv", number = 5),
  method = "gbm",
  tuneGrid = gbm_grid, 
  verbose = FALSE
)



# Making nice table to print

models <- list(glm_mod,gbm_mod,knn_mod,xgb_mod) # Making a list of all models

# Make function

summary_table <- function(models,testdata, var_of_interest){
  
  # making empty matrix to fill values  
  
  sum_tab <- matrix(0,length(models),5)  
  
  colnames(sum_tab) <- c("Methods", "Accuracy", "Kappa", "Sensitivity", "Specificity") 
  
  # Loop over all models
  
  for(i in 1:length(models)){  
    
    # Predict and make a confusion matrix 
    
    pred <- predict(models[[i]], testdata)
    
    cm <- confusionMatrix(pred, var_of_interest)
    
    # make a nice data table of the result
    
    sum_tab[i,1]<- models[[i]]$method
    sum_tab[i,2]<- cm$overall[1]
    sum_tab[i,3]<- cm$overall[2]
    sum_tab[i,4]<- cm$byClass[1]
    sum_tab[i,5]<- cm$byClass[2]
    
  }
  
  sum_tab
  
}

sum_table <- summary_table(models, model_test, model_test$Fake)

kableExtra::kable(sum_table)


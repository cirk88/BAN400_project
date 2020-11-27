library(tidyverse)

registerDoSEQ()

# Select all variable we are using in our models

model_train <- train %>% 
  mutate(ppw_txt = punct_count.txt/w_count.txt,
         epw_txt = exclamation_count.txt/w_count.txt,
         ppw_title = punct_count.title/w_count.title,
         epw_title = exclamation_count.title/w_count.title,
         Fake = as.factor(Fake)) %>% 
  select(Fake,w_count.txt,punct_count.txt,exclamation_count.txt,w_count.title,punct_count.title, exclamation_count.title,
         ppw_txt, epw_txt, ppw_title, epw_title) 

model_test <- test %>%
  mutate(ppw_txt = punct_count.txt/w_count.txt,
         epw_txt = exclamation_count.txt/w_count.txt,
         ppw_title = punct_count.title/w_count.title,
         epw_title = exclamation_count.title/w_count.title,
         Fake = as.factor(Fake)) %>% 
  select(Fake,w_count.txt,punct_count.txt,exclamation_count.txt,w_count.title,punct_count.title, exclamation_count.title,
         ppw_txt, epw_txt, ppw_title, epw_title) 

model_train %>% 
  select(w_count.txt, w_count.title) %>% 
  summary()

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

model_train %>% 
  filter(w_count.title == 0)

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

save(readRDS("models.rds")[[3]], file = ""
     
     
     
     
     titledata = "Donald Trump Sends Out Embarrassing New Years Eve Message; This is Disturbing"
     
     textdata = "Donald Trump just couldn't wish all Americans a Happy New Year and leave it at that. Instead, 
he had to give a shout out to his enemies, haters and  the very dishonest fake news media.  The former reality show star had just one job to do and he couldn t do it. 
As our Country rapidly grows stronger and smarter, I want to wish all of my friends, supporters, enemies, haters, and even the very dishonest Fake News Media, a Happy and Healthy New Year,  
President Angry Pants tweeted.  2018 will be a great year for America! As our Country rapidly grows stronger and smarter, I want to wish all of my friends, supporters, enemies, haters, 
and even the very dishonest Fake News Media, a Happy and Healthy New Year. 2018 will be a great year for America!  Donald J. 
Trump (@realDonaldTrump) December 31, 2017Trump s tweet went down about as welll as you d expect.What kind of president sends a New Year s greeting like this despicable, 
petty, infantile gibberish? Only Trump! His lack of decency won t even allow him to rise above the gutter long enough to wish the American citizens a happy new year!  
Bishop Talbert Swan (@TalbertSwan) December 31, 2017no one likes you  Calvin (@calvinstowell) December 31, 2017Your impeachment would make 2018 a great year for America, 
but I ll also accept regaining control of Congress.  Miranda Yaver (@mirandayaver) December 31, 2017Do you hear yourself talk? When you have to include that many people that 
hate you you have to wonder? Why do the they all hate me?  Alan Sandoval (@AlanSandoval13) December 31, 2017Who uses the word Haters in a New Years wish??  Marlene (@marlene399) December 31, 
2017You can t just say happy new year?  Koren pollitt (@Korencarpenter) December 31, 2017Here s Trump s New Year s Eve tweet from 2016.Happy New Year to all, 
including to my many enemies and those who have fought me and lost so badly they just don t know what to do. Love!  Donald J. Trump (@realDonaldTrump) December 31, 2016This is nothing new for Trump. 
He s been doing this for years.Trump has directed messages to his  enemies  and  haters  for New Year s, Easter, Thanksgiving, and the anniversary of 9/11. pic.twitter.com/4FPAe2KypA  
Daniel Dale (@ddale8) December 31, 2017Trump s holiday tweets are clearly not presidential.How long did he work at Hallmark before becoming President?  
Steven Goodine (@SGoodine) December 31, 2017He s always been like this . . . the only difference is that in the last few years, his filter has been breaking down.  
Roy Schulze (@thbthttt) December 31, 2017Who, apart from a teenager uses the term haters?  Wendy (@WendyWhistles) December 31, 2017he s a fucking 5 year old  Who Knows (@rainyday80) December 31, 2017
So, to all the people who voted for this a hole thinking he would change once he got into power, you were wrong! 70-year-old men don t change and now he s a year older.
Photo by Andrew Burton/Getty Images." 
     
     
     FAKEpred(model = model, titledata, textdata)

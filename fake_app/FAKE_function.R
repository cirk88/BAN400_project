
FAKEpred <- function(model, titledata, textdata){
  
  library(tidyverse)
  library(tidytext)
  require(sentimentr)
  library(SentimentAnalysis)
  library(lexicon)
  require(tokenizers)
  library(tm)
  library(parallel)
  library(caret)
  library(xgboost)

data <- cbind(titledata, textdata) %>% 
  as.data.frame()

colnames(data) <- c("title","text")

#### Making variables


data <- data %>% 
  mutate(w_count.txt = str_count(paste(data$text), " "),
         punct_count.txt = str_count(paste(data$text), "[[:punct:]]"),
         upper_count.txt = str_count(paste(data$text), "[[:upper:]]"),
         exclamation_count.txt = str_count(paste(data$text), "!"), 
         w_count.title = str_count(paste(data$title), " "),
         punct_count.title = str_count(paste(data$title), "[[:punct:]]"),
         upper_count.title = str_count(paste(data$text), "[[:upper:]]"),
         exclamation_count.title = str_count(paste(data$title), "!"))


# Now we do some prepossessing of the data

data <-  data %>%
  filter( w_count.title > 0 ) %>%
  filter( w_count.txt > 30 ) %>% 
  mutate(text = text %>% tolower() %>%
           gsub("[^[:alpha:]]", " ", .) %>%
           #this removes any character that's not alphabetic. Those usually not carry any meaning. We may want to analyse them individually.
           gsub('\\b\\w{1,2}\\s|\\b\\w{21,}\\s','', .) %>%
           #removing words that are too small (from 1 or 2 letters and huge words, 21+ letters)
           removeWords(., c(stopwords(kind = "en"))),
         # removing stopwords, which are words that are most common in the English language, yet carry no meaning. These are found inside the stopwords dictionary int he tm package
         title = title %>% tolower() %>% 
           gsub("[^[:alpha:]]", " ", .) %>% 
           gsub('\\b\\w{1,2}\\s|\\b\\w{21,}\\s','', .) %>% 
           removeWords(., c(stopwords(kind = "en"))))

# Tokenizing

data <-  data %>% 
  mutate(bigram_text = tokenize_ngrams(text , n = 2, ngram_delim = "_"),
         bigram_title = tokenize_ngrams(title , n = 2, ngram_delim = "_"),
         token_text = tokenize_ngrams(text , n = 1, ngram_delim = ""),
         token_title = tokenize_ngrams(title , n = 1, ngram_delim = ""))

#Sentiment Analysis




cl <- parallel::makeCluster(2)

sentiment.fun  <- function(x){
  dictionary <- lexicon::hash_sentiment_sentiword
  out <- sentimentr::sentiment_by(sentimentr::sentiment(unlist(strsplit(x, split = " "))  ,polarity_dt = dictionary))
  
  out2 <- sum(out$ave_sentiment)/sum(out$word_count)
  return(out2)
}

# Parallel processing to make it go quicker

data$sentiment <-as.vector(unlist(parallel::parLapply(cl, data$token_text, sentiment.fun)))

data <- data %>%
  na.omit(data$sentiment)

#Searching for certain keywords

#Politicians relevant at the time

politicians <- "(barack_obama)|(bernie_sanders)|(donald_trump)|(hillary_clinton)|(joe_biden)"  	

# Creating a politician per word metric, using the bigrams

data$politician.pw <- str_count(string = paste(data$bigram_text),
                                pattern = politicians)/data$w_count.txt

#Media related bigrams

media <- "(twitter_com)|(pic_twitter)|(getty_images)|(fox_news)|(social_media)|(fake_news)|(york_times)|(washington_post)|(mainstream_media)|(via_youtube)|(via_getty)|(via_video)|(facebook_page)|(youtube_com)|(abc_news)"

# Creating a politician per word metric, using the bigrams

data$media.pw <-
  str_count(string = paste(data$bigram_text),
            pattern = media)/data$w_count.txt



pred <- predict(model, data, type = "prob")

paste(round(pred[,"1"] * 100,2),"%", "possibility that the writing of interest is FAKE news!")

}



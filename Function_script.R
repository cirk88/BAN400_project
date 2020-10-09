#setting the working directory to the project file ----

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Loading packages----

library(tidyverse)

# Codes attempting to load in the data ----

# df_fake <- read_csv(unzip("Fake.zip", "Fake.csv"))
# df_true <- read_csv(unzip("True.zip", "True.csv"))

# df_fake <- saveRDS(df_fake, "Fake.rds")
# df_true <- saveRDS(df_true, "True.rds")




# Loading in the data, binding them together and removing the unbinded to keep environment clean----

df_fake <- readRDS("Fake.rds") %>%
  mutate(Fake = 1)


df_true <- readRDS("True.rds") %>% 
  mutate(Fake = 0)


DF <- rbind(df_fake, df_true)

rm(df_true, df_fake)

# Separating the data into test and training ----


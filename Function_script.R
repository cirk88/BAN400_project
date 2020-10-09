# Loading packages----

library(tidyverse)

# Codes attempting to load in the data ----

# df_fake <- read_csv(unzip("Fake.zip", "Fake.csv"))
# df_true <- read_csv(unzip("True.zip", "True.csv"))

# df_fake <- saveRDS(df_fake, "Fake.rds")
# df_true <- saveRDS(df_true, "True.rds")




# Loading in the data, and binding them together ----

df_fake <- readRDS("Fake.rds") %>%
  mutate(Fake = 1)


df_true <- readRDS("True.rds") %>% 
  mutate(Fake = 0)



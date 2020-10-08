# Loading packages

library(tidyverse)

# Loading data

# df_fake <- read_csv(unzip("Fake.zip", "Fake.csv"))
# df_true <- read_csv(unzip("True.zip", "True.csv"))

# df_fake <- saveRDS(df_fake, "Fake.rds")
# df_true <- saveRDS(df_true, "True.rds")

df_fake <- readRDS("Fake.rds")
df_true <- readRDS("True.rds")



library(xgboost)

source("CryptoLaunchApp/scripts/GatheringData.R")

for(i in 1:24){
  Clean.Data(i)
  
  #########################################
  ######################################### BUILD TRAINING DATASET AND BOOSTED MODEL
  train = df.first.hr %>%
    select("Open","norm_vol")
  train = as.matrix(train)
  
  outcome.train = df.first.hr$Open
  
  set.seed(123)
  bst.open = xgboost(data = train,
                     label = outcome.train,
                     objective = "reg:linear",
                     max.depth = 20,
                     nrounds = 200,
                     verbose = FALSE)
  saveRDS(bst.open, file = paste0("CryptoLaunchApp/bsts/bst.open_",i))
  
  
  #########################################
  ######################################### CREATE MODEL FOR HIGH PRICE
  
  outcome.train = df.first.hr$High
  
  set.seed(123)
  bst.high = xgboost(data = train,
                     label = outcome.train,
                     objective = "reg:linear",
                     max.depth = 20,
                     nrounds = 200,
                     verbose = FALSE)
  saveRDS(bst.high, file = paste0("CryptoLaunchApp/bsts/bst.high_",i))
  
  
  #########################################
  ######################################### CREATE MODEL FOR LOW PRICE
  
  outcome.train = df.first.hr$Low
  
  set.seed(123)
  bst.low = xgboost(data = train,
                    label = outcome.train,
                    objective = "reg:linear",
                    max.depth = 20,
                    nrounds = 200,
                    verbose = FALSE)
  saveRDS(bst.low, file = paste0("CryptoLaunchApp/bsts/bst.low_",i))
  
  
  
  #########################################
  ######################################### CREATE MODEL FOR CLOSE PRICE
  
  outcome.train = df.first.hr$Close
  
  set.seed(123)
  bst.close = xgboost(data = train,
                      label = outcome.train,
                      objective = "reg:linear",
                      max.depth = 20,
                      nrounds = 200,
                      verbose = FALSE)
  saveRDS(bst.close, file = paste0("CryptoLaunchApp/bsts/bst.close_",i))
  
  
}
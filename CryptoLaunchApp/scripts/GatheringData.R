library(stringr)
library(caret)
library(dplyr)
  
#########################################
######################################### DATA WAS GATHERED FROM THE NEW LISTINGS MEXC TAB


#########################################
######################################### NOW LETS READ IN AND FORMAT THE DATA
ls.files = list.files(path = "CryptoLaunchApp/NewCoins")
coin.names = unique(str_match(string = ls.files, pattern = "(.*)_")[,2])

df.all.coins = data.frame(Coin = character(),
                          Open = numeric(),
                          High = numeric(),
                          Low = numeric(),
                          Close = numeric(),
                          Volume = numeric())
for(i in 1:length(coin.names)){
  current.coin = coin.names[i]
  current.coin.files = ls.files[grep(pattern = current.coin, x=ls.files)]
  
  df1 = read.csv(paste0("CryptoLaunchApp/NewCoins/",current.coin.files[1]),
                header = FALSE,
                col.names = c('Coin','Timeframe','Open.Time','Open','High','Low','Close','Volume','Quote.Asset.Volume','Close.Time')) %>%
    select("Coin","Open","High","Low","Close","Volume")
  df2 = read.csv(paste0("CryptoLaunchApp/NewCoins/",current.coin.files[2]),
                  header = FALSE,
                  col.names = c('Coin','Timeframe','Open.Time','Open','High','Low','Close','Volume','Quote.Asset.Volume','Close.Time'))%>%
    select("Coin","Open","High","Low","Close","Volume")
  df = rbind(df1,df2)
  first.24hr = df[1:24,]
  first.24hr$Volume = first.24hr$Volume[1]
  first.24hr$HCRatio = first.24hr$High[1] / first.24hr$Close[1]
  first.24hr$Scaled.Volume = first.24hr$Volume[1] * first.24hr$Open[1]
  
  df.all.coins = rbind(df.all.coins, first.24hr)
  print(i)
}

#########################################
######################################### NORMALIZE OUR VOLUME DATA

process = preProcess(as.data.frame(df.all.coins$Scaled.Volume), method = "range")
norm_vol = predict(process,as.data.frame(df.all.coins$Scaled.Volume))
df.all.coins$norm_vol = norm_vol

#########################################
######################################### NORMALIZE RATIO OF HIGH/CLOSE

process = preProcess(as.data.frame(df.all.coins$HCRatio), method = "range")
norm_ratio = predict(process,as.data.frame(df.all.coins$HCRatio))
df.all.coins$norm_ratio = norm_ratio

Clean.Data <- function(hour){
  #########################################
  ######################################### CREATE DATA.FRAME OF FIRST HOUR FOR ALL COINS
  ind = seq(from = hour, to = nrow(df.all.coins), by = 24)
  df.first.hr = df.all.coins[ind,]
  
  
  
  #########################################
  ######################################### PERCENT CHANGE
  df.first.hr$Percent.Increase.Decrease = round((df.first.hr$Close / df.first.hr$Open-1) * 100, digits = 0)
  assign('df.first.hr',df.first.hr,.GlobalEnv)
  
  
}





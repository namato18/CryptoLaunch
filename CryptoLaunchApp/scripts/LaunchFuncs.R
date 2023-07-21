library(plotly)

predict.24 <- function(open, popularity, percentage){
  
  df.predict.24 = data.frame(Open = rep(open,24),
                             High = rep(NA,24),
                             Low = rep(NA,24),
                             Close = rep(NA,24))
  for(j in 1:24){
    bst.close = readRDS(file = paste0("bsts/bst.close_",j))
    bst.high = readRDS(file = paste0("bsts/bst.high_",j))
    bst.low = readRDS(file = paste0("bsts/bst.low_",j))
    
    test = data.frame(Open = df.predict.24$Open[j],
                      norm_vol = popularity)
    test = as.matrix(test)
    
    pred.high = predict(bst.high, test)
    pred.low = predict(bst.low, test)
    pred.close = predict(bst.close, test)
    
    if(j == 1){
      if(percentage <= 50){
        # going to be green, need percentage of high to open
        high.open = pred.high - open
        pred.close = (high.open * ((100-(percentage * 2)) / 100)) + open
      }else{
        pred.close = open * (1-(((percentage - 50)*2) / 100))

      }
    }
    
    if(pred.high <= df.predict.24$Open[j]){
      pred.high = df.predict.24$Open[j]
    }
    if(pred.high <= pred.close){
      pred.high = pred.close
    }
    if(pred.low >= df.predict.24$Open[j]){
      pred.low = df.predict.24$Open[j]
    }
    if(pred.low >= pred.close){
      pred.low = pred.close
    }

    
    df.predict.24$High[j] = pred.high
    df.predict.24$Low[j] = pred.low
    df.predict.24$Close[j] = pred.close
    
    
    if(j != 24){
      df.predict.24$Open[j+1] = pred.close
    }
  }
  
  df.predict.24 = round(df.predict.24, digits = 6)
  df.predict.24$Date = seq(ISOdate(2020,12,1,0, tz = 'UTC'), by = 'hour', length.out = 24)
  df.predict.24$Date = c(1:24)
  assign('df.predict.24',df.predict.24,.GlobalEnv)
  
  fig <- df.predict.24 %>% plot_ly(x = ~Date, type="candlestick",
                                   open = ~Open, close = ~Close,
                                   high = ~High, low = ~Low) 
  fig <- fig %>% 
    layout(title = list(text="Predicted Candlestick Chart", font=list(color="white")),
           xaxis = list(rangeslider = list(visible = F), title = list(text="Hour",font=list(color='white')),color="white"),
           yaxis = list(title = list(text="Price",font = list(color='white')),color = "white")) %>%
    layout(plot_bgcolor="rgba(0,0,0,0)", paper_bgcolor = "rgba(0,0,0,0)")
  
  assign("candlestick",fig,.GlobalEnv)
}







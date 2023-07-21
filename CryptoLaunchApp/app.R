library(shiny)
library(shinydashboard)
library(dashboardthemes)
library(shinyWidgets)
library(plotly)
library(DT)
library(stringr)
library(shinycssloaders)
library(shinythemes)

## Valid colors are: red, yellow, aqua, blue, light-blue, green, navy, teal, olive, lime, orange, fuchsia, purple, maroon, black.

ls.files = list.files(path = "NewCoins")
coin.names = unique(str_match(string = ls.files, pattern = "(.*)_")[,2])

coins.used = data.frame("Coins.Used" = coin.names)

# Define UI
ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(title = shinyDashboardLogo(
    theme = "poor_mans_flatly",
    boldText = "Crypto Launch Predictor",
    badgeText = "v1.0"
  ),
  titleWidth = 300),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Candlestic Predictions", tabName = 'candlestickPredictions', icon = icon("house")),
      menuItem("Info", tabName = "info", icon = icon("circle-info"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem("candlestickPredictions",
              fluidPage(
                theme = shinytheme("cyborg"),
                setBackgroundImage(
                  # color = "black",
                  src = "tower.jpg",
                  shinydashboard = TRUE
                ),
                box(title = "Inputs", status = 'primary', width = 6, solidHeader = TRUE,background = "black",
                    sliderInput("popularity","Select Pre-Launch Popularity (0-1)", min = 0, max = 1, step = 0.1, value = 0.3),
                    sliderInput("selloff","Select Anticipated Sell Off in First Hour (percentage of holders)", min = 1, max = 100, step = 1, value = 30),

                    numericInput('startingPrice', "Input Anticipated Launch Price", min = 0, max = 1000, value = 0.2, step = 0.0000001)
                ),
                box(title = "Selected Values for Model", width = 6, status = 'primary', solidHeader = TRUE, background = "black",
                    valueBoxOutput(outputId = "selectedPopularity", width = 4),
                    valueBoxOutput(outputId = "selectedStartingPrice", width = 4),
                    valueBoxOutput(outputId = "selectedAnticipatedSellOff", width = 4)
                ),
                br(),
                actionBttn('plot','Plot Candlestick Prediction', icon = icon('chart-line'), style = "jelly", color = "success", block = TRUE),
                br(),
                box(title = "Candlestick Chart", width = 6, status = 'primary', solidHeader = TRUE, background = "black",
                    withSpinner(plotlyOutput('candlestickPlot'))
                ),
                br(),
                box(title = "Candlestick Chart Values", width = 6, status = 'primary', solidHeader = TRUE, background = "black",
                    withSpinner(DT::dataTableOutput('tableOutput'))
                ),
              )
              
      ),
      
      tabItem("info",
              box(title = "Additional Information", width = 6, status = 'primary', solidHeader = TRUE, background = "black",
                  strong("How Many?"),
                  br(),
                  "- Three predictive models are genereated for this application. One model each for predicting High, Low and Close values. 
                The open price is simply the Close price of the previous candle.",
                  br(),
                  strong("What Method?"),
                  br(),
                  "- A method known as extreme gradient booting (or xgboost) was used to create these models. A simplified way of thinking about xgboost is
                to think of it as a whole bunch of decision trees that learn from past mistakes.",
                  br(),
                  strong("How Many?"),
                  br(),
                  "- 95 Coins were used in the generation of these models. More new coin data may further improve the model, but new coins often only rely heavily on the popularity of the coin,
                so more 'new coin' data may not be necessary.",
                  br(),
                  strong("Twitter Data"),
                  br(),
                  "- A strong indicator of how popular a particular coin is would be how many tweets there are with a hashtag of the coin.
                Twitter API is no longer free for this type of webscraping, therefore was skipped in this analysis."
              ),
              box(title = "Coins Used", width = 6, status = 'primary', solidHeader = TRUE, background = "black",
                  DT::dataTableOutput("coinsUsed")
              )
      )
    )
  )
  
  
)

# Define server logic
server <- function(input, output) {
  source("scripts/LaunchFuncs.R")
  output$candlestickPlot = renderPlotly(NULL)
  output$tableOutput = DT::renderDataTable(NULL)
  
  output$selectedPopularity = renderValueBox({
    valueBox(value = paste0(input$popularity), subtitle = "Popularity", icon = icon('fire'), color = 'red')
  })
  
  output$selectedStartingPrice = renderValueBox({
    valueBox(value = paste0(input$startingPrice), subtitle = "Starting Price", icon = icon('money-bill'), color = 'green')
  })
  output$selectedAnticipatedSellOff = renderValueBox({
    valueBox(value = paste0(input$selloff,"%"), subtitle = "Anitcipated Sell Off", icon = icon('sack-dollar'), color = 'orange')
  })
  
  output$coinsUsed = DT::renderDataTable(DT::datatable(coins.used))
  
  # if(!exists("candlestick")){
  #   output$candlestickPlot = NULL
  #   output$tableOutput = NULL
  # }
  
  observeEvent(input$plot, {
    predict.24(input$startingPrice, input$popularity, input$selloff)
    output$candlestickPlot = renderPlotly(candlestick)
    output$tableOutput = DT::renderDataTable(DT::datatable(df.predict.24, style = "auto"))
    
  })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

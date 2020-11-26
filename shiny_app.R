# Shiney app

model <- readRDS("models.rds")[[3]]

source("FAKE_function.R")

library(shiny)
library(shinythemes)
library(tm)

ui <- fluidPage(
  
  theme = shinytheme("cerulean"),
  
  titlePanel(
    h1("Predict FAKE news!", 
       align = "center",  
       style = "color:#3474A7")),
  sidebarLayout(
      sidebarPanel(
    p("Made with", a("Shiny",
     href = "http://shiny.rstudio.com"
    ), "."),
    img(
      src = "pic1.png",
      width = "70px", height = "70px"
    ), width = 3
  ),
    
mainPanel(br(), 
          "Find your article online and predict the possibility of fake news.", br(), 
          "However, the results is based on machine learning tecniques,", br(),
          "so it might deviate from the reality.", br(), 
          br(),
          "Happy exploring!", width = 6)),
  
h3("Title input"),

textInput(inputId = "title", 
          label = h5("Copy/paste the title below"),
          width = "800px"),

h3("Text input"),
withTags(
  div(
    h5("Copy/paste the text below"), 
    textarea(id = "text", 
             class = "form-control shiny-bound-input",
             style = "width: 800px; height: 500px"))),
br(),

h5("Press to predict"),

sidebarLayout(
  sidebarPanel(
    
actionButton(inputId = "predict",
             label = "Predict"),
width = 3),

mainPanel(tableOutput("predictionResults")))
)

server<-function(input, output, session) {
  
  observeEvent(input$predict, { # tracks if the action button have been pressed
    
    titledata <- reactive({
      validate(
        need(input$title != "", "Please input the title")
      )
      input$title
    })
    
    textdata <- reactive({
      validate(
        need(input$text != "", "Please input the text")
      )
      input$text
    })
    
    output$predictionResults <- renderTable({
      pred <- isolate( # Make it run each time action button is pressed
        FAKEpred(model, # Use made function to predict if it fake or true news
               titledata(),
               textdata())) 
    
    pred})
  })
}
  

shinyApp(ui = ui, server = server)

library(rsconnect)
rsconnect::deployApp('C:/Users/chris/OneDrive/Documents/BAN400/BAN400_project')

rsconnect::setAccountInfo(name='cirk88', token='4498992C0FFC54254E0E59498F8A5A2F', secret='GJ7/D0AOaA2LDHd0eq9ZtIwl6ChKEIcP3OhW2Iim')

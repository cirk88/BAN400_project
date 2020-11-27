

model <- readRDS("models.rds")[[1]] # Retrive the model

source("FAKE_function.R") # retrive function

library(shiny)
library(shinythemes)
library(tm)

function(input, output, session) {
  
  observeEvent(input$predict, { # tracks if the action button have been pressed
    
    titledata <- reactive({
      validate(
        need(input$title != "", "Please input the title")  # Give notification to copypaste title
      )
      input$title
    })
    
    textdata <- reactive({
      validate(
        need(input$text != "", "Please input the text") # Give notification to copypaste text
      )
      input$text
    })
    
    output$predictionResults <- renderTable({
      pred <- isolate( # Make it run only when action button is pressed
        FAKEpred(model, # Use made function to predict if it fake or true news
                 titledata(),
                 textdata())) 
      
      pred}, colnames = FALSE)
    
  })
}

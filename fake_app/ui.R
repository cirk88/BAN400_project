library(shiny)
library(shinythemes)
library(shinyWidgets)


fluidPage(
  
  theme = shinytheme("cerulean"), # Change theme
  
  setBackgroundColor("whitesmoke"), # Change background color
  
  titlePanel( # Make title
    h1("Predict FAKE news!", 
       align = "center",  
       style = "color:#3474A7")),
  sidebarLayout(
    sidebarPanel(
      p("Made with", a("Shiny", # branding shiny
                       href = "http://shiny.rstudio.com"
      ), "."),
      img(
        src = "pic1.png",
        width = "70px", height = "70px"
      ), width = 3
    ),
    
    # Text description
    
    mainPanel(br(), 
              "Find an english article or news online and predict the possibility of fake news.", br(),
              "Furthermore, as the result is based on machine learning tecniques and trained by", br(),
              "using american data, it might deviate from the reality.", br(), 
              br(),
              "Happy exploring!", width = 6)),
  
  # Making title input
  
  h3("Title input"),
  
  textInput(inputId = "title", 
            label = h5("Copy/paste the title below"),
            width = "800px"),
  
  # Making text input
  
  h3("Text input"),
  withTags(
    div(
      h5("Copy/paste the text below"), 
      textarea(id = "text", 
               class = "form-control shiny-bound-input",
               style = "width: 800px; height: 500px"))),
  br(),
  
  # Making a action button
  
  h5("Press to predict"),
  
  sidebarLayout(
    sidebarPanel(
      
      actionButton(inputId = "predict",
                   label = "Predict"),
      width = 3),
    
    # Output table
    
    mainPanel(tableOutput("predictionResults")))
)
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
      ), img(
        src = "pic2.png",
        width = "200px", height = "70px"
      ), width = 4
    ),
    
    # Text description
    
    mainPanel(br(),
              "Paste the title and body of a news article you find online on the text box,",
              "and our algorithm will tell you if the article is true or FAKE news!",
              "The results are based on a machine learning model trained on American news articles.", 
              "The deciding factors of what could be considered fake or true news range from forms", 
              "of formatting, to specific keywords within the article. This means that the algorithm does not", 
              "validate the content of the article.", br(), 
              br(),
              "Note: The model need more than 30 words in the text to give a result!", br(),
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
      width = 4),
    
    # Output table
    
    mainPanel(tableOutput("predictionResults")))
)

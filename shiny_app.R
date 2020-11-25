# Shiney app

readRDS("models.rds")[[3]]

model <- readRDS("models.rds")[[2]]

source() # can iclude data manipulation and cleaninf

library(shiny)
library(shinythemes)


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
  
  titledata <- reactive({
    intitle <-input$title
    if (is.null(intitle)) {
      return(NULL)}
  })
  
  textdata <- reactive({
    intext <-input$text
    if (is.null(intext)) {
      return(NULL)}
  })
  
  cbind(titledata, textdata)
}

shinyApp(ui = ui, server = server)


titledata = "Donald Trump Sends Out Embarrassing New Years Eve Message; This is Disturbing" 

textdata = "Donald Trump just couldn't wish all Americans a Happy New Year and leave it at that. Instead, 
he had to give a shout out to his enemies, haters and  the very dishonest fake news media.  The former reality show star had just one job to do and he couldn t do it. 
As our Country rapidly grows stronger and smarter, I want to wish all of my friends, supporters, enemies, haters, and even the very dishonest Fake News Media, a Happy and Healthy New Year,  
President Angry Pants tweeted.  2018 will be a great year for America! As our Country rapidly grows stronger and smarter, I want to wish all of my friends, supporters, enemies, haters, 
and even the very dishonest Fake News Media, a Happy and Healthy New Year. 2018 will be a great year for America!  Donald J. 
Trump (@realDonaldTrump) December 31, 2017Trump s tweet went down about as welll as you d expect.What kind of president sends a New Year s greeting like this despicable, 
petty, infantile gibberish? Only Trump! His lack of decency won t even allow him to rise above the gutter long enough to wish the American citizens a happy new year!  
Bishop Talbert Swan (@TalbertSwan) December 31, 2017no one likes you  Calvin (@calvinstowell) December 31, 2017Your impeachment would make 2018 a great year for America, 
but I ll also accept regaining control of Congress.  Miranda Yaver (@mirandayaver) December 31, 2017Do you hear yourself talk? When you have to include that many people that 
hate you you have to wonder? Why do the they all hate me?  Alan Sandoval (@AlanSandoval13) December 31, 2017Who uses the word Haters in a New Years wish??  Marlene (@marlene399) December 31, 
2017You can t just say happy new year?  Koren pollitt (@Korencarpenter) December 31, 2017Here s Trump s New Year s Eve tweet from 2016.Happy New Year to all, 
including to my many enemies and those who have fought me and lost so badly they just don t know what to do. Love!  Donald J. Trump (@realDonaldTrump) December 31, 2016This is nothing new for Trump. 
He s been doing this for years.Trump has directed messages to his  enemies  and  haters  for New Year s, Easter, Thanksgiving, and the anniversary of 9/11. pic.twitter.com/4FPAe2KypA  
Daniel Dale (@ddale8) December 31, 2017Trump s holiday tweets are clearly not presidential.How long did he work at Hallmark before becoming President?  
Steven Goodine (@SGoodine) December 31, 2017He s always been like this . . . the only difference is that in the last few years, his filter has been breaking down.  
Roy Schulze (@thbthttt) December 31, 2017Who, apart from a teenager uses the term haters?  Wendy (@WendyWhistles) December 31, 2017he s a fucking 5 year old  Who Knows (@rainyday80) December 31, 2017
So, to all the people who voted for this a hole thinking he would change once he got into power, you were wrong! 70-year-old men don t change and now he s a year older.
Photo by Andrew Burton/Getty Images." 
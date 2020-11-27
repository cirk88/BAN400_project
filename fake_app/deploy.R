library(shiny)
runApp() # To check if it runs locally

library(rsconnect)
deployApp() # Deploy to shinyapps.io

rm(list = ls())

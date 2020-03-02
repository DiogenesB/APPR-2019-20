library(shiny)

shinyUI(fluidPage(
  checkboxGroupInput(inputId="tip", label="Izberite tip plačila"),
  plotOutput("zemljevid") ## TODO popravi razmerja zemljevida
))

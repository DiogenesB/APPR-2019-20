library(shiny)

shinyUI(fluidPage(
  checkboxGroupInput(inputId="tip", label="Izberite tip plačila", choiceNames=c("Boleto", "Kreditna kartica", "Debetna kartica", "Bon"), choiceValues=c("boleto", "credit_card", "debit_card", "voucher")),
  plotOutput("zemljevid") ## TODO popravi razmerja zemljevida
))

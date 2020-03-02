library(shiny)

shinyServer(function(input, output) {
  output$zemljevid <- renderPlot(map)
}
)
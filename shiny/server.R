library(shiny)
library(dplyr)

server <- function(input, output) {
    output$povprecje <- renderTable(
        izdelki %>%
            filter(kategorija.izdelka == input$kategorija) %>%
            select(masa.izdelka) %>%
            summarize(povprecje = mean(masa.izdelka), trajanje=linearna_regresija$coefficients %*% c(1, input$razdalja)) 
            )

}
        
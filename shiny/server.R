library(shiny)
library(dplyr)
source("analiza/analiza.r", encoding="UTF-8")


server <- function(input, output) {
        output$povprecje_izdelkov <- renderTable(izdelki %>%
            filter(kategorija.izdelka == input$kategorija) %>%
            select(masa.izdelka) %>%
            summarize("Povprečna masa (g)" = mean(masa.izdelka),"Trajanje (dnevi)" = linearna_regresija$coefficients %*% c(1, input$razdalja)))
        }

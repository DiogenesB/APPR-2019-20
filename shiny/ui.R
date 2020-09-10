library(shiny)

ui <- fluidPage(
  titlePanel("Pregled statističnih podatkov po kategorijah"),
  sidebarLayout(
    sidebarPanel(

      selectInput("kategorija", 
                  label = "Izberite kategorijo",
                  choices = izdelki$kategorija.izdelka,
                  selected = NULL),

      sliderInput("razdalja",
                  label = "Razdalja",
                  min = 0,
                  max = max(lokacija_narocil$razdalja),
                  value = 0)
    ),
  
    mainPanel(
      tableOutput("povprecje_izdelkov")
    )
  )
)

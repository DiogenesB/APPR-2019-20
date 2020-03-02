library(shiny)

shinyServer(function(input, output) {
  output$zemljevid <- renderPlot(
    ggplot(brazilija, aes(x=long, y=lat)) +
    geom_polygon(aes(group=group)) +
    geom_point(aes(x=zemljepisna.dolzina, y=zemljepisna.sirina, color=tip.placila), data = distinct(select(lokacija_kupcev, kljuc.uporabnika, zemljepisna.sirina, zemljepisna.dolzina, tip.placila), kljuc.uporabnika, .keep_all = TRUE)) + 
    geom_point(aes(x=zemljepisna.dolzina, y=zemljepisna.sirina), data = lokacija_prodajalcev, col="red", alpha = 0.05) +
    coord_cartesian(xlim = c(-73.98283055, -34.79314722), ylim = c(-33.75116944, 5.27438888)) +
    labs(title ="Vizualizacija prodajalcev in kupcev", x = "Zemljepisna dolžina", y = "Zemljepisna širina") 
  )
}
)
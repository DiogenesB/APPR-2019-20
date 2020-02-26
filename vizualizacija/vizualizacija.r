library(ggplot2)
library(ggvis)
library(dplyr)
library(rgdal)
library(mosaic)
library(maptools)
library(ggmap)
library(mapproj)
library(munsell)
library(maps)
library(rgeos)
source("lib/uvozi.zemljevid.r")

meseci <- c("Januar", "Februar", "Marec", "April", "Maj", "Junij", "Julij", "Avgust", "September", "Oktober", "November", "December")
graf_promet <- ggplot(promet_2017, aes(x = promet_2017$mesec.dostave, y = promet_2017$vrednost.placila / 1000)) + 
  geom_col() + 
  labs(title = "Pregled prometa v letu 2017", x = "Mesec", y = "Skupni promet (v 1000€)") +
  scale_x_continuous(breaks = 1:12, labels = meseci )

graf_tipi <- ggplot(narocila, aes(narocila$tip.placila)) + 
  geom_bar() +
  labs(title = "Plačilna sredstva", x = "Tip plačilnega sredstva", y = "Število nakupov") + 
  scale_x_discrete() + 
  coord_flip()

graf_gostot <- ggplot(narocila, aes(x = narocila$vrednost.placila, color=narocila$tip.placila)) +
  geom_density()  +
  scale_x_log10() +
  labs(title = "Gostota cen glede na plačilno sredstvo", x = "Gostota", y = "Vrednost plačila")

graf_december <- ggplot(december, aes(x=december$dan.narocila, y = december$vrednost.placila)) +
  geom_col() +
  labs(title = "Pregled prometa v decembru 2017", x = "Dan", y = "Skupni promet") +
  scale_x_continuous(breaks = 1:31)

graf_november <- ggplot(november, aes(x=november$dan.narocila, y=november$vrednost.placila)) +
  geom_col() +
  labs(title = "Pregled prometa v novembru 2017", x = "Dan", y = "Skupni promet") + 
  scale_x_continuous(breaks = 1:30)

brazilija <- uvozi.zemljevid("https://biogeo.ucdavis.edu/data/gadm3.6/shp/gadm36_BRA_shp.zip", "gadm36_BRA_0", force=FALSE) %>% fortify()


map <- ggplot(brazilija, aes(x=long, y=lat)) +
  geom_polygon(aes(group=group)) +
  geom_point(aes(x=zemljepisna.dolzina, y=zemljepisna.sirina), data = distinct(select(lokacija_kupcev, kljuc.uporabnika, zemljepisna.sirina, zemljepisna.dolzina), kljuc.uporabnika, .keep_all = TRUE), col="blue", alpha = 0.05) + 
  geom_point(aes(x=zemljepisna.dolzina, y=zemljepisna.sirina), data = lokacija_prodajalcev, col="red", alpha = 0.05) +
  labs(title ="Vizualizacija prodajalcev in kupcev", x = "Zemljepisna dolžina", y = "Zemljepisna širina") 
##TODO Obarvano glede na gostoto in glede na tip plačila po barvi
##TODO odpravi lokacije ki niso na zemljevidu
##TODO poglej GeoSpatial analizo te baze na Kaggle-u

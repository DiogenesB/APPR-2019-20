library(mclust)

#Pogledamo kako sta količini korelirani
cor_kolicin <- cor(lokacija_narocil$trajanje, lokacija_narocil$razdalja)

#Pogledamo gostoto obeh spremenljivk
gostota_trajanja <- ggplot(lokacija_narocil, aes(x=lokacija_narocil$trajanje)) +
  geom_density() +
  scale_x_log10() +
  labs(title = "Gostota porazdelitve trajanja", x="Trajanje (log10)", y="Gostota")

gostota_razdalja <- ggplot(lokacija_narocil, aes(x=lokacija_narocil$razdalja)) +
  geom_density() + 
  scale_x_log10() +
  labs(title = "Gostota porazdelitve razdalje", x="Razdalja (log10)", y="Gostota")


##Naredimo model linearne regresije in izpišemo glavne parametre
linearna_regresija <- lm(trajanje ~ razdalja, data=lokacija_narocil)
#print(linearna_regresija)
summary(linearna_regresija)

##Poglejmo še cluster analizo podatkov
#clustering <- lokacija_narocil %>%
#  na.omit() %>%
#  scale()

##Definiramo število oblakov
#fit <- Mclust(clustering)
#graf_fit <- plot(fit)
#povzetek_fit <- summary(fit)
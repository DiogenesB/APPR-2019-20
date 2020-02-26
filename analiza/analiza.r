### Grafična analiza

#Pogledamo v kakšnem odnosu sta količini
odnos_kolicin <- ggplot(lokacija_narocil, aes(x=lokacija_narocil$razdalja, y=lokacija_narocil$trajanje)) +
  geom_point()



#Pogledamo kako sta količini korelirani
cor_kolicin <- cor(lokacija_narocil$trajanje, lokacija_narocil$razdalja)

#Pogledamo gostoto obeh spremenljivk
gostota_trajanja <- ggplot(lokacija_narocil, aes(x=lokacija_narocil$trajanje)) +
  geom_density() +
  scale_x_log10() 
gostota_razdalja <- ggplot(lokacija_narocil, aes(x=lokacija_narocil$razdalja)) +
  geom_density() + 
  scale_x_log10()



linearna_regresija <- lm(trajanje ~ razdalja, data=lokacija_narocil)
print(linearna_regresija)
summary(linearna_regresija)

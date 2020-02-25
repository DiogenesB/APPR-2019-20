### Grafična analiza

#Ali se ena količina spremninja linearno na drugo koločino
scatter.smooth(x=lokacija.narocil$razdalja, y=lokacija.narocil$trajanje)


#Iščemo outlier-je
par(mfrow=c(1, 2))  # divide graph area in 2 columns
boxplot(lokacija_narocil$razdalja, main="Razdalja", sub=paste("Outlier rows: ", boxplot.stats(lokacija_narocil$razdalja)$out))  # box plot for 'speed'
boxplot(cars$dist, main="Distance", sub=paste("Outlier rows: ", boxplot.stats(lokacija_narocil$trajanje)$out))  # box plot for 'distance'


linearna_regresija <- lm(trajanje ~ razdalja, data=lokacija_narocil)
print(linearna_regresija)
summary(linearna_regresija)

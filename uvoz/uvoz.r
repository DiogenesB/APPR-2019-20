library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(lubridate)

#Uvoz prve tabele
stolpci_1 <- c("kljuc.narocila", "kljuc.uporabnika", "status.narocila", "cas.nakupa", 
               "odobren.cas.nakupa", "cas.ko.je.posiljko.prejel.partner", "dejanski.cas.dostave", "predviden.cas.dostave" )
tabela_narocil <- read_csv("podatki/olist_orders_dataset.csv", na = c("", " ", "NA")) %>% drop_na()
colnames(tabela_narocil) <- stolpci_1


#Uvoz druge tabele
stolpci_2 <- c("kljuc.narocila", "zaporedje.placila", "tip.placila", "stevilo.obrokov.placila", "vrednost.placila")
tabela_vrst_placil <- read_csv("podatki/olist_order_payments_dataset.csv")
colnames(tabela_vrst_placil) <- stolpci_2


#Uvoz tretje tabele
stolpci_3 <- c("kljuc.izdelka", "kategorija.izdelka", "dolzina.naziva.izdelka", "dolzina.opisa.izdelka", 
               "stevilo.objavljenih.fotografij.izdelka", "masa.izdelka (g)", "dolzina", "visina", "sirina")
tabela_produktov <- read_csv("podatki/olist_products_dataset.csv", na = c("", " ", "NA")) %>% drop_na() 
colnames(tabela_produktov) <- stolpci_3

#Uvoz četrte tabele
stolpci_4 <- c("original", "prevod")
tabela_prevodov <- read_csv("podatki/product_category_name_translation.csv")
colnames(tabela_prevodov) <- stolpci_4


#Združevanje 1. in 2. tabele
narocila <- left_join(tabela_narocil, tabela_vrst_placil, by = c("kljuc.narocila"), copy=FALSE)
narocila <- narocila %>% drop_na()
narocila$status.narocila <- as.factor(narocila$status.narocila)
narocila$tip.placila <- as.factor(narocila$tip.placila)
narocila$zaporedje.placila <- NULL
narocila$kljuc.uporabnika <- NULL
narocila$odobren.cas.nakupa <- NULL
narocila$cas.ko.je.posiljko.prejel.partner <- NULL
narocila$pravocasnost = narocila$predviden.cas.dostave >= narocila$dejanski.cas.dostave


#Tabela ki opisuje promet na platformi v letu 2017
promet_2017 <- narocila %>%
  select(dejanski.cas.dostave, vrednost.placila) %>%
  filter(dejanski.cas.dostave >= "2016-12-31" & dejanski.cas.dostave <= "2018-01-01") %>%
  mutate(mesec.dostave = month(dejanski.cas.dostave)) %>%
  select(mesec.dostave, vrednost.placila) %>%
  group_by(mesec.dostave) %>%
  summarise(vrednost.placila = sum(vrednost.placila))


#Tabela, ki opisuje promet na platformi v decembru leta 2017
december <- narocila %>%
  select(cas.nakupa, vrednost.placila) %>%
  filter(cas.nakupa >= "2017-12-01" & cas.nakupa <= "2017-12-31") %>%
  mutate(dan.narocila = day(cas.nakupa)) %>%
  select(dan.narocila, vrednost.placila) %>%
  group_by(dan.narocila) %>%
  summarise(vrednost.placila = sum(vrednost.placila))

#Tabela, ki opisuje promet na platformi v novembru leta 2017
november <- narocila %>%
  select(cas.nakupa, vrednost.placila) %>%
  filter(cas.nakupa >= "2017-11-01" & cas.nakupa <= "2017-11-30") %>%
  mutate(dan.narocila = day(cas.nakupa)) %>%
  select(dan.narocila, vrednost.placila) %>%
  group_by(dan.narocila) %>%
  summarise(vrednost.placila = sum(vrednost.placila))


#Združevanje 3. in 4. tabele
izdelki <- left_join(tabela_produktov, tabela_prevodov, by = c("kategorija.izdelka"="original"), copy=FALSE)
izdelki$kategorija.izdelka <- NULL
izdelki$dolžina.naziva.izdelka <- NULL
izdelki$dolžina.opisa.izdelka<- NULL
izdelki$število.objavljenih.fotografij.izdelka <- NULL
names(izdelki)[6] <- c("kategorija.izdelka")
library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(lubridate)
library(sp)


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
               "stevilo.objavljenih.fotografij.izdelka", "masa.izdelka", "dolzina", "visina", "sirina")
tabela_produktov <- read_csv("podatki/olist_products_dataset.csv", na = c("", " ", "NA")) %>% drop_na() 
colnames(tabela_produktov) <- stolpci_3


#Uvoz četrte tabele
stolpci_4 <- c("original", "prevod")
tabela_prevodov <- read_csv("podatki/product_category_name_translation.csv")
colnames(tabela_prevodov) <- stolpci_4


#Uvoz pete tabele
stolpci_5 <- c("postna.stevilka", "zemljepisna.sirina", "zemljepisna.dolzina", "mesto", "zvezna.drzava")
tabela_lokacij <- read_csv("podatki/olist_geolocation_dataset.csv", na = c("", " ", "NA"))
tabela_lokacij <- tabela_lokacij %>% drop_na()
colnames(tabela_lokacij) <- stolpci_5


#Uvoz šeste tabele
stolpci_6 <- c("kljuc.prodajalca", "postna.stevilka", "mesto", "zvezna.drzava")
tabela_prodajalcev <- read_csv("podatki/olist_sellers_dataset.csv", na = c("", " ", "NA"))
tabela_prodajalcev <- tabela_prodajalcev %>% drop_na
colnames(tabela_prodajalcev) <- stolpci_6


#Uvoz sedme tabele
stolpci_7 <- c("kljuc.uporabnika", "unikaten.kljuc.uporabnika", "postna.stevilka", "mesto", "zvezna.drzava")
tabela_kupcev <- read_csv("podatki/olist_customers_dataset.csv", na = c("", " ", "NA"))
tabela_kupcev <- tabela_kupcev %>% drop_na()
colnames(tabela_kupcev) <- stolpci_7


#Uvoz osme tabele
tabela_narocil_prodajalcev <- read_csv("podatki/olist_order_items_dataset.csv")
tabela_narocil_prodajalcev <- tabela_narocil_prodajalcev %>%
  select(order_id, seller_id)
stolpci_8 <- c("kljuc.narocila", "kljuc.prodajalca")
colnames(tabela_narocil_prodajalcev) <- stolpci_8


#Združevanje 1. in 2. tabele
narocila <- left_join(tabela_narocil, tabela_vrst_placil, by = c("kljuc.narocila"), copy=FALSE)
narocila <- narocila %>% 
  drop_na() %>%
  select(-zaporedje.placila, -kljuc.uporabnika, -odobren.cas.nakupa, -cas.ko.je.posiljko.prejel.partner) %>%
  mutate(pravocasnost = predviden.cas.dostave >= dejanski.cas.dostave, status.narocila = as.factor(status.narocila))


#Združevanje 3. in 4. tabele
izdelki <- left_join(tabela_produktov, tabela_prevodov, by = c("kategorija.izdelka"="original"), copy=FALSE)
izdelki <- izdelki %>%
  select(-dolzina.naziva.izdelka, -dolzina.opisa.izdelka, -stevilo.objavljenih.fotografij.izdelka, -kategorija.izdelka) %>%
  rename("kategorija.izdelka" = prevod)


#Združevanje 5. in 6. tabele
lokacija_prodajalcev <- left_join(tabela_prodajalcev, tabela_lokacij, by = c("postna.stevilka" = "postna.stevilka", "mesto" = "mesto", "zvezna.drzava" = "zvezna.drzava"), copy=FALSE)
lokacija_prodajalcev <- lokacija_prodajalcev %>%
  drop_na()


#Združevanje 5. in 7. tabele
lokacija_kupcev <- left_join(tabela_kupcev, tabela_lokacij, by = c("postna.stevilka" = "postna.stevilka", "mesto" = "mesto", "zvezna.drzava" = "zvezna.drzava"), copy=FALSE)
lokacija_kupcev <- lokacija_kupcev %>%
  drop_na() %>%
  left_join(tabela_narocil %>% select(kljuc.narocila, kljuc.uporabnika), by="kljuc.uporabnika", copy=FALSE) %>%
  left_join(tabela_vrst_placil %>% select(kljuc.narocila, tip.placila), by="kljuc.narocila", copy=FALSE) %>%
  drop_na() %>%
  select(kljuc.uporabnika, zemljepisna.sirina, zemljepisna.dolzina, tip.placila) %>%
  mutate(tip.placila = tip.placila %>% as.factor())



#Tabela opisuje zemljepisna koordinate in trajanje da je narocilo prispelo
lokacija_narocil <- tabela_narocil_prodajalcev %>%
  left_join(tabela_narocil %>% select(kljuc.narocila, cas.nakupa, dejanski.cas.dostave), by="kljuc.narocila", copy=FALSE) %>%
  mutate(trajanje=difftime(dejanski.cas.dostave, cas.nakupa, units="days") %>% round(digits=0)) %>%
  select(-cas.nakupa, -dejanski.cas.dostave) %>%
  left_join(lokacija_prodajalcev %>% select(kljuc.prodajalca, zemljepisna.dolzina, zemljepisna.sirina), by="kljuc.prodajalca", copy=FALSE) %>%
  drop_na() %>%
  rename(zemljepisna.dolzina.P=zemljepisna.dolzina, zemljepisna.sirina.P=zemljepisna.sirina) %>%
  left_join(tabela_narocil %>% select(kljuc.narocila, kljuc.uporabnika), by="kljuc.narocila", copy=FALSE) %>%
  left_join(lokacija_kupcev %>% select(kljuc.uporabnika, zemljepisna.sirina, zemljepisna.dolzina) %>% distinct(kljuc.uporabnika, .keep_all=TRUE), 
    	by="kljuc.uporabnika", copy=FALSE) %>%
  left_join(narocila %>% select(kljuc.narocila, pravocasnost), by="kljuc.narocila", copy=FALSE) %>%
  drop_na() %>%
  rename(zemljepisna.sirina.K=zemljepisna.sirina, zemljepisna.dolzina.K=zemljepisna.dolzina) %>%
  distinct(kljuc.narocila, .keep_all=TRUE) %>%
  mutate(razdalja=spDists(matrix(c(zemljepisna.dolzina.P, zemljepisna.sirina.P), ncol=2),
                          matrix(c(zemljepisna.dolzina.K, zemljepisna.sirina.K), ncol=2),
                          longlat=TRUE, diagonal=TRUE)) %>%
  mutate(trajanje = trajanje %>% as.numeric())



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



library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(lubridate)
library(sp)
### Ta program združuje tabele za potrebo regresije in jih zapisuje v datoteko regresija.csv --> datoteko potem preberem v uvozu

#Združevanje 5. in 6. tabele
lokacija_prodajalcev <- left_join(tabela_prodajalcev, tabela_lokacij, by = c("postna.stevilka" = "postna.stevilka", "mesto" = "mesto", "zvezna.drzava" = "zvezna.drzava"), copy=FALSE)
lokacija_prodajalcev <- lokacija_prodajalcev %>%
  drop_na()


#Združevanje 5. in 7. tabele
lokacija_kupcev <- left_join(tabela_kupcev, tabela_lokacij, by = c("postna.stevilka" = "postna.stevilka", "mesto" = "mesto", "zvezna.drzava" = "zvezna.drzava"), copy=FALSE)
lokacija_kupcev <- lokacija_kupcev %>%
  drop_na()

lokacija_narocil <- tabela_narocil_prodajalcev %>%
  left_join(tabela_narocil %>% select(kljuc.narocila, cas.nakupa, dejanski.cas.dostave),
            by="kljuc.narocila", copy=FALSE) %>%
  mutate(trajanje=difftime(dejanski.cas.dostave, cas.nakupa, units="days") %>% round(digits=0)) %>%
  select(-cas.nakupa, -dejanski.cas.dostave) %>%
  left_join(lokacija_prodajalcev %>%
              select(kljuc.prodajalca, zemljepisna.dolzina, zemljepisna.sirina),
            by="kljuc.prodajalca", copy=FALSE) %>%
  drop_na() %>%
  rename(zemljepisna.dolzina.P=zemljepisna.dolzina, zemljepisna.sirina.P=zemljepisna.sirina) %>%
  left_join(tabela_narocil %>% select(kljuc.narocila, kljuc.uporabnika),
            by="kljuc.narocila", copy=FALSE) %>%
  left_join(lokacija_kupcev %>%
              select(kljuc.uporabnika, zemljepisna.sirina, zemljepisna.dolzina) %>%
              distinct(kljuc.uporabnika, .keep_all=TRUE),
            by="kljuc.uporabnika", copy=FALSE) %>%
  drop_na() %>%
  rename(zemljepisna.sirina.K=zemljepisna.sirina, zemljepisna.dolzina.K=zemljepisna.dolzina) %>%
  distinct(kljuc.narocila, .keep_all=TRUE) %>%
  mutate(razdalja=spDists(matrix(c(zemljepisna.dolzina.P, zemljepisna.sirina.P), ncol=2),
                          matrix(c(zemljepisna.dolzina.K, zemljepisna.sirina.K), ncol=2),
                          longlat=TRUE, diagonal=TRUE))

write.csv(lokacija_narocil, "uvoz/regresija.csv", row.names=TRUE )

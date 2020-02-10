# Analiza poslovanja na platformi [Olist](https://olist.com/)

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2018/19

* [![Shiny](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/DiogenesB/APPR-2018-19/master?urlpath=shiny/APPR-2018-19/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/DiogenesB/APPR-2018-19/master?urlpath=rstudio) RStudio

## Tematikas

### Kaj sploh je Olist?
Olist je brazilska platforma, ki omogoča malim podjetjem vzpostaviti prodajne kanale preko njihove spletne strani ("brazilski ebay"). Podjetje lahko svoje izdelke prodaja preko Olist Store trgovine, svoje izdelke pa pošilja preko logističnih partnerjev Olist-a.

Potem ko kupec izpolni naročilo, prodajalec dobi obvestilo da lahko odpremi artikle. Ko stranka artikel prejme ali pa je datum predvidene dostave že mimo, stranka po epošti prejme anketo o zadovoljstvu, kjer lahko poda komentar o storitvi.

### Kakšen je cilj analize?
Izvedel bom analizo naročil med leti 2016 in 2018. 
Pogledal si bom:
- Delež dostav, ki so bile izvedene v roku in hitrost dostave v odvisnosti razdalje (3. faza)
- Povprečni znesek nakupa in način plačila (3. faza)
- Kategorije izdelkov, ki prevladujejo na platformi (3. faza)
- Vizualizacija lokacije naslovov naročil (3. faza)
- Predvidevanje prejema naročila (4. faza)
- Segmentacija trga (4. faza)

## Podatki

### Podatkovni vir
[Vir](https://www.kaggle.com/olistbr/brazilian-ecommerce/home) iz katerega bom črpal podatke je javno dostopen nabor podatkov iz spletne platforme [Kaggle](https://www.kaggle.com/)
Uporabil bom nabor 7 različnih csv dokumentov:
1. `olist_orders_dataset.csv`
2. `olist_order_payments_dataset.csv`
3. `product_category_name_translation.csv`
4. `olist_products_dataset.csv`
5. `olist_geolocation_dataset.csv`
6. `olist_sellers_dataset.csv`
7. `olist_order_items_data.csv`


### Podatkovni model

Podatkovni koncept tabel (shema tabel po 2. fazi):

#### 1. tabela (`olist_orders_dataset.csv`)

| "order.delivered.carrier.date" | ""order.delivered.customer.date" | "order.estimated.delivery.date" |
| :---: | :---: | :---: |
| Datum, ko je logistični partner prejel izdelek, tip: date object | Datum, ko je stranka dejansko prejela naročilo, tip: date object | Datum, ki je bil predviden za prejem naročila, tip: date object |


#### 2. tabela (`olist_order_payments_dataset.csv`)

| "payment.value" | "payment.type" |
| :---: | :---: |
| Znesek naročila, tip: število | Tip plačila, tip: neurejen faktor |


#### 3. tabela (`olist_products_dataset.csv` in `product_category_name_translation.csv` )

| "product.id" | "product.category.name" |
| :---: | :---: |
| Šifrant artikla, tip: hexadecimal (UUID) | Kategorija izdelka v Angleščini (z uporabo 3. in 4. csvja), tip: neurejen faktor |


#### 4. tabela (`olist_geolocation_dataset.csv`)

| "geolocation.lat" | "geolocation.lng" |
| :---: | :---: |
| Zemljepisna širina, tip: število | Zemljepisna dolžina, tip: število |

#### 5. tabela (`olist_orders_dataset.csv`, `olist.sellers.dataset.csv`, `olist.geolocation.dataset.csv` in `olist.order.items.dataset.csv`)

| "seller.lat" | "seller.lng" | "custmer.lat" | "custmer.lng" | "order.approved.at" | "order.delivered.custmer.date" (to spremenljivko napovedujemo) |
| :---: | :---: | :---: | :---: | :---: | :---: |
| Zemljepisna širina prodajalca, tip: število | Zemljepisna dolžina prodajalca, tip: število | Zemljepisna širina kupca, tip: število | Zemljepisna dolžina kupca, tip: število | Čas, ko je bilo potrjeno naročilo, tip: date object (?)| Čas, ko so bili naročilo dostavljeno, tip: datetime   

### Plan dela

#### Čiščenje in analiza podaktov (2. in 3. faza)

1. tabela:
    - Čiščenje podatkov
    - Pretvarjanje tipov 
    - Analiza

2. tabela:
    - Čiščenje podatkov
    - Pretvarjanje tipov
    - Analiza

3. tabela:
    - Čiščenje podatkov
    - Pretvarjanje tipov
    - Združevanje s 4. tabelo

4. tabela:
    - Čiščenje podatkov
    - Pretvarjanje tipov
    - Združevanje s 3. tabelo
    - Analiza 

5. tabela:
    - Čiščenje podatkov
    - Vizualizacija naročil

#### Napredna analiza (4. faza)

Pri napredni analizi (linerani agresiji) bom izračunaval **predviden čas pošiljke** s pomočjo 1. tabele (`olist.orders.dataset.csv`) in **segmentacijo kupcev** (clustering) s pomočjo 1. in 2. tabele (`olist_orders_dataset.csv` in `olist_customers_dataset.csv` )

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `rgdal` - za uvoz zemljevidov
* `rgeos` - za podporo zemljevidom
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `mosaic` - za pretvorbo zemljevidov v obliko za risanje z `ggplot2`
* `maptools` - za delo z zemljevidi
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
* `ostalo` - sprotno dopolnjevanje (od 2. faze dalje)

## Binder

Zgornje [povezave](#analiza-podatkov-s-programom-r-201819)
omogočajo poganjanje projekta na spletu z orodjem [Binder](https://mybinder.org/).
V ta namen je bila pripravljena slika za [Docker](https://www.docker.com/),
ki vsebuje večino paketov, ki jih boste potrebovali za svoj projekt.

Če se izkaže, da katerega od paketov, ki ji potrebujete, ni v sliki,
lahko za sprotno namestitev poskrbite tako,
da jih v datoteki [`install.R`](install.R) namestite z ukazom `install.packages`.
Te datoteke (ali ukaza `install.packages`) **ne vključujte** v svoj program -
gre samo za navodilo za Binder, katere pakete naj namesti pred poganjanjem vašega projekta.

Tako nameščanje paketov se bo izvedlo pred vsakim poganjanjem v Binderju.
Če se izkaže, da je to preveč zamudno,
lahko pripravite [lastno sliko](https://github.com/jaanos/APPR-docker) z želenimi paketi.

Če želite v Binderju delati z git,
v datoteki `gitconfig` nastavite svoje ime in priimek ter e-poštni naslov
(odkomentirajte vzorec in zamenjajte s svojimi podatki) -
ob naslednjem.zagonu bo mogoče delati commite.
Te podatke lahko nastavite tudi z `git config --global` v konzoli
(vendar bodo veljale le v trenutni seji).

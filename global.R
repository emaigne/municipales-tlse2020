library(shiny)
library(data.table)
library(ggplot2)
library(leaflet)
library(geojson)
library(geojsonio)

votes_bureaux <- fread("data/elections-municipales-et-communautaires-2020-2eme-tour-toulouse-resultats.csv")

setnames(votes_bureaux, "Nombre de voix de la liste : Archipel Citoyen", "Archipel")
setnames(votes_bureaux, "Nombre de voix de la liste : Aimer Toulouse", "Moudenc")

votes_bureaux[,pctAbstention := Abstentions/Inscrits]
votes_bureaux[,pctArchipel := Archipel/Inscrits]
votes_bureaux[,pctMoudenc := Moudenc/Inscrits]
votes_bureaux[,pctArchipel_exprimes := Archipel/(Archipel + Moudenc)]
votes_bureaux[,pctMoudenc_exprimes := Moudenc/(Archipel + Moudenc)]

votes_tidy <- tidyr::pivot_longer(votes_bureaux[,.(BDV = `Numéro bdv`, 
                                                   Abstention=Abstentions, 
                                                   Archipel = Archipel, 
                                                   Moudenc = Moudenc)], 
                                  cols = -`BDV`, 
                                  names_to = "Indic", values_to = "Nombre")

pct_tidy <- tidyr::pivot_longer(votes_bureaux[,.(BDV = `Numéro bdv`, 
                                                 Abstention = pctAbstention, 
                                                 Archipel = pctArchipel, 
                                                 Moudenc = pctMoudenc)], 
                                cols = -`BDV`, 
                                names_to = "Indic", values_to = "Pct")

votes_tidy <- merge(votes_tidy, pct_tidy, all=T)

# ggplot(votes_tidy, aes(x=Indic, y=Nombre)) + geom_col()
# ggplot(votes_bureaux, aes(x=pctArchipel_exprimes, y=pctAbstention)) + geom_point()
# ggplot(votes_bureaux, aes(x=pctMoudenc_exprimes, y=pctAbstention)) + geom_point()

bureau_map <- geojson_read("data/elections-2020-decoupage-bureaux-de-vote-toulouse.geojson", what="sp")

votes_bureaux[,`Numéro bdv`:=as.character(`Numéro bdv`)]
bureau_map$bv2020<-as.character(bureau_map$bv2020)
bureau_map@data <- merge(bureau_map@data, 
                         votes_bureaux[,.(`Numéro bdv`, Archipel, Moudenc, pctArchipel, pctMoudenc, pctAbstention, pctArchipel_exprimes, pctMoudenc_exprimes)],
                         by.x="bv2020", by.y="Numéro bdv", all=T, sort = F)


binsmap <- c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, Inf)
pal <- colorBin(colorRamp(c("#006633", "#FFFFFF", "#660000")), domain = c(0,1), bins = binsmap)


labels <- sprintf(
  "<strong>%s</strong><br/> %s Abstention<br/>%g Archipel (%s des exprimés)<br/> %g Moudenc (%s des exprimés)",
  bureau_map$nom, paste0(round(100*bureau_map$pctAbstention,2),"%"), 
  bureau_map$Archipel, paste0(round(100*bureau_map$pctArchipel_exprimes,2),"%"), 
  bureau_map$Moudenc, paste0(round(100*bureau_map$pctMoudenc_exprimes,2),"%")
) %>% lapply(htmltools::HTML)

bureau_map@data$labelsmap <- labels


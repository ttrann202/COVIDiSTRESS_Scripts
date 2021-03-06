#!/usr/bin/env Rscript

library(ggplot2)
library(plotly)
library(dplyr)
library(maps)

data = read.csv("../covid_06042020_choice_values.csv", header=T, stringsAsFactors=F)
data = data[3:nrow(data),]

world_map <- map_data("world")
world_map$country = world_map$region

world_map[world_map$region == "Grenadines","country"] <- "Saint Vincent and the Grenadines"
world_map[world_map$region == "Saint Vincent","country"] <- "Saint Vincent and the Grenadines"
world_map[world_map$region == "Antigua","country"] <- "Antigua and Barbuda"
world_map[world_map$region == "Barbuda","country"] <- "Antigua and Barbuda"

world_map[world_map$region == "Aruba","country"] <- "Netherlands"
world_map[world_map$region == "Curacao","country"] <- "Netherlands"
world_map[world_map$region == "Bonaire","country"] <- "Netherlands"
world_map[world_map$region == "Sint Eustatius","country"] <- "Netherlands"
world_map[world_map$region == "Saba","country"] <- "Netherlands"
world_map[world_map$region == "Sint Maarten","country"] <- "Netherlands"

world_map[world_map$region == "Anguilla","country"] <- "UK"
world_map[world_map$region == "Bermuda","country"] <- "UK"
world_map[world_map$region == "Falkland Islands","country"] <- "UK"
world_map[world_map$region == "Chagos Archipelago","country"] <- "UK"
world_map[world_map$region == "Pitcairn Islands","country"] <- "UK"
world_map[world_map$region == "South Sandwich Islands","country"] <- "UK"
world_map[world_map$region == "Saint Helena","country"] <- "UK"
world_map[world_map$region == "Ascension Island","country"] <- "UK"
world_map[world_map$region == "Turks and Caicos Islands","country"] <- "UK"

world_map[world_map$region == "French Southern and Antarctic Lands","country"] <- "France"
world_map[world_map$region == "Saint Barthelemy","country"] <- "France"
world_map[world_map$region == "Reunion","country"] <- "France"
world_map[world_map$region == "Mayotte","country"] <- "France"
world_map[world_map$region == "French Guiana","country"] <- "France"
world_map[world_map$region == "Martinique","country"] <- "France"
world_map[world_map$region == "Guadeloupe","country"] <- "France"
world_map[world_map$region == "Saint Martin","country"] <- "France"
world_map[world_map$region == "New Caledonia","country"] <- "France"
world_map[world_map$region == "French Polynesia","country"] <- "France"
world_map[world_map$region == "Saint Pierre and Miquelon","country"] <- "France"
world_map[world_map$region == "Wallis and Futuna","country"] <- "France"

world_map[world_map$region == "Canary Islands","country"] <- "Spain"
world_map[world_map$region == "Montserrat","country"] <- "Spain"

world_map[world_map$region == "Azores","country"] <- "Portugal"

world_map[world_map$region == "Guam","country"] <- "USA"
world_map[world_map$region == "Puerto Rico","country"] <- "USA"

world_map[world_map$region == "Heard Island","country"] <- "Australia"
world_map[world_map$region == "Cocos Islands","country"] <- "Australia"
world_map[world_map$region == "Christmas Island","country"] <- "Australia"
world_map[world_map$region == "Norfolk Island","country"] <- "Australia"

world_map[world_map$region == "Siachen Glacier","country"] <- "India"

world_map[world_map$region == "Trinidad","country"] <- "Trinidad and Tobago"
world_map[world_map$region == "Tobago","country"] <- "Trinidad and Tobago"

nb_rep_by_country <- table(data$Country)
nb_rep_by_country <- nb_rep_by_country[names(nb_rep_by_country) != ""]
names(nb_rep_by_country) <- replace(names(nb_rep_by_country), 
                                    names(nb_rep_by_country) %in% c("- other","Cabo Verde","Congo, Democratic Republic of the","Congo, Republic of the","Côte d’Ivoire","East Timor (Timor-Leste)","Korea, North","Korea, South","Micronesia, Federated States of","North Macedonia","Sudan, South","The Bahamas","United Kingdom","United States"),
                                    c(NA,"Cape Verde","Democratic Republic of the Congo","Republic of Congo","Ivory Coast","Timor-Leste","North Korea","South Korea","Micronesia","Macedonia","South Sudan","Bahamas","UK","USA"))

world_map$nb_answers <- 0
world_map$nb_answers <- as.vector(nb_rep_by_country[match(world_map$country,names(nb_rep_by_country))])

world_map <- world_map %>%
        mutate(country_text = paste0(
               "Country: ", country, "\n",
               "Region: ", region, "\n",
               "# of answers: ", nb_answers))

p <- ggplot(world_map) +
     geom_polygon(aes( x = long, y = lat, group = group, fill = nb_answers, text = country_text), colour = "black", size = 0.2)+
     scale_fill_distiller(palette = "Spectral", name = "# of answers")+
     theme_void()

ggplotly(p, tooltip="text")
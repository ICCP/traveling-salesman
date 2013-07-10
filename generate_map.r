
library(ggmap)
library(ggplot2)

numCities <- 10

mi.cities <- read.csv("mi_cities.dat")
mi.cities <- cbind(mi.cities, logPopulation=log(mi.cities$Population))
mi.short <- head(mi.cities, numCities)

# Get latitude & longitude values from City name + "Michigan" and bind it all
# together into an appropriate data frame. Don't query the server more than
# 2500 times/day
coordinates <- lapply(as.vector(mi.short$City),
                      function(s)(geocode(paste(s,"Michigan"))))
coordinates <- do.call(rbind, coordinates)
mi.short <- cbind(mi.short, coordinates)

bounding_box <- c(min(mi.short$lon), min(mi.short$lat), max(mi.short$lon), max(mi.short$lat))

michigan <- get_map(location = bounding_box, maptype="terrain", source="stamen")

# This line must be run manually in a GUI to produce a plot
ggmap(michigan) + geom_point(data=mi.short, aes(x=lon, y=lat, size=6, color=logPopulation)) + scale_color_gradient(low="blue", high="red")

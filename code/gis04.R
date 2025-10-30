if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars,
               here)

# read/export raster data

## read geotiff
(spr_ex <- rast(here("data/spr_example.tif")))

## export geotiff
writeRaster(spr_ex,
            filename = "data/spr_elev.tif",
            overwrite = TRUE)

## mapping
ggplot() +
  geom_spatraster(data = spr_ex)

## mapping function
star_ex <- st_as_stars(spr_ex)
class(spr_ex)
class(star_ex)

mapview(star_ex)


## raster data type

v_elev <- values(spr_ex)
head(v_elev, 10)

na.omit(v_elev) %>%
  mean()

## extract data from a given location
## xy specifies longitude/latitude
xy <- cbind(6.0000, 50.0000)
extract(spr_ex, xy)

## xy can be multiple sites
df_point <- tibble(lon = c(6, 5.9),
                   lat = c(50, 49.96))

extract(spr_ex,
        y = df_point)

## discrete reaster
(spr_for <- rast("data/spr_forest_nc.tif"))

ggplot() +
  geom_spatraster(data = spr_for)

unique(spr_for)

v_binary <- values(spr_for)
mean(v_binary)

## discrete, coded values
spr_land <- rast("data/spr_land_reclass.tif")
unique(spr_land)

extract(spr_land, cbind(-79.8063, 36.0701))


# reclass

# create a conversion matrix
cm <- cbind(c(0, 1001, 1010, 1100),
             c(0, 1, 0, 0))

# reclass
spr_bin <- classify(spr_land,
                    rcl = cm)

unique(spr_bin)

v_bin <- values(spr_bin)
mean(v_bin)

## Excersice
# 1
(spr_prec_ncne <- rast("data/spr_prec_ncne.tif"))

# 2
#It has 162 rows and 532 columns
#Each cell represents a rectangular area of 0.008333333 degrees in both x (longitude) and y (latitude)
#The spatial extent of the raster is (xmin -79.89181, xmax -75.45847, ymin 35.24153, ymax 36.59153)
#The CRS is WGS 84 (line coord. ref.), (EPSG:4326)
#The raster contains elevation data with values ranging from 1063.1 to 1501.5

# 3
ggplot() +
  geom_spatraster(data = spr_prec_ncne)

# 4
(sf_site <- readRDS("data/sf_finsync_nc.rds"))
(df_xy <- st_coordinates(sf_site))
(df_land <- extract(spr_land, df_xy))

sum(df_land[, 1] == 1001)
sum(df_land[, 1] == 1010)
sum(df_land[, 1] == 1100)

# 5
cu <- cbind(c(0, 1001, 1010, 1100),
            c(0, 0, 0, 1))

spr_urban <- classify(spr_land,
                      rcl = cu)

values(spr_urban) %>%
  mean()


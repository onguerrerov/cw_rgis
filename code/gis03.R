

if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview,
               here)

# spacial join ------------------------------------------------------------

## point vector
sf_site <- readRDS("data/sf_finsync_nc.rds")

##polygon vector
sf_nc_county <- readRDS(file = here("data/sf_nc_county.rds"))

## sf_join() evaluate two geometry layers
sf_site_join <- st_join(x = sf_site,
                        y = sf_nc_county)

# check how it works
sf_one <- sf_site %>%
  slice(1)

mapview(sf_nc_county) + mapview(sf_one)

#get data by county
sf_site_guilford <- sf_site_join %>%
  filter(county == "guilford")

sf_nc_guilford <- sf_nc_county %>%
  filter(county == "guilford")

sf_str_guilford <- readRDS(here("data/sf_stream_gi.rds"))  

# create a map
ggplot() +
  geom_sf(data = sf_nc_guilford) +
  geom_sf(data = sf_str_guilford,
          color = "steelblue") +
  geom_sf(data = sf_site_guilford,
          color = "salmon")

# count the number of sites in each county
# identify the county that has the most sites
# function "n()" may be useful to count # rows in each group
# group_by() & summarize()

df_n <- sf_site_join %>%
  as_tibble() %>%
  group_by(county) %>%
  summarise(n_site = n()) %>%
  arrange(desc(n_site))

## 'sf_nc_county' - this is a "geospatial" object
## 'df_n' - the number of sites by county
## combine them with left_join()
## assign to 'sf_nc_n'

sf_nc_n <- sf_nc_county %>%
  left_join(df_n,
            by = "county") %>%
  mutate(n_site = ifelse(is.na(n_site),
                         0,
                         n_site))

## mapping 
ggplot() +
  geom_sf(data = sf_nc_n,
          aes(fill = n_site))


# geometric analysis

# length calculation
## change CRS first!
sf_str_proj <- st_transform(sf_str_guilford,
                            crs = 32617)

v_str_l <- st_length(sf_str_proj)
head(v_str_l)

sf_str_w_len <- sf_str_guilford %>%
  mutate(length = as.numeric(v_str_l))

# draw a map
ggplot() +
  geom_sf(data = sf_str_w_len,
          aes(color = length))

# area calculation 
sf_nc_county_proj <- st_transform(sf_nc_county,
                                  crs = 32617)

v_area <- st_area(sf_nc_county_proj)

sf_nc_county_w_area <- sf_nc_county %>%
  mutate(area = as.numeric(v_area))

## draw a map
ggplot() +
  geom_sf(data = sf_nc_county_w_area,
          aes(fill = area))# +
  #MetBrewer::scale_fill_met_c("Hiroshige")

# excersice 
1
sf_quakes <- readRDS(here("data/sf_quakes.rds"))
sf_nz <- readRDS(here("data/sf_nz.rds"))
mapview(sf_quakes) + mapview(sf_nz)

sf_quakes_join <- st_join(x = sf_quakes,
                          y = sf_nz)

sf_quakes_nz <- drop_na(sf_quakes_join, fid)

nrow(sf_quakes_nz)

2
df_n <- sf_site_join %>% 
  as_tibble() %>% 
  group_by(county) %>% 
  summarize(n_site = n())

sf_n_site <- sf_nc_county %>%
  left_join(df_n,
            by = "county")

sf_n10 <- sf_n_site %>%
  filter(n_site > 10)

ggplot() +
  geom_sf(data = sf_n_site,
          color = "gray") +
  geom_sf(data = sf_n10,
          color = "salmon")

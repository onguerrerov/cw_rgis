if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               ggeffects,
               sf,
               terra,
               tidyterra,
               exactextractr,
               mapview,
               here)


#prepare ecological data

(df_finsync <- read_csv(here("data/data_finsync_nc.csv")))

(df_st1 <- df_finsync %>% 
    filter(site_id == "finsync_nrs_nc-10013"))

df_w <- df_finsync %>% 
  pivot_wider(id_cols = c(site_id, lon, lat),
              names_from = latin,
              values_from = presence, 
              values_fill = 0)
  
## select column
## site_id, lon, lat, Lepomis auritus
df_rbs <- df_w %>%
  select(site_id,
       lon,
       lat,
       "Lepomis auritus") %>% 
  rename(y = 'Lepomis auritus')

## create sf objects; st_as_sf()
sf_rbs <- st_as_sf(df_rbs,
                   coords = c("lon", "lat"),
                   crs = 4326)

(spr_tmp_nc <- rast(here("data/spr_tmp_nc.tif")))


sf_rbs_w_tmp <- extract(x = spr_tmp_nc,
                        y = sf_rbs,
                        bind = TRUE) %>%
  st_as_sf()

## mapping
## - raster layer with temperature data
## - survey site

ggplot() +
  geom_spatraster(data = spr_tmp_nc) +
  geom_sf(data = sf_rbs_w_tmp) +
  scale_fill_viridis_c()

## statistical analysis

##draw a figure relating fish presence absence to temperature
df_rbs_w_tmp <- as_tibble(sf_rbs_w_tmp)

df_rbs_w_tmp %>%
  ggplot(aes(y = y, 
             x = temperature)) +
  geom_point() +
  theme_bw()

m_rbs <- glm(y ~ temperature, 
             data = df_rbs_w_tmp,
             family = "binomial")

summary(m_rbs)

## draw prediction line
df_pred <- ggpredict(m_rbs, terms = "temperature [all]")

ggplot() +
  geom_point(data = df_rbs_w_tmp,
             aes(x = temperature,
                 y = y)) +
  geom_line(data = df_pred,
            aes(x = x,
                y = predicted)) +
  geom_ribbon(data = df_pred,
              aes(x = x,
                  ymin = conf.low,
                  ymax = conf.high),
              fill = "gray",
              alpha = 0.2) +
  theme_bw() +
  labs(x = "Air temperature",
       y = "Probability of occurrence")

## species list

df_finsync %>%
  pull(latin) %>%
  unique() %>%
  sort()

df_finsync %>%
  filter(latin == "Clinostomus funduloides")

## Clinostomus funduloides
## Species presence/absence 
## spr_tmp_nc.tif – Air temperature
## Clinostomus funduloides prefers cooler waters, so i predict it will be richer in cooler areas

# script begins with loading packages
# library() function would work, but pacman::p_load() allows you to load multiple packages at once
if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse)

set.seed(123)

iris_sub <- as_tibble(iris) %>% 
  group_by(Species) %>% 
  sample_n(3) %>% 
  ungroup()

print(iris_sub)

filter(iris_sub, Species == "virginica")

filter(iris_sub, Species %in% c("virginica", "versicolor"))

filter(iris_sub, Species != "virginica")

filter(iris_sub, !(Species %in% c("virginica", "versicolor")))

filter(iris_sub, Sepal.Length >5)

filter(iris_sub, Sepal.Length >=5)

filter(iris_sub, Sepal.Length <5)

filter(iris_sub, Sepal.Length <=5)

filter(iris_sub,
       Sepal.Length <5 & Species == "setosa")

filter(iris_sub,
       Sepal.Length <5, Species == "setosa")

filter(iris_sub,
       Sepal.Length <5 | Species == "setosa")

arrange(iris_sub, Sepal.Length)

arrange(iris_sub, desc(Sepal.Length))

select(iris_sub, Sepal.Length)

select(iris_sub, c(Sepal.Length, Sepal.Width))

select(iris_sub, -Sepal.Length)

select(iris_sub, -c(Sepal.Length, Sepal.Width))

select(iris_sub, starts_with("Sepal"))

select(iris_sub, -starts_with("Sepal"))

select(iris_sub, ends_with("width"))

select(iris_sub, -ends_with("Width"))

(x_max <- nrow(iris_sub))

x <- 1:x_max

mutate(iris_sub, row_id = x)

mutate(iris_sub, sl_two_times =2 * Sepal.Length)

##
df_vir <- filter(iris_sub, Species == "virginica")
df_vir_sl <- select(df_vir, Sepal.Length) 

print(df_vir_sl)

df_vir_sl <- iris_sub %>%
  filter(Species == "virginica") %>%
  select(Sepal.Length) 

print(df_vir_sl)

print(iris_sub)

iris_sub %>%
  group_by(Species)

iris_sub %>%
  group_by(Species) %>%
  summarize(mu_sl = mean(Sepal.Length))

iris_sub %>%
  group_by(Species) %>%
  summarise(mu_sl = mean(Sepal.Length),
            sum_sl = sum(Sepal.Length))

iris_sub %>%
  group_by(Species) %>%
  mutate(mu_sl = mean(Sepal.Length)) %>%
  ungroup()

iris_w <- iris_sub %>% 
  mutate(id = rep(1:3, 3)) %>% 
  select(id, Sepal.Length, Species) %>% 
  pivot_wider(id_cols = "id", 
              values_from = "Sepal.Length", 
              names_from = "Species")

print(iris_w)

iris_l <- iris_w %>%
  pivot_longer(cols = c("setosa",
                        "versicolor",
                        "virginica"),
               names_to = "Species",
               values_to = "Sepal.Length")

print(iris_l)

iris_l <- iris_w %>% 
  pivot_longer(cols = c("setosa",
                        "versicolor",
                        "virginica"), # columns with values to be reshaped
               names_to = "Species", # column IDs move to "Species"
               values_to = "Sepal.Length") # column values move to "Sepal.Length"

print(iris_l)

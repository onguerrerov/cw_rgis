

# ggplot

pacman::p_load(tidyverse)

# point
## without pipe
g_point <- ggplot(data = iris,
       mapping = aes(x = Sepal.Length,
                     y = Sepal.Width)) +
  geom_point()

## with pipe
g_point <- iris %>% 
  ggplot(aes(x = Sepal.Length,
             y = Sepal.Width)) +
  geom_point()

## color by group
g_point_col <- iris %>% 
  ggplot(aes(x = Sepal.Length,
             y = Sepal.Width,
             color = Species)) +
  geom_point()

##pitfall _commom mistakes
iris %>% 
  ggplot(aes(x = Sepal.Length,
             y = Sepal.Width),
         color = Species) +
  geom_point()

## when you want to color all one color
iris %>% 
  ggplot(aes(x = Sepal.Length,
             y = Sepal.Width)) +
  geom_point(color = "tomato")

# line 
df0 <- tibble(x = 1:50,
              y = 2 * x)

## geom_line() draws a line figure
## multiple layers can be added
df0 %>% 
  ggplot(aes(x = x,
             y = y)) +
  geom_line() +
  geom_point()

# histogram
iris %>% 
  ggplot(aes(x = Sepal.Length)) +
  geom_histogram()

#boxplot
iris %>% 
  ggplot(aes(x = Species,
             y = Sepal.Length)) +
  geom_boxplot()

## change color or fill
iris %>% 
  ggplot(aes(x = Species,
             y = Sepal.Length,
             color = Species)) +
  geom_boxplot()

iris %>% 
  ggplot(aes(x = Species,
             y = Sepal.Length,
             fill = Species)) +
  geom_boxplot()





g_pedal <- iris %>% 
  ggplot(aes(x = Petal.Width,
             y = Petal.Length)) +
  geom_point()





g_petal_box <- iris %>% 
  ggplot(aes(x = Petal.Width,
             y = Petal.Length)) +
  geom_point()


g_petal_box +
  geom_point()


#change 
g_petal_box +
  labs(x = "Plant ")



##excersise

df_mtcars <- as_tibble(mtcars)

# select rows with cyl is 4
filter(df_mtcars, cyl == 4)

#select columns mpg, cyl, disp, wt, vs, carb
select(df_mtcars,
       c(mpg, cyl, disp, wt, vs, carb))

# select rows with "cyl" is greater than 4
# then, select columns of mpg, cyl, disp, wt, vs, carb
# assign the output to dt_sub

df_sub <- df_mtcars %>% 
  filter(cyl > 4) %>% 
  select(mpg, cyl, disp, wt, vs, carb)


v_cars <- rownames(mtcars)

df_mtcars <- mutate(df_mtcars,
                    car = v_cars)

df_mtcars %>% 
  filter(cyl == 8) %>% 
  arrange(wt)

# calculate the average weight (wt) of cars within each group of gear numbers (gear) 
# consider using group by () and summarize()
# assign to 'df_mean'

df_mean <- df_mtcars %>% 
  group_by(gear) %>%
  summarise(mu =mean(wt))

#combination of dplyr operations with gplot
df_mtcars %>% 
  ggplot(aes(x = wt,
             y = qsec)) +
  geom_point()

#draw a figure between wt and qsec, but only those with cyl 6
df_mtcars %>% 
  filter(cyl == 6) %>% 
  ggplot(aes(x = wt,
             y = qsec)) +
  geom_point()

# draw a figure between mean "wt" and mean "qsec" for each group of 'gear'
df_mtcars %>% 
  group_by(gear) %>% 
  summarise(mu_wt = mean(wt),
            mu_qsec = mean(qsec)) %>% 
  ggplot(aes(x = mu_wt,
             y = mu_qsec)) +
  geom_point()

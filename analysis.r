# Put your own data folder 
datapath<- file.path("/Users/sojin/Downloads/KODAQS_Module4_Assignment_Jin/")

# Making virtual environment 
renv::init()

# package version management
# datapath <- file.path("/Users/sojin/Downloads/KODAQS_Module4_Assignment_Jin/")
# temp <- file.path(datapath, "install.R") 
# source(temp)

renv::snapshot()

netflix_data_path<- file.path(datapath, "netflix_titles.csv") 

netflix<-read.csv(netflix_data_path)

head(netflix, 2)

table(netflix$country) 

head(netflix, 2)

table(netflix$country) 

library(tidyr)
library(dplyr)

top_countries <- netflix %>%
  separate_rows(country, sep = ", ") %>%  # Split multiple countries
  filter(!is.na(country) & country != "") %>%  # Remove NA and empty strings
  count(country, sort = TRUE) %>%
  head(10)


top_countries

library(ggplot2)
library(maps)

world_map <- map_data("world")

top_countries<-data.frame(top_countries)

# match the names
top_countries$region <- top_countries$country
top_countries$region[top_countries$region == "United States"] <- "USA"
top_countries$region[top_countries$region == "United Kingdom"] <- "UK"
top_countries$region[top_countries$region == "South Korea"] <- "South Korea"

# Merge with map data
map_data_merged <- world_map %>%
  left_join(top_countries, by = "region")

ggplot(map_data_merged, aes(x = long, y = lat, group = group, fill = n)) +
  geom_polygon(color = "white", linewidth = 0.1) +
  scale_fill_gradient(low = "lightyellow", high = "darkred", 
                      na.value = "lightgray",
                      name = "Number of Shows") +
  labs(title = "Top 10 Countries by Netflix Show Production",
       subtitle = "Frequency of shows produced by country") +
  theme_minimal() +
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank())


library(shiny)
library(ggplot2)
library(tidyverse)
library(readxl)
library(plotly)

food <- read_csv("Data.csv", na = "")

# removing unnecessary columns
food <- food[,-c(1,3,4,8:11,20:22)]

# renaming column
names(food)[3] <- "year"

supplychain <- c("Pre-Harvest","Harvest","Grading","Storage",
                 "Transport","Traders","Processing","Packaging",
                 "Distribution","Wholesale","Retail","Consumer",
                 "Export")

# typo correction in fsc_location1
food$fsc_location1 <- ifelse(food$fsc_location1 == "Havest","Harvest",food$fsc_location1) 


#food_new <- food %>% filter(!(is.na(fsc_location1)))
food_new <- food %>% filter(fsc_location1 %in% supplychain)

# line breaks
linebreaks <- function(n){HTML(strrep(br(), n))}

check_box <- c("All",unique(food_new$fsc_location1))
check_box2 <- c("All",unique(food_new$country))


ui <- fluidPage(
  titlePanel("Gaspillage alimentaire mondial"),
  
  sidebarLayout(
    sidebarPanel(
        sliderInput("year", "Sélectionnez un interval d'années", value = c(2010,2015),
                    min = min(food_new$year),max = max(food_new$year)),
        checkboxGroupInput("valuechain", "Sélectionner un poste",check_box, selected = "All"),
        checkboxGroupInput("country", "Sélectionner un pays",check_box2, selected = "All"),
    ),
    
    
mainPanel(
  tabsetPanel(type= "tabs",
              tabPanel("Box plot", linebreaks(3),
                       plotlyOutput("box_plot", width = "100%"),linebreaks(1),
                       "Data source : FAO"),
              tabPanel("Data table", dataTableOutput("fooddata"))
              )
          )
        )
      )

###test

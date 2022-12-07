library(plotly)
library("shiny")
library("dplyr")
library("plotly")
library(shinythemes)

climate_df <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

introduction_page <- tabPanel(
  "Introduction",
  h2("Introduction"),
  p("Greenhouse gas emissions are an important topic to address climate change.Over the span of the last two decades, GHG emissions from various countries have become increasingly
     worse."),
  hr(),
  p("This analysis takes a look at trends in CO2 and GHG emissions, as well as trends in populations and oil consumption across several different countries. Three questions
    we address in this analysis are: "),
  em("1.) What is the average CO2 output in the US for the past ~10 years (since 2011)?"), br(),
  em("2.) Which countries have the highest CO2 consumption based emissions per capita in 2018?"), br(),
  em("3.) How has the CO2 emissions changed in high income countries vs low income countries in the past ~20 years (2000-2018)?"),
  hr(),
  p("Based on our analysis, we found that: "),
  textOutput("av_co2"),
  textOutput("highest_co2_emissions"),
  textOutput("change_CO2_emissions")
  
)

inputs <- sidebarPanel(
  selectInput(
    inputId = "some_input",
    label = "y-label",
    choices = list("Population" = "population", "CO2 per capita" = "co2_per_capita","CO2 per GDP" = "co2_per_gdp", "GHG per capita" = "ghg_per_capita","Oil per capita" = "oil_co2_per_capita"),
  ),
  selectInput(
    inputId = "country",
    label = "Countries",
    choices = list("Afghanistan", "United States", "China", "Russia", "New Zealand", "Finland", "Singapore")
  )
)


interactive_page <- tabPanel(
  "Interactive Plot", 
  sidebarLayout(inputs, 
                mainPanel(plotlyOutput("plot"))),
  p("This is a interactive plot that shows trends in population, CO2 emissions, GHG emissions, and oil consumption for various selected countries from 2000-2021.
    From these plots, we can see that as population increases over the two decades, so does CO2 emissions, GHG emissions, and oil comsumption for some countries (China and Russia). 
    However, some countries, such as the United States, Finland, and New Zealand seem to show a decrease in CO2 emissions per capita over the last two decades.
    Based on previous analysis, the country with the highest CO2 consumption based emissions per capita in 2021 was Singapore.")
)

ui <- navbarPage("Analyzing trends in CO2 emissions",
                 theme = shinytheme("darkly"),            
                 introduction_page,
                 interactive_page
)
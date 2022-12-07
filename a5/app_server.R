# Define server logic required to draw a histogram
library(plotly)
library(ggplot2)
library(dplyr)


climate_df <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

server <- function(input, output) {
  
  # What is the average CO2 output in the US for the past ~10 years (since 2011)?
  output$av_co2 <- renderText({
    avg_co2_output <- climate_df %>%
      filter(year >= 2011 & country == "United States") %>%
      summarise(avg_co2_output = mean(co2, na.rm = TRUE)) %>%
      pull(avg_co2_output)
    
    
    sentence <- paste0("The average CO2 output in the United States for the past decade has been ", avg_co2_output, " million tonnes/year.")
    return(sentence)
  })
  
  # Which countries have the highest CO2 consumption based emissions per capita in 2018?
  output$highest_co2_emissions <- renderText({
    country_highest_co2_emissions <- climate_df %>%
      filter(year == 2018) %>%
      group_by(country) %>%
      summarise(high_avg_co2_consumption = mean(consumption_co2_per_capita, na.rm = TRUE)) %>%
      filter(high_avg_co2_consumption == max(high_avg_co2_consumption, na.rm = TRUE)) %>%
      pull(country)
    
    sentence1 <- paste0("The country with the highest CO2 consumption based emissions per capita in 2021 was ", country_highest_co2_emissions, ".")
    return(sentence1)
  })
  
  # How has the CO2 emissions changed in high income countries vs low income countries in the past ~20 years (2000-2018)?
  
  output$change_CO2_emissions <- renderText ({
    co2_emissions_high_income_2000 <- climate_df %>%
      filter(year == 2000 & country == "High-income countries") %>%
      summarise(avg_co2_emissions_HI_2000 = mean(co2_per_capita))
    # avg CO2 emissions in high income countries in 2018
    co2_emissions_high_income_2018 <- climate_df %>%
      filter(year == 2018 & country == "High-income countries") %>%
      summarise(avg_co2_emissions_HI_2018 = mean(co2_per_capita))
    # avg CO2 emissions in low income countries in 2000
    co2_emissions_low_income_2000 <- climate_df %>%
      filter(year == 2000 & country == "Low-income countries") %>%
      summarise(avg_co2_emissions_LO_2000 = mean(co2_per_capita))
    # avg CO2 emissions in low income countries in 2018
    co2_emissions_low_income_2018 <- climate_df %>%
      filter(year == 2018 & country == "Low-income countries") %>%
      summarise(avg_co2_emissions_LO_2018 = mean(co2_per_capita))
    
    diff_co2_emissions_HI_counties <- co2_emissions_high_income_2018-co2_emissions_high_income_2000
    diff_co2_emissions_LO_countries <- co2_emissions_low_income_2018-co2_emissions_low_income_2000
    
    sentence3 <- paste0("The average change in CO2 emissions per capita in high income countries between 2000-2018 is ", diff_co2_emissions_HI_counties, ".", " The average change in CO2 emissions per capita in low income countries between 2000-2018 is", diff_co2_emissions_LO_countries, ".")
    return(sentence3)
    
  })
  
  output$plot <- renderPlotly({
    # Plot
  p_data <- climate_df %>%
    filter(country == input$country) %>%
    filter(year > 2000)
    
    plot <- ggplot(data = p_data,
                   mapping = aes_string(x = p_data$year, y = input$some_input)) + 
      geom_line() + 
      labs(
        title = paste0("Trends in ", input$some_input, " data for ", input$country),
        x = "Year",
        y = input$some_input
      ) 
    
    
  })
  
}
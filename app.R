## COVID-2019 interactive mapping tool
## Edward Parker, London School of Hygiene & Tropical Medicine (edward.parker@lshtm.ac.uk), February 2020

## includes code adapted from the following sources:
# https://github.com/rstudio/shiny-examples/blob/master/087-crandash/
# https://rviews.rstudio.com/2019/10/09/building-interactive-world-maps-in-shiny/
# https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example
# https://github.com/eparker12/nCoV_tracker

# load required packages
if(!require(magrittr)) install.packages("magrittr", repos = "http://cran.us.r-project.org")
if(!require(rvest)) install.packages("rvest", repos = "http://cran.us.r-project.org")
if(!require(readxl)) install.packages("readxl", repos = "http://cran.us.r-project.org")
if(!require(dplyr)) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!require(maps)) install.packages("maps", repos = "http://cran.us.r-project.org")
if(!require(ggplot2)) install.packages("ggplot2", repos = "http://cran.us.r-project.org")
if(!require(reshape2)) install.packages("reshape2", repos = "http://cran.us.r-project.org")
if(!require(ggiraph)) install.packages("ggiraph", repos = "http://cran.us.r-project.org")
if(!require(RColorBrewer)) install.packages("RColorBrewer", repos = "http://cran.us.r-project.org")
if(!require(leaflet)) install.packages("leaflet", repos = "http://cran.us.r-project.org")
if(!require(plotly)) install.packages("plotly", repos = "http://cran.us.r-project.org")
if(!require(geojsonio)) install.packages("geojsonio", repos = "http://cran.us.r-project.org")
if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")
if(!require(shinyWidgets)) install.packages("shinyWidgets", repos = "http://cran.us.r-project.org")
if(!require(shinydashboard)) install.packages("shinydashboard", repos = "http://cran.us.r-project.org")
if(!require(shinythemes)) install.packages("shinythemes", repos = "http://cran.us.r-project.org")

#### MAKE DUMMY DATA
data <- 1:100 %>% 
  as.data.frame() %>%
  dplyr::rename(id = ".")

data$lat <- runif(100)*20
data$lon <- runif(100)*20
data$date <- seq(as.Date("2010/1/1"), by = "month", length.out = 100)

# UI ===========================================================================
ui <- navbarPage(theme = shinytheme("journal"), collapsible = TRUE,
                 "Zimbabwe", id="nav",
                 
                 tabPanel("County Level",
                          div(class="outer",
                              tags$head(includeCSS("styles.css")),
                              leafletOutput("map_1", width="100%", height="100%"),
                              
                              absolutePanel(id = "controls", class = "panel panel-default",
                                            top = 150, left = 20, width = 250, fixed=TRUE,
                                            draggable = TRUE, height = "auto",
                                            
                                           h3("Title"),
          
                                           sliderInput("date_range",
                                                        label = h5("Select mapping date"),
                                                        min = as.Date("2010-01-01","%Y-%m-%d"),
                                                        max = as.Date("2020-01-01","%Y-%m-%d"),
                                                        value = c(as.Date("2010-01-01","%Y-%m-%d"), 
                                                                  as.Date("2020-01-01","%Y-%m-%d")))
                              )
                        
                              
                          )
                 ),
                 
                 tabPanel("Ward Level",
                          
       
                 )
                 
)

# SERVER =======================================================================
server = function(input, output) {
  
  #### Reactive expressions to subset data
  data_filtered <- reactive({
    data[data$date >= input$date_range[1] & data$date <= input$date_range[2],]
  })
  
  #### Outputs
  output$map_1 <- renderLeaflet({
    
    leaflet() %>%
      addTiles() %>%
      addCircles(data=data_filtered(), lat=~lat, lng=~lon)
    
  })
  
}

shinyApp(ui, server)


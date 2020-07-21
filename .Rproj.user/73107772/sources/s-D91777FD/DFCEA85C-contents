#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Résultats municipales 2020 Toulouse"),

    # Sidebar with a slider input for number of bins
    fluidRow(
        column(8,  leafletOutput("carte", height = 900)),
        column(4, plotOutput("absarchipel"),
                  plotOutput("absmoudenc"))
    ),
    HTML("Source : <a>https://data.toulouse-metropole.fr</a><br>
<a href= 'https://data.toulouse-metropole.fr/explore/dataset/elections-municipales-et-communautaires-2020-2eme-tour-toulouse-resultats/information/'>Données</a><br>
<a href='https://data.toulouse-metropole.fr/explore/dataset/elections-2020-decoupage-bureaux-de-vote-toulouse/information/'>Contours des bureaux de vote</a>")

))





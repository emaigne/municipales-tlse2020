#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$carte <- renderLeaflet({
        
        m <- leaflet(bureau_map) %>%
            addProviderTiles("Stamen.Terrain") %>% 
            addPolygons(fillColor = ~pal(pctMoudenc_exprimes), 
                         color="black", 
                         weight = 0.5, 
                         opacity = 1, 
                         fillOpacity=0.9,
                         highlight = highlightOptions(weight = 4,
                                                      fillOpacity = 1,
                                                      bringToFront = TRUE),
                         label = bureau_map$labelsmap,
                         labelOptions = labelOptions(
                             style = list("font-weight" = "normal", padding = "3px 8px"),
                             textsize = "10px",
                             direction = "auto")) %>% 
            addLegend(pal = pal, values = ~pctMoudenc_exprimes, opacity = 0.7, title = "% de votes pour LR (en % de votes exprimés)",
                      position = "bottomright")
        
        # if(input$indicateur=="AB") {
        #     m <- m %>% addPolygons(fillColor = ~pal(pctAbstention), 
        #                            color="black", 
        #                            weight = 0.5, 
        #                            opacity = 1, 
        #                            fillOpacity=0.9,
        #                            highlight = highlightOptions(weight = 4,
        #                                                         fillOpacity = 1,
        #                                                         bringToFront = TRUE),
        #                            label = bureau_map$labelsmap,
        #                            labelOptions = labelOptions(
        #                                style = list("font-weight" = "normal", padding = "3px 8px"),
        #                                textsize = "8px",
        #                                direction = "auto")) %>% 
        #         addLegend(pal = pal, values = ~pctAbstention, opacity = 0.7, title = NULL,
        #                   position = "bottomright")
        # }
        # if(input$indicateur=="LR") {
        #     m <- m %>% addPolygons(fillColor = ~pal(pctMoudenc_exprimes), 
        #                            color="black", 
        #                            weight = 0.5, 
        #                            opacity = 1, 
        #                            fillOpacity=0.9,
        #                            highlight = highlightOptions(weight = 4,
        #                                                         fillOpacity = 1,
        #                                                         bringToFront = TRUE),
        #                            label = bureau_map$labelsmap,
        #                            labelOptions = labelOptions(
        #                                style = list("font-weight" = "normal", padding = "3px 8px"),
        #                                textsize = "8px",
        #                                direction = "auto")) %>% 
        #         addLegend(pal = pal, values = ~pctMoudenc_exprimes, opacity = 0.7, title = NULL,
        #                   position = "bottomright")
        # }
        # if(input$indicateur=="AC") {
        #     m <- m %>% addPolygons(fillColor = ~pal(pctArchipel_exprimes), 
        #                            color="black", 
        #                            weight = 0.5, 
        #                            opacity = 1, 
        #                            fillOpacity=0.9,
        #                            highlight = highlightOptions(weight = 4,
        #                                                         fillOpacity = 1,
        #                                                         bringToFront = TRUE),
        #                            label = bureau_map$labelsmap,
        #                            labelOptions = labelOptions(
        #                                style = list("font-weight" = "normal", padding = "3px 8px"),
        #                                textsize = "8px",
        #                                direction = "auto")) %>% 
        #         addLegend(pal = pal, values = ~pctArchipel_exprimes, opacity = 0.7, title = NULL,
        #                                                                  position = "bottomright")
        # }
       
        m 
        

    })

    output$absarchipel <- renderPlot({
        ggplot(votes_bureaux, aes(x=pctAbstention, y=pctArchipel_exprimes)) + geom_point() +
            labs(title="% votes pour Archipel en fonction de l'abstention", 
                 x="% abstention", y="% votes exprimés pour Archipel Citoyen")
    })
    
    output$absmoudenc <- renderPlot({
        ggplot(votes_bureaux, aes(x=pctMoudenc_exprimes, y=pctAbstention)) + geom_point() +
        labs(title="% votes pour LR en fonction de l'abstention", 
             x="% abstention", y="% votes exprimés pour Les Républicains")
    })
})

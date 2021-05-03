server <- function(input, output, session) {
  
  plot2 <- reactive(if("All" %in% input$valuechain){
    food_new
  }else{food_new %>% filter(fsc_location1 %in% input$valuechain)
  }
  )
  
  plot1 <- reactive(plot2() %>% filter(year >= input$year[1] & year <= input$year[2]))
  
  output$box_plot <- renderPlotly(
    ggplotly(plot1() %>% ggplot(aes(fsc_location1,loss_per_clean,
                                    col=fsc_location1,fill=fsc_location1)) +
               geom_boxplot(alpha=0.5) +
               xlab("") + 
               ylab("Percentage loss (%)") +
               theme(axis.text.x=element_text(angle = 45)) +
               theme(legend.title = element_blank()) +
               labs(caption = "Data source: http://www.fao.org/platform-food-loss-waste/flw-data/en/"))
  )
  
  output$fooddata <- renderDataTable(food_new, options = list(pageLength = 10))
}
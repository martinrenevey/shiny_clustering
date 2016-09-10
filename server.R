library(shiny)
library(haven)
library(dplyr)
library(tidyr)
library(ggplot2)
library(cluster)
library(plotly)

devoir2_q2 <- read_sas("./data/devoir2_q2_h2016.sas7bdat")
colnames(devoir2_q2) <- c("price", "fresh", "local", "takeaway")

shinyServer(function(input, output, session) {
        
        observe({
                if(length(input$vars) < 1) {
                        updateCheckboxGroupInput(session, "vars", selected = "price")
                }
        })
        
        hc <- reactive({
                devoir2_q2 %>%
                        select(one_of(input$vars)) %>%
                        dist(input$dist) %>%
                        hclust(input$method)
        })
        
        output$dendrogram <- renderPlot({
                plot(hc(), hang = -1, sub = "Observations"); rect.hclust(hc(), k = input$nclust)
        })
        
        output$table <- renderTable({
                cluster <- cutree(hc(), k = input$nclust)
                bind_cols(devoir2_q2, data.frame(cluster = cluster)) %>%
                        group_by(cluster) %>%
                        summarise_each(funs(mean)) %>%
                        select(-cluster)
        })
        
        output$boxplot <- renderPlotly({
                cluster <- cutree(hc(), k = input$nclust)
                gg <- bind_cols(devoir2_q2, data.frame(cluster = cluster)) %>%
                        gather(Dimension, Score, price:takeaway) %>%
                        ggplot(aes(factor(Dimension), Score, fill = factor(Dimension))) +
                        geom_boxplot() +
                        theme_bw() +
                        labs(x = "", y = "", title = "") +
                        theme(legend.position = "bottom", axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
                        scale_fill_discrete("Dimension") +
                        facet_grid(. ~ cluster)
                ggplotly(gg)
        })
})

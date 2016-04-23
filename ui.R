library(shiny)
library(plotly)

shinyUI(fluidPage(
        
        titlePanel("Clustering"),
        
        h3("Overview"),
        p('This application allows the user to personnalize a set of options in order to perform
          a hierarchical clustering over the survey answers from a sample of 200 grocery store customers.
          A factor analysis has been performed on the original answers and 4 satisfaction factors have been calculated
          (the general prices and discounts, the product freshness, the availability of local product, and the take-away possibilities).
          The data come from a practical exercise in the course "Applied multivariate analysis" from HEC Montréal.'
          ),
        
        sidebarLayout(
        
                sidebarPanel(

                        h3("Clusering options"),
                        
                        checkboxGroupInput("vars",
                                           "Variables",
                                           c("Price" = "price",
                                             "Fresh" = "fresh",
                                             "Local" = "local",
                                             "Take-Away" = "takeaway"),
                                            selected = c("price", "fresh", "local", "takeaway")),
                        
                        radioButtons("dist",
                                     "Distance",
                                     c("Euclidean" = "euclidean",
                                       "Maximum" = "maximum",
                                       "Manhattan" = "manhattan",
                                       "Canberra" = "canberra",
                                       "Binary" = "binary",
                                       "Minkowski" = "minkowski"),
                                      selected = "euclidean"),
                        
                        radioButtons("method",
                                     "Aggregation method",
                                     c("Ward D2" = "ward.D2",
                                       "Ward" = "ward.D",
                                       "Single" = "single",
                                       "Complete" = "complete",
                                       "Average" = "average",
                                       "McQuitty" = "mcquitty",
                                       "Median" = "median",
                                       "Centroid" = "centroid"),
                                      selected = "ward.D2"),
                        
                        numericInput("nclust", 
                                     "Number of clusters", 
                                     value = 3, 
                                     min = 2, 
                                     max = nrow(devoir2_q2), 
                                     step = 1),
                        width = 2),
                
                mainPanel(
                        
                        h3("Results"),
                        
                        h4("Dendrogram"),
                        plotOutput("dendrogram"),
                        
                        fluidRow(column(3,
                                        h4("Summary table (mean)"),
                                        tableOutput("table")),
                                 column(9,
                                        h4("Boxplots"),
                                        plotlyOutput("boxplot"))),
                        width = 10
                        )
                )
        ))
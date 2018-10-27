#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

shinyUI(fluidPage(
    tabsetPanel(
        tabPanel("Price", fluid = TRUE,
                 sidebarLayout(
                     sidebarPanel(
                         h5("Select the features of the diamonds dataset
                            in order to predict the price of the diamond
                            based on two linear models."),
                         numericInput("carat_input", "carat", value = 0.5, 
                                      min = 0.5, max = 5, step = 0.5),
                         numericInput("depth_input", "depth", value = 52, 
                                      min = 55, max = 75, step = 0.5),
                         sliderInput("x_input", "length in mm", value = 0.5, 
                                     min = 0, max = 10, step = 0.5),
                         sliderInput("y_input", "width in mm", value = 0.5, 
                                     min = 0, max = 10, step = 0.5),
                         sliderInput("z_input", "depth in mm", value = 0.5, 
                                     min = 0, max = 10, step = 0.5),
                         checkboxInput("showModel1", "show model 1", value = TRUE),
                         checkboxInput("showModel2", "show model 2", value = TRUE)
                     ),
                     mainPanel(
                         plotOutput("plot1"),
                         h5("Two linear models are built depending on the
                            features of the diamonds dataset."),
                         h5("Model 1 (red line)
                            depends only on the carat input, whereas 
                            model 2 (blue line) is fitted using all the features 
                            available to select. The red/blue points represent 
                            the price predicted by model 1/2 in a logarithmic
                            scale. These prices are printed below."),
                         h5("The test set in which the models are evaluated 
                            is shown as a point plot where the colours
                            indicate the type of cut of each diamond."),
                         h3("predicted diamond price from model 1:"),
                         textOutput("pred1"),
                         h3("predicted diamond price from model 2:"),
                         textOutput("pred2")
                         )
                 )
                 ),
        tabPanel("Error", fluid = TRUE,
                 sidebarLayout(
                     sidebarPanel(
                         h5("The mean absolute error is evaluated for each
                            model. As it should be expected, model 2 
                            has a smaller error as it generalizes better
                            the problem including more features."),
                         h3("MAE model1:"),
                         textOutput("maeModel1"),
                         h3("MAE model2:"),
                         textOutput("maeModel2")
                     ),
                     mainPanel(
                         plotOutput("plot2"),
                         h5("The error distribution of the models is shown
                            as a boxplot in a logarithmic scale. The median
                            for model 2 lies below the one for the simpler 
                            model, which indicates that for most of the test
                            data model 2 predicts more accurately than 
                            model 1.")
                     )
                 )
                 )
    )
))










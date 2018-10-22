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
    titlePanel("Shiny app for predicting diamond prices"),
    sidebarLayout(
        sidebarPanel(
            numericInput("carat_input", "carat", value = 0.5, 
                         min = 0.5, max = 5, 
                         step = 0.5),
            numericInput("depth_input", "depth", value = 52, 
                         min = 55, max = 75, 
                         step = 0.5),
            sliderInput("x_input", "length in mm", value = 0.5, 
                        min = 0, max = 10, 
                        step = 0.5),
            sliderInput("y_input", "width in mm", value = 0.5, 
                        min = 0, max = 10, 
                        step = 0.5),
            sliderInput("z_input", "depth in mm", value = 0.5, 
                        min = 0, max = 10, 
                        step = 0.5),
            checkboxInput("showModel1", "show model 1", value = TRUE),
            checkboxInput("showModel2", "show model 2", value = TRUE)
        ),
        mainPanel(
            plotOutput("plot1"),
            h3("predicted diamond price from model 1: "),
            textOutput("pred1"),
            h3("predicted diamond price from model 2: "),
            textOutput("pred2"),
            h3("MAE model1:"),
            textOutput("maeModel1"),
            h3("MAE model2:"),
            textOutput("maeModel2")
        )
    )
))








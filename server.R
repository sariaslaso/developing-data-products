#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)
library(dplyr)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    diamondsData <- select(diamonds, -contains("color"), -contains("clarity"))
    set.seed(138574)
    inTrain <- createDataPartition(y = diamondsData$price, p = 0.7, 
                                   list = FALSE)
    training <- diamondsData[inTrain, ]
    test <- diamondsData[-inTrain, ]
    
    model1 <- lm(price ~ carat, data = training)
    model2 <- lm(price ~ carat + depth + x + y + z, data = training)
    
    model1Predict <- reactive({
        caratInput <- input$carat_input
        predict(model1, newdata = data.frame(carat = caratInput))
    })
    
    model2Predict <- reactive({
        caratInput <- input$carat_input
        depthInput <- input$depth_input
        xInput <- input$x_input
        yInput <- input$y_input
        zInput <- input$z_input
        predict(model2, newdata = 
                    data.frame(carat = caratInput, depth = depthInput, 
                               x = xInput, y = yInput, z = zInput))
    })
    
    output$plot1 <- renderPlot({
        # a subset of the test set is shown in the plot
        #test_indx <- createDataPartition(y = test$price, p = 0.4, list = FALSE)
        #test_plot <- test[test_indx, ]
        l = length(test$carat)
        
        # model1 predictions for a set of feature values
        model1Vals <- data.frame(carat = seq(min(test$carat), 
                                        max(test$carat), 
                                        length = l))
        model1Vals$price1 <- predict(model1, newdata = model1Vals)
    
        # model2 predictions for a set of feature values
        model2Vals <- data.frame(carat = seq(min(test$carat), 
                                             max(test$carat), 
                                             length = l), 
                                 depth = rep(input$depth_input, l), 
                                 x = rep(input$x_input, l), 
                                 y = rep(input$y_input, l), 
                                 z = rep(input$z_input, l))
        model2Vals$price2 <- predict(model2, newdata = model2Vals)
        
        p <- ggplot(test, aes(x = carat)) + 
            geom_point(aes(y = log10(price), color = cut), 
                       alpha = 0.5, size = 0.75) + 
            geom_point(aes(x = input$carat_input, 
                           y = log10(predict(model1, 
                                             newdata = data.frame(
                                                 carat = input$carat_input)))), 
                       colour = "red") + 
            geom_point(aes(x = input$carat_input, 
                           y = log10(predict(model2, 
                                             data.frame(
                                                 carat = input$carat_input,
                                                 depth = input$depth_input,
                                                 x = input$x_input,
                                                 y = input$y_input,
                                                 z = input$z_input
                                             )))), 
                       colour = "blue") + 
            xlim(0, 3.5) + ylim(2, 4.5) + 
            ggtitle("Price of diamonds as a function of carat in the test set")
        if(input$showModel1) {
            p <- p + geom_line(data = model1Vals, aes(y = log10(price1)), 
                               colour = "red")
        }
        if(input$showModel2) {
            p <- p + geom_line(data = model2Vals, aes(x = carat, 
                                                      y = log10(price2)), 
                               colour = "blue")
        }
        p
    })
    
#    output$plot2({
#        predict1 <- predict(model1, newdata = test)
#        predict2 <- predict(model2, newdata = test)
#        
#        resModel1 <- data.frame(model = 1, 
#                                error = test$price - predict1)
#        resModel2 <- data.frame(model = 2, 
#                                error = test$price - predict2)
#        dataRes <- rbind(resModel1, resModel2)
#        dataRes$model <- factor(dataRes$model, labels = c("1", "2"))
#        
#        fill <- "#7EB047"
#        line <- "#1F3552"
#        
#        p <- ggplot(dataRes, aes(x = model, y = log10(error))) + 
#            geom_boxplot(fill = fill, colour = line, alpha = 0.8)
#        p <- p + scale_y_continuous("Price error in a log scale")
#        p
#    })
    
    output$pred1 <- renderText({
        model1Predict()  
    })
    
    output$pred2 <- renderText({
        model2Predict()
    })
    
    output$maeModel1 <- renderText({
        mean(abs(test$price - predict(model1, newdata = test)))
    })
    
    output$maeModel2 <- renderText({
        mean(abs(test$price - predict(model2, newdata = test)))
    })
    
})
























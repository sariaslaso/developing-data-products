library(caret)
library(dplyr)
library(ggplot2)
#library(plotly)

diamondsData <- select(diamonds, -contains("color"), -contains("clarity"))

set.seed(138574)
inTrain <- createDataPartition(y = diamondsData$price, p = 0.7, list = FALSE)
training <- diamondsData[inTrain, ]
test <- diamondsData[-inTrain, ]

ggplot(training, aes(x = carat, y = log10(price))) + 
    geom_point(aes(color = cut), size = 0.75, alpha = 0.5) + 
    geom_smooth(color = "red", size = 0.75)

model1 <- lm(price ~ carat, data = training)
model2 <- lm(price ~ carat + depth + x + y + z, data = training)

# use a fraction of the test set to show in the plot with the model
test_indx <- createDataPartition(y = test$price, p = 0.4, list = FALSE)
test_plot <- test[test_indx, ]

# model1 predictions
model1Pred <- data.frame(carat = seq(min(test$carat), max(test$carat), 
                                length = length(test$carat)))
model1Pred$price1 <- predict(model1, newdata = model1Pred)

# model2 predictions
l = length(test$carat)
indx = 3
model2Pred <- data.frame(carat = seq(min(test$carat), max(test$carat), 
                                      length = l), 
                          depth = rep(test$depth[indx], l), 
                          x = rep(test$x[indx], l), 
                          y = rep(test$y[indx], l), 
                          z = rep(test$z[indx], l)
                          )
model2Pred$price2 <- predict(model2, model2Pred)

p <- ggplot(test, aes(x = carat)) + 
    geom_point(aes(y = log10(price), color = cut), 
               alpha = 0.5, size = 0.75)
p <- p + geom_line(data = model1Pred, aes(y = log10(price1)), colour = "red")
p <- p + geom_line(data = model2Pred, 
                   aes(x = carat, y = log10(price2)), 
                   colour = "blue")
p <- p + geom_point(aes(x = 2.5, 
                        y = log10(predict(model1, newdata = data.frame(carat = 2.5)))), 
                    colour = "red")
p <- p + geom_point(aes(x = 2.5, 
                        y = log10(predict(model2, 
                                          data.frame(
                                              carat = 2.5, 
                                              depth = test$depth[indx], 
                                              x = test$x[indx], 
                                              y = test$y[indx], 
                                              z = test$z[indx])))), 
                    colour = "blue")
p <- p + xlim(0, 3.5) + ylim(2, 4.5)
p + ggtitle("Price of diamonds as a function of carat in the test set")

# mean absolute error
predict1 <- predict(model1, newdata = test)
predict2 <- predict(model2, newdata = test)

# model 1
maeModel1 <- sprintf("MAE: %.1f", mean(abs(test$price - predict1)))
# model 2
maeModel2 <- sprintf("MAE: %.1f", mean(abs(test$price - predict2)))


# error distribution
resModel1 <- data.frame(model = 1, 
                        error = test$price - predict1)
resModel2 <- data.frame(model = 2, 
                        error = test$price - predict2)


dataRes <- rbind(resModel1, resModel2)
dataRes$model <- factor(dataRes$model, labels = c("1", "2"))
textPlot <- data.frame(x = c(1.2, 2.2), y = c(-0.7, -0.7), 
                       labs = c(maeModel1, maeModel2))

fill <- "#4d71bf"
line <- "#1F3552"

p <- ggplot(dataRes, aes(x = model, y = log10(error))) + 
    geom_boxplot(fill = fill, colour = line, alpha = 0.75)
p <- p + scale_y_continuous("Price error in a log scale")
p <- p + geom_text(data = textPlot, aes(x = textPlot$x, y = textPlot$y, 
                       label = textPlot$labs, group = NULL))
p





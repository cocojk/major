# the url: http://ww2.coastal.edu/kingw/statistics/R-tutorials/logistic.html

# library("MASS")
# data(menarche)
# write.table(menarche, file="data_1.txt")


# clear memory
rm(list=ls(all=TRUE)) 


menarche <- read.table("data_1.txt", header = TRUE)
summary(menarche)
str(menarche)
menarche[1:3, 1:ncol(menarche)]

plot(Menarche/Total ~ Age, data=menarche)

glm.out = glm(cbind(Menarche, Total-Menarche) ~ Age, family=binomial(logit), data=menarche)

plot(Menarche/Total ~ Age, data=menarche)
lines(menarche$Age, glm.out$fitted, type="l", col="red")
title(main="Menarche Data with Fitted Logistic Regression Line")

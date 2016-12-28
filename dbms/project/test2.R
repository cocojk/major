# http://www.statmethods.net/advstats/cluster.html
mydata <- read.table("E:/git/major/datamining/Chapter14_clustering/R_clustering/data_1.txt", header = TRUE)

# Prepare Data
mydata <- na.omit(mydata) # listwise deletion of missing
mydata <- scale(mydata) # standardize variables
c <- apply(mydata,2,var)
a <- sum(apply(mydata,2,var))
b <- nrow(mydata)-1
wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var))
cluster <- kmeans(mydata,2)
summary(cluster)
for (i in 2:15) wss[i] <- sum(kmeans(mydata, centers=i)$withinss)
for (i in 2:15) f[i] <- sum(kmeans(mydata, centers=i)$withinss)
plot(1:15, wss, type="b", xlab="Number of Clusters",ylab="Within groups sum of squares")

#install.packages("dplyr")
library(dplyr)

set.seed(2014)
centers <- data.frame(cluster=factor(1:3), size=c(100, 150, 50), x1=c(5, 0, -3), x2=c(-1, 1, -2))
points <- centers %>% group_by(cluster) %>%
  do(data.frame(x1=rnorm(.$size[1], .$x1[1]),
                x2=rnorm(.$size[1], .$x2[1])))
#install.packages("ggplot2")
library(ggplot2)
ggplot(points, aes(x1, x2, color=cluster)) + geom_point()
points.matrix <- cbind(x1 = points$x1, x2 = points$x2)
kclust <- kmeans(points.matrix, 3)
kclust
detercluster <- 2
for (i in 1:15) detercluster[i] <- sum(kmeans(points.matrix, 
                                              centers=i)$withinss)
detercluster
plot(1:15, detercluster, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")

# K-Means Cluster Analysis
fit <- kmeans(mydata, 3) # 3 cluster solution
str(fit)
fit$cluster

# get cluster means 
aggregate(mydata,by=list(fit$cluster),FUN=mean)
# append cluster assignment
mydata_all <- data.frame(mydata, fit$cluster)



# Ward Hierarchical Clustering
d <- dist(mydata, method = "euclidean") # distance matrix
fit <- hclust(d, method="ward") 
plot(fit) # display dendogram
groups <- cutree(fit, k=3) # cut tree into 5 clusters
# draw dendogram with red borders around the 5 clusters 
rect.hclust(fit, k=3, border="red")


# Ward Hierarchical Clustering with Bootstrapped p values
#install.packages("pvclust")
library(pvclust)
fit <- pvclust(t(mydata), method.hclust="ward",
               method.dist="euclidean")
plot(fit) # dendogram with p values
# add rectangles around groups highly supported by the data
pvrect(fit, alpha=.95)
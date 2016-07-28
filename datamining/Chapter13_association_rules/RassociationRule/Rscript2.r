 
library(KoNLP)
library(arules)
library(arulesViz)
library(tm)
 
msgtxt <- paste(readLines("ElectricCarPredict.txt"),collapse="\n")
#msgtxt <- paste(readLines("output_Hyundai_msg.txt"),collapse="\n")


#msgtxt <- readLines("output_Hyundai_msg.txt")
#ds <- VectorSource(msgtxt)
#corp <- Corpus(ds)
#corp = tm_map(corp,removePunctuation)
#term.matrix <- as.matrix(term.matrix)


 
msgtxt <- gsub("[[:space:]]", " ", msgtxt)
msgtxt.vec <- strsplit(msgtxt, split="\\.")[[1]]

#ahn.vec <- readLines("output_Hyundai_msg.txt")
 
useSejongDic()
mergeUserDic(data.frame(c("´ëÇÑ¹Î±¹"), c("ncn")))

tran <- Map(extractNoun, msgtxt.vec)

tran <- unique(tran)
tran <- sapply(tran, unique)
tran <- sapply(tran, function(x) {Filter(function(y) {
  nchar(y) <= 4 && nchar(y) > 1 && is.hangul(y)}
                                         ,x)} )
tran <- Filter(function(x){length(x) >= 2}, tran)
names(tran) <- paste("Tr", 1:length(tran), sep="")
wordtran <- as(tran, "transactions")
 
ares <- apriori(wordtran, parameter=list(minlen=2,supp=0.02, conf=0.9))
 
# remove subsets 
ares.sorted <- sort(ares, by="lift")
subset.matrix <- is.subset(ares.sorted, ares.sorted)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant <- colSums(subset.matrix, na.rm=T) >= 1
which(redundant)
ares.pruned <- ares.sorted[!redundant]


#for visualization
#https://cran.r-project.org/web/packages/arulesViz/vignettes/arulesViz.pdf
# rules of lift > 25
qual <- ares.pruned@quality
ares.pruned.sub <- ares.pruned[qual$lift > 25]          
plot(ares.pruned.sub, method="graph", control=list(type="items"))
plot(ares.pruned.sub, method="paracoord", control=list(reorder=TRUE))

quality(ares.pruned) 
plot(ares.pruned.sub, method="matrix")
plot(ares.pruned.sub, method="grouped")
plot(ares.pruned.sub, method="grouped",control=list(type="itemsets"))

write(ares.pruned.sub)

 
#ploting  
plot(ares.pruned, method="group") 
plot(ares.pruned, method="graph") 
plot(ares.pruned, method="graph", control=list(type="items")) 
plot(ares.pruned, method="paracoord", control=list(reorder=TRUE))
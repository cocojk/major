library(tm)

msgtxt <- readLines("output_Hyundai_msg.txt")
ds <- VectorSource(msgtxt)
corp <- Corpus(ds)
corp = tm_map(corp,removePunctuation)

# remove numbers
corp <- tm_map(corp, removeNumbers)

# lower
corp <- tm_map(corp, tolower)

# remove stopwords
# keep "r" by removing it from stopwords
myStopwords <- c(stopwords('english'), "available", "via", "my", "the")
idx <- which(myStopwords == "it")
myStopwords <- myStopwords[-idx]
corp <- tm_map(corp, removeWords, myStopwords)

#myDtm <- TermDocumentMatrix(corp, control = list(minWordLength = 1))
#m <- as.matrix(myDtm)
#which( rownames(m) == "the" )


#In many cases, words need to be stemmed to retrieve their radicals.
#For instance, "example" and "examples" are both stemmed to "exampl".
#However, after that, one may want to complete the stems to their original forms, so that the words would look "normal".

dictCorpus <- corp
# stem words in a text document with the snowball stemmers,
# which requires packages Snowball, RWeka, rJava, RWekajars
myCorpus <- tm_map(corp, stemDocument)
# inspect the first three ``documents"
inspect(myCorpus[1:3])

# stem completion
myCorpus <- tm_map(myCorpus, stemCompletion, dictionary=dictCorpus)

#Print the first three documents in the built corpus.
inspect(myCorpus[1:3])


#Building a Document-Term Matrix
myDtm <- TermDocumentMatrix(myCorpus, control = list(minWordLength = 1))
#myDtm <- TermDocumentMatrix(corp, control = list(minWordLength = 1))

inspect(myDtm[266:270,31:40])



findFreqTerms(myDtm, lowfreq=10)
# which words are associated with 'kia'?
# 0.30 is a lower correlation limit
findAssocs(myDtm, 'kia', 0.30)


library(wordcloud)
m <- as.matrix(myDtm)

# calculate the frequency of words
v <- sort(rowSums(m), decreasing=TRUE)
myNames <- names(v)
#k <- which(names(v)=="kia")
#myNames[k] <- "mining"
d <- data.frame(word=myNames, freq=v)
wordcloud(d$word, d$freq, min.freq=3)


# https://cran.r-project.org/doc/contrib/Zhao_R_and_data_mining.pdf
#############################################

wordtran <- as(m, "transactions")
ares <- apriori(wordtran, parameter=list(minlen=2,supp=0.01, conf=0.5))

# remove subsets
ares.sorted <- sort(ares, by="lift")
subset.matrix <- is.subset(ares.sorted, ares.sorted)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant <- colSums(subset.matrix, na.rm=T) >= 1
which(redundant)
ares.pruned <- ares.sorted[!redundant]
write(ares.pruned)


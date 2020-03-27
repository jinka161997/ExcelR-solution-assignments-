library(rvest)
library(XML)
library(magrittr)
library(tm)
library(lubridate)
library(reshape2)
library(ggplot2)
library(scales)
library(devtools)
# Amazon Reviews #############################
aurl <- "https://www.amazon.in/product-reviews/B073Q5R6VR/ref=cm_cr_getr_d_paging_btm_next_3?pageNumber=3"
amazon_reviews <- NULL
for (i in 1:10){       ## for 1 to 10 pages
  murl <- read_html(as.character(paste(aurl,i,sep="=")))    ## aurl and i for the page number in amazon review
  rev <- murl %>%
    html_nodes(".review-text") %>%
    html_text()
  amazon_reviews <- c(amazon_reviews,rev)
}
length(amazon_reviews)  ## 100

write.table(amazon_reviews,"Macbook.txt",row.names = F)

Macbook_Lap <- read.delim('Macbook.TXT')
str(Macbook_Lap)
View(Macbook_Lap)

# Build Corpus and DTM/TDM
library(tm)
corpus <- Macbook_Lap[-1,]
head(corpus)
class(corpus)
corpus <- Corpus(VectorSource(corpus))
inspect(corpus[1:5])
# Clean the text 
corpus <- tm_map(corpus,tolower)
inspect(corpus[1:5])
corpus <- tm_map(corpus,removePunctuation)
inspect(corpus[1:5])
corpus <- tm_map(corpus,removeNumbers)
inspect(corpus[1:5])
corpus_clean<-tm_map(corpus,stripWhitespace)
inspect(corpus[1:5])
cleanset<-tm_map(corpus,removeWords, stopwords('english'))
inspect(cleanset[1:5])
removeURL <- function(x) gsub('http[[:alnum:]]*','',x)
cleanset <- tm_map(cleanset, content_transformer(removeURL))
inspect(cleanset[1:5])
cleanset<-tm_map(cleanset,removeWords, c('laptop','can','unless','will'))
# Since the word Laptop,can, will, unless is used more, this can be removed as we are 
# mining the tweets for this laptop only.Also the word "Can" is common english word.
# we can pull back the word "can"  if needed.


cleanset <- tm_map(cleanset, gsub,pattern = 'computer', replacement = 'machine')
# the barplot pulls both Computer and Machine as separate words. this should be 
# counted as one as both holds the same synonym.

inspect(cleanset[1:5])
cleanset <- tm_map(cleanset,stripWhitespace)
inspect(cleanset[1:5])
#Term Document Matrix :
# Convert the unstructured data to structured data :
tdm <- TermDocumentMatrix(cleanset)
tdm
# the terms indicate that there are 701 terms and 99 documents in this TDM
# Sparsity is 87% which indicates that there are lots of zero values.
tdm <- as.matrix(tdm)
tdm[1:10,1:20]
# Bar Plot 

w <- rowSums(tdm)  # provides the no of times a particular word has been used.
w <- subset(w, w>= 25) # Pull words that were used more than 25 times.
barplot(w, las = 2, col = rainbow(50))
# the word apple as the highest frequency. This implies
# that Macbook has got more reviews about the company and its life

# Word Cloud :
library(wordcloud)
w <- sort(rowSums(tdm), decreasing = TRUE) # Sort words in decreasing order.
set.seed(123)
wordcloud(words = names(w), freq = w, 
          max.words = 250,random.order = F,
          min.freq =  3, 
          colors = brewer.pal(8, 'Dark2'),
          scale = c(5,0.3),
          rot.per = 0.3)
library(wordcloud2)
w <- data.frame(names(w),w)
colnames(w) <- c('word','freq')
wordcloud2(w,size = 0.5, shape = 'triangle', rotateRatio = 0.5, minSize = 2)

# Sentiment Analysis for tweets:
library(syuzhet)
library(lubridate)
library(ggplot2)
library(scales)
library(reshape2)
library(dplyr)

# install.packages("syuzhet")

# Read File 
Amzn_reviews <- read.delim('Macbook.TXT')
reviews <- as.character(Amzn_reviews[-1,])
class(reviews)
# Obtain Sentiment scores 
s <- get_nrc_sentiment(reviews)
head(s)
reviews[4]
# "Pros:1. Light weight and super fast response time2. Highly optimize which avoids any kind of process lag.3. Beautiful looks and feels like a prime product"
# on tweet 4, you have 2 for anger, 1 work for disgust, fear and surprise, 2 for sadness, 3 for trust , 
# 4 words for negative and 5 positive.
get_nrc_sentiment('Love')
# Love has one Joy and one positive 
get_nrc_sentiment('glaring') #1 Anger and 1 Negavite
# It worked only for a year.


# barplot 

barplot(colSums(s), las = 2.5, col = rainbow(10),
        ylab = 'Count',main= 'Sentiment scores for Amazon Reviews
        -Macbook Air')

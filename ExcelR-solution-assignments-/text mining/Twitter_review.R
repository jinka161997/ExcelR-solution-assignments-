library(tm)
library(lubridate)
library(reshape2)
library(ggplot2)
library(scales)
library(devtools)
library(ROAuth)
library(twitteR)
library(base64enc)
library(httpuv)
library(wordcloud)
library(wordcloud2)
library(syuzhet)


cred <- OAuthFactory$new(consumerKey='BagGgBbanzbdpPNNp8Uy6TQBP', # Consumer Key (API Key)
                         consumerSecret='pFxap1Jzc1fClDQ9psLNU3RKSQ5FvS2PhJz8E2R7ix0cawPKfa', #Consumer Secret (API Secret)
                         requestURL='https://api.twitter.com/oauth/request_token', accessURL='https://api.twitter.com/oauth/access_token',                 authURL='https://api.twitter.com/oauth/authorize')

save(cred, file="twitter authentication.Rdata")
load("twitter authentication.Rdata")

#Access Token Secret

setup_twitter_oauth("BagGgBbanzbdpPNNp8Uy6TQBP", # Consumer Key (API Key)
                    "pFxap1Jzc1fClDQ9psLNU3RKSQ5FvS2PhJz8E2R7ix0cawPKfa", #Consumer Secret (API Secret)
                    "1076425245521731584-Ev31ZLB7Cf0idVMqDI8BxiVG2SgRnu",  # Access Token
                    "ZVUw0Z0mFrX7d6sjQxuB08l48JHhmnjmlAm86G2OPG7BS")  #Access Token Secret
#registerTwitterOAuth(cred)

Tweets <- userTimeline('tim_cook', n = 1000,includeRts = T)
TweetsDF <- twListToDF(Tweets)
dim(TweetsDF)
View(TweetsDF)

write.csv(TweetsDF, "Tweets.csv",row.names = F)
getwd()
# handleTweets <- searchTwitter('DataScience', n = 10000)
# Read file
timcook <- read.csv(file.choose())
str(timcook)
# Build Corpus and DTM/TDM
corpus <- timcook$text
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

cleanset <- tm_map(cleanset, gsub,pattern = 'pages', replacement = 'page')
# the barplot pulls both page and pages as separate words. this should be 
# counted as one.

inspect(cleanset[1:5])
cleanset <- tm_map(cleanset,stripWhitespace)
inspect(cleanset[1:5])

# Term Document Matrix : Convert the unstructured data to structured data :
tdm <- TermDocumentMatrix(cleanset)
tdm
# the terms indicate that there are 3340 words and 897 documents(# of tweets) in this TDM
# Sparsity is 100% which indicates that there are lots of zero values.
tdm <- as.matrix(tdm)
tdm[1:10,1:20]
# Bar Plot 

w <- rowSums(tdm)  # provides the no of times a particular word has been used.
w <- subset(w, w>= 25) # Pull words that were used more than 25 times.
barplot(w, las = 2, col = rainbow(50))
# the word applet as the highest frequency. This implies Tim Cook, being an apple CEO, loves to talk more about the product

# Word Cloud :

w <- sort(rowSums(tdm), decreasing = TRUE) # Sort words in decreasing order.
set.seed(123)
wordcloud(words = names(w), freq = w, 
          max.words = 250,random.order = F,
          min.freq =  3, 
          colors = brewer.pal(8, 'Dark2'),
          scale = c(5,0.3),
          rot.per = 0.6)

## Shapecloud

w <- data.frame(names(w),w)
colnames(w) <- c('word','freq')
wordcloud2(w,size = 0.5, shape = 'triangle', rotateRatio = 0.5, minSize = 1)


############ Sentiment Analysis for tweets:

# Read File 
tcdata <- read.csv(file.choose(), header = TRUE)
tweets <- as.character(tcdata$text)
class(tweets)
# Obtain Sentiment scores 
s <- get_nrc_sentiment(tweets)
head(s)
tweets[4]
# "Thrilled to see so much excitement for AirPods Pro all around the world! You're going to love them.
# the above tweet has value 0 for anger, value 0 for Negative 
# and value 1 for positive which reinstates that it has positive emotions in the above statement.
get_nrc_sentiment('pretending')
# Pretend has one value of negative and one value for anger
get_nrc_sentiment('can learn') #1 for positive
# barplot 

barplot(colSums(s), las = 2.5, col = rainbow(10),
        ylab = 'Count',main= 'Sentiment scores for Tim Cook Tweets')

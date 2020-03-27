install.packages("rvest")
library(rvest)
install.packages("XML")
library(XML)
install.packages("magrittr")
library(magrittr)

# amazon rewies #########
aurl<- "https://www.amazon.in/Kindle-10th-Gen-Black-with-front-light/dp/B07FRJTZ4T/ref=sr_1_1?keywords=kindle&qid=1573757741&sr=8-1&th=1"
amazon_reviews<- NULL
for  (i in 1:50){
  murl<- read_html(as.character(paste(aurl,i,sep = "=")))
  rev<- murl %>%
    html_nodes(".review-text")  %>%
    html_text()
  amazon_reviews<- c(amazon_reviews,rev)
}
length(amazon_reviews)
write.table(amazon_reviews,"apple.txt",row.names = F)
str(amazon_reviews)
View(amazon_reviews)

#corpus
install.packages("tm")
library(tm)

# work on file on duplicate data
x<-iconv(amazon_reviews, "UTF-8" )  # unversal text formatting (encoding on data)
x<-Corpus(VectorSource(amazon_reviews))  # colection of entire documents
inspect(x[1])
?iconv

# data cleaning  (tm_map)
x1<-tm_map(x, tolower)  # converting each and every thing into lower cases
inspect(x1[1])

x1<-tm_map(x1, removePunctuation)  # removing punctuations
inspect(x1[1])

x1<-tm_map(x1, removeNumbers)  # removing the numbers
inspect(x1[1])

x1<-tm_map(x1,removeWords, stopwords("english"))
inspect(x1[1])

#remove URL's FROM CORPUS
removeURL<-function(z) gsub("http[[:alnum:)]]*", "",z)  #

x1<-tm_map(x1,content_transformer(removeURL))
inspect(x1[1])

#striping white spaces
x1<-tm_map(x1, stripWhitespace)
inspect(x1[1])

#Term document matrix(terms will be rows and documents will be columns)
# converting unstructred data into structured data using tdm
tdm<-TermDocumentMatrix(x1)
tdm

#converting tdm into a as.maatrix
tdm<-as.matrix(tdm)
tdm[100:110,1:20]

tdm<-as.matrix(tdm)
tdm[90:100,1:20]
View(tdm)

# bar plot
w<-rowSums(tdm) # how many times that perticle word has repeated in the data 
w

w_sub<- subset(w, w>=20)
w_sub

barplot(w_sub)
?barplot

# Term just repeats in all most all documents
x1<-tm_map(x1, removeWords,"kindle")
x1<-tm_map(x1,stripWhitespace)

tdm<-TermDocumentMatrix(x1)
tdm

install.packages("wordcloud2")
library(wordcloud2)

w_small<-subset(w,w >= 30)
w_small
barplot(w_small)

w1<-data.frame(names(w_small), w_small)  #it will take only two one is names and another one is corresponding values given
colnames(w1)<-c("word", "freq")
w1$word<-iconv(w1$word, "UTF-8" )
window()
wordcloud2(w1, size=0.5, shape="circle")
?wordcloud2

wordcloud2(w1, size =0.4, shape = "triangle")

letterCloud(w1,word = "w")

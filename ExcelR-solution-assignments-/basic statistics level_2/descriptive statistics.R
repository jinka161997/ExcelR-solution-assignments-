# given data set in word foramt we should conver first into excel or csv foramt 
# loading data set
book1<-read.csv(file.choose())

# histogram for given data set
hist(Book1$x)

# boxplot for given data set
boxplot(Book1$x)

# mean 
mean(Book1$x)  #0.3327

#variance
var(Book1$x) # 0.02871466

# standard deviation 
sqrt(var(Book1$x))  #0.169454

sqrt(800)
pnorm(50,45,8)
pnorm(10,45,8)
pnorm(30,38,6)
qnorm(540,15,1.96)

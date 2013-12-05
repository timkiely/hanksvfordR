
require(XML)||{
  install.packages("XML", 
                   dependencies = c("Depends","Suggests")
  )
} 

require(ggplot2)||{
  install.packages("ggplot2", 
                   dependencies = c("Depends","Suggests")
  )
} 

#Ford
URL.ford <- "http://en.wikipedia.org/wiki/Harrison_Ford_filmography#Filmography"
dfFord <- readHTMLTable(URL.ford, stringsAsFactors = FALSE)
dfFord <- dfFord[[4]]

ford.awards <- grep("award", tolower(dfFord$Notes))
dfFord$ford.awards <- FALSE
dfFord$ford.awards[ford.awards] <- TRUE

#Hanks
URL.hanks <- "http://en.wikipedia.org/wiki/Tom_Hanks_filmography#Filmography"
dfHanks <- readHTMLTable(URL.hanks, stringsAsFactors = FALSE)
dfHanks <- dfHanks[[2]]

URL.hanks.awards<-"http://en.wikipedia.org/wiki/List_of_awards_and_nominations_received_by_Tom_Hanks"
dfHanks.awards <- readHTMLTable(URL.hanks.awards, stringsAsFactors = FALSE)
compareawards <- c(2,3,5,6,7,8,11)
dfHanks.awards <- dfHanks.awards[compareawards]

df<-data.frame()
dfHanks.awards <- for(i in 1:length(dfHanks.awards)){
  df<-rbind(df,as.data.frame(dfHanks.awards[i])) 
}
orderyear <-order(df[,1])
dfHanks.awards<-df[orderyear,]
dfHanks.awards<-dfHanks.awards[dfHanks.awards[2]!="N/A",]
Hanksawards <- names(table(dfHanks.awards[2]))
hanks.awards <- dfHanks[,2]%in%Hanksawards
dfHanks$hanks.awards <- FALSE
dfHanks$hanks.awards[hanks.awards] <- TRUE


#plot results
require(gridExtra)||{install.packages("gridExtra")} 

Hanks<-qplot(Year, data = dfHanks, geom = "bar", fill = hanks.awards) + ggtitle("Hanks")
Ford<-qplot(Year, data = dfFord, geom = "bar", fill = ford.awards) + ggtitle("Ford")
grid.arrange(Hanks,Ford,ncol=1,nrow=2)

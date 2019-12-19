setwd("C:\\Users\\kapoo\\Desktop")
data<-read.csv("startup_funding.csv")

install.packages("sqldf")
library("sqldf")
install.packages("zoo")
library("zoo")
install.packages("reshape")
library("reshape")
install.packages("dplyr")
library("dplyr")
install.packages("ggplot2")
library("ggplot2")



data$InvestmentType[data$InvestmentType=="SeedFunding"] <- "Seed Funding"
data$InvestmentType[data$InvestmentType=="PrivateEquity"] <- "Private Equity"
data$InvestmentType[data$InvestmentType=="Crowd funding"] <- "Crowd Funding"




loc<-sqldf("select CityLocation,count(*) as freq from data group by CityLocation")
b = barplot(head(sort(table(data$CityLocation), decreasing=T),20),col=rainbow(10,0.5), las=2, ylim=c(0,750),xlim=c(0,10), xlab="City Name", ylab="No Of StartUps")
text(b,head(sort(table(data$CityLocation), decreasing=T),20),head(sort(table(data$CityLocation), decreasing=T),20),srt=90, pos=4)

ind<-sqldf("select IndustryVertical,count(*) as freq from data group by IndustryVertical")
b = barplot(head(sort(table(data$IndustryVertical), decreasing=T),20),col=rainbow(10,0.5), las=2, ylim=c(0,900),xlim=c(0,10), xlab="IndustryVertical", ylab="No Of StartUps")
text(b,head(sort(table(data$CityLocation), decreasing=T),20),head(sort(table(data$CityLocation), decreasing=T),20),srt=90, pos=4)

indtype<-sqldf("select InvestmentType,count(*) as freq from data1 group by InvestmentType")
b = barplot(head(sort(table(data1$InvestmentType), decreasing=T),20),col=rainbow(10,0.5), las=2, ylim=c(0,1400),xlim=c(0,10), xlab="InvestmentType", ylab="No Of StartUps")
text(b,head(sort(table(data1$InvestmentType), decreasing=T),20),head(sort(table(data$InvestmentType), decreasing=T),20),srt=90, pos=4)

investor<-sqldf("select InvestorsName,count(*) as freq from data group by InvestorsName")
b = barplot(head(sort(table(data$InvestorsName), decreasing=T),20),col=rainbow(10,0.5), las=2, ylim=c(0,40),xlim=c(0,10),srt=20, ylab="No Of StartUps")
text(b,head(sort(table(data$InvestorsName), decreasing=T),20),head(sort(table(data$InvestorsName), decreasing=T),20),srt=90, pos=4)

money<-sqldf("select AmountInUSD,count(*) as freq from data group by AmountInUSD order by AmountInUSD")
b = barplot(head(sort(table(data$AmountInUSD), decreasing=T),20),col=rainbow(10,0.5), las=2, ylim=c(0,150),xlim=c(0,10), xlab="City Name", ylab="No Of StartUps")
text(b,head(sort(table(data$AmountInUSD), decreasing=T),20),head(sort(table(data$AmountInUSD), decreasing=T),20),srt=90, pos=4)

moncom<-sqldf("select AmountInUSD,StartupName from data order by AmountInUSD desc")
b = barplot(head(sort(table(data$AmountInUSD), decreasing=T),20),col=rainbow(10,0.5), las=2, ylim=c(0,150),xlim=c(0,10), xlab="City Name", ylab="No Of StartUps")
text(b,head(sort(table(data$AmountInUSD), decreasing=T),20),head(sort(table(data$AmountInUSD), decreasing=T),20),srt=90, pos=4)


data$Date=as.POSIXct(strptime(data$Date,format="%d/%m/%Y")) # converting into date format 
data$Month=as.factor(format(data$Date,"%m"))
data$Year=as.factor(format(data$Date,"%Y"))
data$Monyr=paste(data$Year,data$Month,sep="-")
date1<-sqldf("select year,count(*) as freq from data group by Year")

b = barplot(head(sort(table(data$Year), decreasing=T),20),col=rainbow(10,0.5), las=2, ylim=c(0,1200), xlab="Year", ylab="No Of StartUps")
text(b,head(sort(table(data$Year), decreasing=T),20),head(sort(table(data$Year), decreasing=T),20),srt=90, pos=4)

data$AmountInUSD<-as.integer(gsub(",","",data$AmountInUSD))



temp<- data %>%
  group_by(StartupName)%>%
  summarise(n = n())%>%
  arrange(desc(n)) %>%
  head(n = 10)

head(temp,10)

temp %>%      
  ggplot(aes(x = reorder(StartupName,n) , y =  n )) +
  geom_bar(stat='identity',colour="white", fill = c("red")) +
  labs(x = 'Startup Company', y = 'Number of times Amount Funded', title = 'Company wise Number of times Amount Funded ') +
  coord_flip() + 
  theme_bw()


funag<-sqldf("select StartupName,count(*) from data group by StartupName")
b = barplot(head(sort(table(data$StartupName), decreasing=T),20),col=rainbow(10,0.5), las=2, ylim=c(0,10),xlim=c(0,5), xlab="Startup Names", ylab="No Of StartUps")
text(b,head(sort(table(data$AmountInUSD), decreasing=T),20),head(sort(table(data$AmountInUSD), decreasing=T),20),srt=90, pos=4)




startup2 <-data %>%
  select( InvestorsName , IndustryVertical)%>%
  group_by(InvestorsName ,IndustryVertical)%>%
  summarise(n = n())%>%
  filter(InvestorsName %in% c('Sequoia Capital' ,'Accel Partners','Kalaari Capital','Indian Angel Network','SAIF Partners','Blume Ventures','Undisclosed Investors', 'Ratan Tata','Undisclosed investors','Tiger Global'))%>%
  filter(n>2)


startup3<-data %>%
  select( InvestorsName , InvestmentType)%>%
  group_by(InvestorsName ,InvestmentType)%>%
  summarise(n = n())%>%
  filter(InvestorsName %in% c('Sequoia Capital' ,'Accel Partners','Kalaari Capital','Indian Angel Network','SAIF Partners','Blume Ventures','Undisclosed Investors', 'Ratan Tata','Undisclosed investors','Tiger Global'))

#top 10 cities based on ampunt of fundng


Top10CitiesbyFunding<-data%>%
  filter(CityLocation!="")%>%
  group_by(CityLocation)%>%
  summarise(TotalAmount=sum(AmountInUSD))%>%
  arrange(desc(TotalAmount))












###############	Code to crawl Statewise data of general election from http://eciresults.nic.in	###############

library(XML)
library(stringr)
library(ggplot2)
library(plyr)
setwd("D:/")
names<-c("Constituency","ConstNo","LeadingCandidate", "LeadingParty","TrailingCandidate","TrailingParty","Margin","Status","State")
names(all_data)<-names
#Removing all data
all_data<-all_data[which(is.na(all_data$Status)),]
for(i in 1:29){
#i=2
if(i <10){
url=paste0("http://eciresults.nic.in/statewiseS0",i,".htm")
}else
{
url=paste0("http://eciresults.nic.in/statewiseS",i,".htm")
}
print(url)
tables <- readHTMLTable(url)

data<-data.frame(tables[[1]])
data<-data[(!is.na(data$V8) & data$V1!="Constituency"),]

data$State=gsub(" Result Status","",data.frame(tables[[1]])[14,1])
names<-c("Constituency","ConstNo","LeadingCandidate", "LeadingParty","TrailingCandidate","TrailingParty","Margin","Status","State")
names(data)<-names
all_data<-rbind(all_data,data)
}

for(i in 1:7){

if(i <10){
url=paste0("http://eciresults.nic.in/statewiseU0",i,".htm")
}else
{
url=paste0("http://eciresults.nic.in/statewiseU",i,".htm")
}
print(url)
tables <- readHTMLTable(url)

data<-data.frame(tables[[1]])
data<-data[(!is.na(data$V8) & data$V1!="Constituency"),]
data$State=gsub(" Result Status","",data.frame(tables[[1]])[14,1])

names<-c("Constituency","ConstNo","LeadingCandidate", "LeadingParty","TrailingCandidate","TrailingParty","Margin","Status","State")
names(data)<-names
all_data<-rbind(all_data,data)
}

dim(all_data)
all_data<-all_data[,!(names(all_data) %in% "ConstNo")]
#summary(all_data)
write.csv(all_data,"state_wise_election_result_2014.csv",row.names=FALSE)

#	Example-1
barplot(table(State)[order(-table(State))])

#	Example
png("LeadingParty.png",height=720,width=1280)
l=with(all_data,table(LeadingParty)[order(-table(LeadingParty))])
colr=c("orange","green","blue","cyan","white",rep("grey",length(l)-5))
lb<-barplot(l,col=colr,axes = FALSE, axisnames = FALSE)
text(lb, par("usr")[3], labels = names(l), srt = 90, adj =1, cex = 1,xpd = TRUE)
dev.off()
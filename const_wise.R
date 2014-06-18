###############	Code to crawl Constituencywise data from http://eciresults.nic.in		###############

library(XML)
library(stringr)
library(plyr)
setwd("D:/")

full_data<- full_data[which(is.na(full_data$State)),]
names(full_data)

for(stateup in 1:2){
	if(stateup==1){
		su="S"
		count=29
	}else
	{
		su="U"
		count=7
	}

	for(i in 1:count){
		#i=1
		#su="U"

		if(i <10){
			url=paste0("http://eciresults.nic.in/statewise",su,"0",i,".htm")
		}else
		{
			url=paste0("http://eciresults.nic.in/statewise",su,i,".htm")
		}
		print(url)
		tables <- readHTMLTable(url)
		d<-data.frame(tables[[1]])
		d<-d[(!is.na(d$V8) & d$V1!="Constituency"),]
		nconst=nrow(d)
		state=gsub(" Result Status","",data.frame(tables[[1]])[14,1])
		print(state)
		for(j in 1:nconst){
			#j=1
			if(i <10){
				url=paste0("http://eciresults.nic.in/Constituencywise",su,"0",i,j,".htm")
			}else{
			url=paste0("http://eciresults.nic.in/Constituencywise",su,i,j,".htm")
			}
			print(url)
			#Crawling data from each Constituency
			#
			#
			#	url=paste0("http://eciresults.nic.in/ConstituencywiseU021.htm")
			tables <- readHTMLTable(url)
			data<-data.frame(tables[[1]])
			data<-data[(!is.na(data$V2) & !(data$V2 %in% c("Party",""))),c(1:3)]
			droplevels(data)
			names(data)<-c("Candidate","Party","Votes")
			#summary(data)
			data$State=state
			data$Const=factor(data.frame(tables[[1]])[17,1])
			#full_data<-rbind(all_data,data)
			if(exists(x="full_data")){
				full_data<-rbind(full_data,data)
			}else
			{
				assign("full_data",data,envir=in.env())
			}
			#print(full_data)
			dim(full_data)
		}

	}
}

full_data$winner=0
full_data[1,"winner"]=1
full_data[1:100,c(1,2,3,6)]
for(i in 2:nrow(full_data)){
  if(full_data[i-1,"Votes"] < full_data[i,"Votes"]){
    full_data[i,"winner"]=1
  }
}

full_data
names(full_data)
unique(full_data$State)
dim(full_data)
unique(duplicated(full_data))

full_data<-full_data[!duplicated(full_data),]
full_data$Votes<-as.numeric(full_data$Votes)
write.csv(full_data,"const_wise_election_result_2014.csv",row.names=FALSE)


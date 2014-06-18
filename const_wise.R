###############  Code to crawl Constituencywise data from http://eciresults.nic.in		###############

library(XML)
library(stringr)
library(plyr)

DataPull<- function(su="S", id){
  for(i in id){
    url=paste0("http://eciresults.nic.in/statewise",su,sprintf("%02d", i),".htm")
    print(url)
    
    tables <- readHTMLTable(url)
    d<-data.frame(tables[[1]])
    d<-d[(!is.na(d$V8) & d$V1!="Constituency"),]
    nConst=nrow(d)
    state=gsub(" Result Status","",data.frame(tables[[1]])[14,1])
    print(state)
    for(j in 1:nConst){
      #j=1
      url=paste0("http://eciresults.nic.in/Constituencywise",su,sprintf("%02d", i),j,".htm")
      print(url)
      
      #Crawling data from each Constituency    
      tables <- readHTMLTable(url)
      data<-data.frame(tables[[1]])
      data<-data[(!is.na(data$V2) & !(data$V2 %in% c("Party",""))),c(1:3)]
      droplevels(data)
      names(data)<-c("candidate","party","votes")
      #summary(data)
      data$State=state
      data$Const=factor(data.frame(tables[[1]])[17,1])
      #electionData<-rbind(all_data,data)
      if(exists(x="electionData")){
        electionData<-rbind(electionData,data)
      }else
      {
        electionData=data
      }
      #print(electionData)
      dim(electionData)
    }
    
  }
  return(electionData)
}

electionData=DataPull(su="U", id=1:7)
dim(electionData)
electionData=DataPull(su="S", id=1:5)
electionData=DataPull(su="S", id=6:28)

electionData<-electionData[!duplicated(electionData),]
electionData$votes<-as.numeric(as.character(electionData$votes))

electionData= electionData[order(electionData$State, electionData$Const,-electionData$votes),]
head(electionData)
electionData$const=gsub("^[^-]+-\\s*", "",electionData$Const)
electionData$Const=NULL

electionData$winner=0
electionData[1,"winner"]=1
for(i in 2:nrow(electionData)){
  if(electionData[i-1,"votes"] < electionData[i,"votes"]){
    electionData[i,"winner"]=1
  }
}

names(electionData)
unique(electionData$State)
unique(electionData$const)
dim(electionData)

write.csv(electionData,"const_wise_election_result_2014.csv",row.names=FALSE)
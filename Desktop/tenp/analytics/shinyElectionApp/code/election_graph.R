setwd("D:/work/github/analytics")
library(ggplot2)
#election_result=read.csv(url("https://raw.githubusercontent.com/kuberiitb/analytics/master/const_wise_election_result_2014.csv"))
#summary(election_result)
#names(election_result)
#head(election_result)

#election_result
# "Candidate" "Party"     "Votes"     "State"     "Const"  
bar_plot<-function(state,const){
#	state="Andhra Pradesh"
#	const=""
	if(state!=""){
		statedata=election_result[which(election_result$State==state),]
		summary=with(statedata,aggregate(Votes,by=list(Party),FUN=sum))
		names(summary)<-c("party","votes")
		partySorted=summary[order(-summary$votes),]
	
		if(nrow(partySorted)>=10){
			levels(partySorted$party)<-c(levels(partySorted$party),"Others")
			partySorted$party[11]="Others"
			partySorted$votes[11]=sum(partySorted$votes[11:nrow(partySorted)])
			partySorted=partySorted[1:11,]
			factor(partySorted$party)	
		}
	}
	ggplot(partySorted,aes(x=reorder(party,votes), y=votes))+geom_bar(stat="identity",fill="blue",colour="black")+ coord_flip() +
		ggtitle(paste("Vote distribution among parties in",state)) +
		geom_text(aes(y=votes/2,label=votes),size=3,colour="green") +
		scale_y_continuous(breaks=seq(from=0,to=max(partySorted$votes), by=floor(max(partySorted$votes)/5))) +
		labs(y="Votes",x="Party")		
}

bar_plot(state=names(table(election_result$State)[32]))

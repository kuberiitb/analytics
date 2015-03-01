library(ggplot2)
library(shiny)

election_result=read.csv(url("https://raw.githubusercontent.com/kuberiitb/analytics/master/const_wise_election_result_2014.csv"))

shinyServer(function(input, output){
  passData <- reactive({
    if(input$state!="All"){
      statedata <- election_result[which(election_result$State %in% input$state),]
    }else{
      statedata <- election_result
    }
    
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
    partySorted$percent=ifelse(partySorted$votes/sum(partySorted$votes)>=0.02,paste0(formatC(partySorted$votes/sum(partySorted$votes)*100,digits=2,format="f"),"%"),"")
    partySorted$pos=ifelse(partySorted$votes/sum(partySorted$votes)>=0.02,partySorted$votes/2,0)
    partySorted
  })
  #output$info <- renderPrint(input$state[[1]])
  
  output$statePlot <- renderPlot(
    print(ggplot(passData(),aes(x=reorder(party,votes), y=votes))+geom_bar(stat="identity",fill="yellow",colour="black")+ coord_flip() +
        ggtitle(paste("Vote distribution among parties in",input$state[[1]])) +
        geom_text(aes(y=pos,label=percent),size=5,colour="black",position="identity") +
        #scale_y_continuous(breaks=seq(from=0, to=max(partySorted$votes), by=floor(max(partySorted$votes)/5))) +
        scale_y_continuous(breaks=NULL) +
        labs(y="Votes",x="Party")
        )
    )
})

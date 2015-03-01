library(shiny)

election_result=read.csv(url("https://raw.githubusercontent.com/kuberiitb/analytics/master/const_wise_election_result_2014.csv"))

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Election 2014 Result Analysis"),
  
  sidebarLayout(
    
    # Sidebar with a slider input
    sidebarPanel(
      selectInput("state",label="State/UT",
                  choices = unique(election_result$State),selected="Uttar Pradesh"
                  )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      imageOutput("statePlot")  #,textOutput("info")
    )
  )
))

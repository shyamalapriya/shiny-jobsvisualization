library(shiny)
library(plyr)
source("./data-wrangle.R")

shinyServer(function(input,output){
  
  outVarMetrics <- reactive({
    vars <- as.list(levels(income_statement$Financial.Metrics))
    return(vars)
  })
  
  output$metrics = renderUI({
    selectInput('metrics', 'Select Metrics', outVarMetrics())
  })
  
  filteredData<-reactive({
    if(!(is.null(input$metrics) || input$metrics=="")) {
      data<-income_statement[which(income_statement$Financial.Metrics==input$metrics),]
      return(subset(data, select=-c(Financial.Metrics,Company,TTM)))}
    else {
      return(subset(income_statement, select=-c(Financial.Metrics,Company,TTM)))}
  })
  
  output$metricPlot <- renderPlot({
    barplot(as.matrix(filteredData()),
            #names.arg=wrap.labels(sort1.aggr_dataset()[1:10,1],15),
            xlab="Year",
            ylab=input$metrics,
            main=input$metrics,
            border="black",
            beside=T,
            col=c("darkgreen","orange"))
    legend("topleft",  
           fill=c("darkgreen","orange"), 
           legend=levels(income_statement$Company)  )
  })
  
  # Implementation for second tab
  
  output$salaryPlot <- renderPlot({
    barplot(as.matrix(subset(plot_data, select=-c(Title))),
            #names.arg=list(plot_data$Title),
            xlab="Market Vs Chegg",
            ylab="Salary",
            ylim=c(0,250000),
            main="Market vs Chegg",
            border="black",beside=T,
            col=c("green","orange","blue","brown"))
    legend("top", 
           legend=levels(plot_data$Title),fill=c("green","orange","blue","brown"))
  })
  
  
})